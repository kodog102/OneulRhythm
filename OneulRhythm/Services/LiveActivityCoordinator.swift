//
//  LiveActivityCoordinator.swift
//  OneulRhythm
//

import ActivityKit
import Foundation

/// Owns the one-day Live Activity lifecycle via ActivityKit.
///
/// Flow: `TodayRhythmSnapshot` → mapper → reconciliation.
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
        guard let desiredPayload else {
            await endEligibleActivities { _ in true }
            return
        }

        let dayID = desiredPayload.attributes.dayID
        let allActivities = Activity<TodayRhythmActivityAttributes>.activities

        // Previous-day cleanup: never let a different day's activity linger
        // once today has something to show.
        await endEligibleActivities(in: allActivities) { $0.attributes.dayID != dayID }

        // Only activities that can still receive updates are candidates.
        // Already-`.ended`/`.dismissed` activities are never re-acted upon.
        let sameDayEligible = allActivities.filter {
            $0.attributes.dayID == dayID && isEligibleForUpdate($0)
        }

        if desiredPayload.contentState.phase == .dayComplete {
            // Day complete ends the day's Live Activity immediately. There is
            // no lingering state: the peaceful completion experience lives in
            // TodayView, not on the Lock Screen. Never request a replacement.
            let content = ActivityContent(state: desiredPayload.contentState, staleDate: nil)
            for activity in sameDayEligible {
                await activity.end(content, dismissalPolicy: .immediate)
            }
            return
        }

        let canonical = selectCanonical(from: sameDayEligible)

        // Same-day duplicate cleanup: only ever expected transiently, but
        // reconciliation must never rely on array order to decide the winner.
        for activity in sameDayEligible where activity.id != canonical?.id {
            await activity.end(nil, dismissalPolicy: .immediate)
        }

        if let canonical {
            await update(canonical, with: desiredPayload)
        } else {
            requestActivity(payload: desiredPayload)
        }
    }

    private func update(
        _ activity: Activity<TodayRhythmActivityAttributes>,
        with payload: TodayRhythmActivityPayload
    ) async {
        await activity.update(ActivityContent(state: payload.contentState, staleDate: nil))
    }

    /// Latest `content.state.updatedAt` wins; ties break on the
    /// lexicographically smallest `id` so selection never depends on array order.
    private func selectCanonical(
        from activities: [Activity<TodayRhythmActivityAttributes>]
    ) -> Activity<TodayRhythmActivityAttributes>? {
        activities.min { lhs, rhs in
            let lhsUpdatedAt = lhs.content.state.updatedAt
            let rhsUpdatedAt = rhs.content.state.updatedAt
            if lhsUpdatedAt != rhsUpdatedAt {
                return lhsUpdatedAt > rhsUpdatedAt
            }
            return lhs.id < rhs.id
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
            _ = try Activity.request(
                attributes: payload.attributes,
                content: ActivityContent(
                    state: payload.contentState,
                    staleDate: nil
                ),
                pushType: nil
            )
        } catch {
            // Live Activity is best-effort; Today screen stays authoritative.
        }
    }
}
