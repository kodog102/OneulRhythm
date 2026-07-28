//
//  LiveActivityCoordinator.swift
//  OneulRhythm
//

import ActivityKit
import Foundation
import os

/// Owns the one-day Live Activity lifecycle via ActivityKit.
///
/// Flow: `TodayRhythmSnapshot` → mapper → reconciliation.
///
/// **Foreground sync is authoritative** (Sprint 21-11 / Option A):
/// ContentState pushes happen when Today rebuilds a Snapshot (launch, scene
/// active, Today visible, timeline boundary while Today is active, mutations).
/// There is no BGTaskScheduler, push-to-Live-Activity, or background polling.
///
/// While suspended/locked/backgrounded, ContentState updates are not guaranteed.
/// The widget may derive presentation-only running → nearCompletion → completed
/// from existing focus dates; it must not invent next-rhythm handoff, overdue
/// phase, or dayComplete. Next-rhythm handoff waits for the next foreground sync.
///
/// All ActivityKit-mutating calls (request/update/end) are serialized through
/// `pendingActivityTask` so repeated `sync()` calls can never race or apply out
/// of order. Each queued job re-reads `Activity<...>.activities` fresh, so a
/// later sync always sees the true current state rather than a stale snapshot.
///
/// Day complete ends the Live Activity immediately. The peaceful completion
/// experience itself lives in `TodayView`, not in a lingering Live Activity —
/// this coordinator never keeps an activity alive after it has ended, and
/// never re-acts on an activity ActivityKit already considers `.ended`.
@MainActor
final class LiveActivityCoordinator: LiveActivityCoordinating {
    private static let logger = Logger(
        subsystem: Bundle.main.bundleIdentifier ?? "OneulRhythm",
        category: "LiveActivity"
    )

    private let calendar: Calendar
    private let nowProvider: () -> Date
    private var pendingActivityTask: Task<Void, Never>?
    private var operationGeneration = 0

    init(
        calendar: Calendar = .current,
        nowProvider: @escaping () -> Date = Date.init
    ) {
        self.calendar = calendar
        self.nowProvider = nowProvider
    }

    func sync(snapshot: TodayRhythmSnapshot) {
        guard ActivityAuthorizationInfo().areActivitiesEnabled else {
            // Best-effort cleanup only. Today itself never depends on this.
            enqueueEndAll()
            return
        }

        let now = nowProvider()
        let payload = TodayRhythmActivityMapper.map(
            snapshot: snapshot,
            calendar: calendar,
            updatedAt: now
        )

        enqueueReconcile(desiredPayload: payload)
    }

    func end() {
        enqueueEndAll()
    }

    // MARK: - Serialized ActivityKit work

    /// Chains ActivityKit-mutating work after any in-flight work so calls apply in order.
    private func enqueue(_ work: @escaping @MainActor () async -> Void) {
        let previous = pendingActivityTask
        operationGeneration += 1
        let generation = operationGeneration

        let task = Task { [weak self] in
            await previous?.value
            guard let self else { return }
            await work()
            // Clear the reference once the chain drains, as long as nothing
            // newer has been enqueued in the meantime.
            if self.operationGeneration == generation {
                self.pendingActivityTask = nil
            }
        }
        pendingActivityTask = task
    }

    private func enqueueReconcile(desiredPayload: TodayRhythmActivityPayload?) {
        enqueue { [weak self] in
            guard let self else { return }
            await self.reconcile(desiredPayload: desiredPayload)
        }
    }

    private func enqueueEndAll() {
        enqueue { [weak self] in
            guard let self else { return }
            await self.endEligibleActivities { _ in true }
        }
    }

    // MARK: - Reconciliation

    /// Reconciles every `OneulRhythm` day activity against a single desired payload.
    ///
    /// `nil` means the snapshot was empty: end everything active/stale, start nothing.
    private func reconcile(desiredPayload: TodayRhythmActivityPayload?) async {
        let allActivities = Activity<TodayRhythmActivityAttributes>.activities
        let sessions = allActivities.map { activity in
            LiveActivitySessionDescriptor(
                id: activity.id,
                dayID: activity.attributes.dayID,
                phase: activity.content.state.phase,
                updatedAt: activity.content.state.updatedAt,
                isEligible: isEligibleForUpdate(activity)
            )
        }

        let commands = LiveActivityReconcilePlanner.plan(
            desiredPayload: desiredPayload,
            sessions: sessions
        )

        for command in commands {
            await execute(command, activities: allActivities)
        }
    }

    private func execute(
        _ command: LiveActivityReconcileCommand,
        activities: [Activity<TodayRhythmActivityAttributes>]
    ) async {
        switch command {
        case .endAllEligible:
            await endEligibleActivities(in: activities) { _ in true }

        case let .endOtherDays(keepingDayID):
            await endEligibleActivities(in: activities) { $0.attributes.dayID != keepingDayID }

        case let .endDayComplete(activityIDs, content):
            let content = ActivityContent(state: content, staleDate: nil)
            for activity in activities where activityIDs.contains(activity.id) {
                guard isEligibleForUpdate(activity) else { continue }
                await activity.end(content, dismissalPolicy: .immediate)
            }

        case let .endDuplicates(activityIDs):
            for activity in activities where activityIDs.contains(activity.id) {
                guard isEligibleForUpdate(activity) else { continue }
                await activity.end(nil, dismissalPolicy: .immediate)
            }

        case let .update(activityID, content):
            guard let activity = activities.first(where: { $0.id == activityID }),
                  isEligibleForUpdate(activity) else { return }
            await activity.update(ActivityContent(state: content, staleDate: nil))

        case let .request(payload):
            requestActivity(payload: payload)
        }
    }

    /// Only `.active`/`.stale` activities can still receive `update()`/`end()`
    /// with new content. `.ended`/`.dismissed` are excluded and never re-acted
    /// upon — ActivityKit does not document behavior for ending an activity twice.
    private func isEligibleForUpdate(
        _ activity: Activity<TodayRhythmActivityAttributes>
    ) -> Bool {
        switch activity.activityState {
        case .active, .stale:
            return true
        case .ended, .dismissed, .pending:
            return false
        @unknown default:
            return false
        }
    }

    private func endEligibleActivities(
        in activities: [Activity<TodayRhythmActivityAttributes>]? = nil,
        where shouldEnd: (Activity<TodayRhythmActivityAttributes>) -> Bool
    ) async {
        let source = activities ?? Activity<TodayRhythmActivityAttributes>.activities
        for activity in source where isEligibleForUpdate(activity) && shouldEnd(activity) {
            await activity.end(nil, dismissalPolicy: .immediate)
        }
    }

    private func requestActivity(payload: TodayRhythmActivityPayload) {
        do {
            // Local Live Activity only — no Push-to-Live-Activity (`pushType: nil`).
            _ = try Activity.request(
                attributes: payload.attributes,
                content: ActivityContent(
                    state: payload.contentState,
                    staleDate: nil
                ),
                pushType: nil
            )
        } catch {
            // Best-effort: Today remains authoritative. No user-facing error UI.
            #if DEBUG
            Self.logger.error(
                "Activity.request failed: \(String(describing: error), privacy: .public)"
            )
            #endif
        }
    }
}
