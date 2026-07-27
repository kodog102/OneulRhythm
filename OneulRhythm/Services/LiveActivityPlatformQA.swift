//
//  LiveActivityPlatformQA.swift
//  OneulRhythm
//
//  DEBUG-only ActivityKit session bootstrap for Live Activity platform QA.
//  Does not alter production lifecycle policy or mapper.
//

#if DEBUG
import ActivityKit
import Foundation
import os

/// Starts (and optionally updates / ends) a deterministic Live Activity when
/// launched with `-ORLiveActivityPlatformQA`.
///
/// Launch examples:
/// - `-ORLiveActivityPlatformQA`
/// - `-ORLiveActivityPlatformQA -ORLiveActivityPlatformQALong`
/// - `-ORLiveActivityPlatformQA -ORLiveActivityPlatformQAUpdate`
/// - `-ORLiveActivityPlatformQA -ORLiveActivityPlatformQAEnd`
/// - `-ORLiveActivityPlatformQAStatus` (log active list only; suspends reconcile)
///
/// When a QA flag is present, production `LiveActivityCoordinator` is
/// suspended (noop) so empty-day reconcile cannot discard the fixture Activity.
@MainActor
enum LiveActivityPlatformQA {
    private static let logger = Logger(
        subsystem: Bundle.main.bundleIdentifier ?? "OneulRhythm",
        category: "LiveActivityPlatformQA"
    )

    private static let launchFlag = "-ORLiveActivityPlatformQA"
    private static let longFlag = "-ORLiveActivityPlatformQALong"
    private static let updateFlag = "-ORLiveActivityPlatformQAUpdate"
    private static let endFlag = "-ORLiveActivityPlatformQAEnd"
    private static let statusFlag = "-ORLiveActivityPlatformQAStatus"

    /// True when process was launched for platform QA — suspend production LA reconcile.
    static var isRequested: Bool {
        let args = ProcessInfo.processInfo.arguments
        return args.contains(launchFlag) || args.contains(statusFlag)
    }

    /// No-op stand-in so empty Today snapshot cannot end the QA Activity.
    static var suspendedCoordinator: LiveActivityCoordinating {
        SuspendedLiveActivityCoordinator()
    }

    static func runIfRequested() {
        let args = ProcessInfo.processInfo.arguments
        guard args.contains(launchFlag) || args.contains(statusFlag) else { return }

        logger.info("QA flag detected; coordinator suspended")

        Task { @MainActor in
            try? await Task.sleep(nanoseconds: 800_000_000)
            if args.contains(statusFlag), !args.contains(launchFlag) {
                logActiveActivities(context: "status-only")
                return
            }
            await perform(args: args)
        }
    }

    static func logActiveActivities(context: String) {
        let activities = Activity<TodayRhythmActivityAttributes>.activities
        logger.info(
            "Active list (\(context, privacy: .public)) count=\(activities.count, privacy: .public)"
        )
        for activity in activities {
            let state = activity.content.state
            logger.info(
                "id=\(activity.id, privacy: .public) state=\(String(describing: activity.activityState), privacy: .public) phase=\(state.phase.rawValue, privacy: .public) title=\(state.focusTitle ?? "nil", privacy: .public)"
            )
        }
    }

    private struct SuspendedLiveActivityCoordinator: LiveActivityCoordinating {
        func sync(snapshot: TodayRhythmSnapshot) {}
        func end() {}
    }

    private static func perform(args: [String]) async {
        guard ActivityAuthorizationInfo().areActivitiesEnabled else {
            logger.error("ActivityKit disabled — cannot run platform QA")
            return
        }

        for activity in Activity<TodayRhythmActivityAttributes>.activities {
            await activity.end(nil, dismissalPolicy: .immediate)
        }

        if args.contains(endFlag) {
            logActiveActivities(context: "after-end-only")
            logger.info("Platform QA end-only complete")
            return
        }

        let now = Date()
        let dayStart = Calendar.current.startOfDay(for: now)
        let dayID = ISO8601DateFormatter().string(from: dayStart)
        let useLong = args.contains(longFlag)
        let initial = contentState(now: now, long: useLong, nearEnd: true)

        do {
            let activity = try Activity.request(
                attributes: TodayRhythmActivityAttributes(
                    dayID: "platform-qa-\(dayID)",
                    calendarDayStart: dayStart
                ),
                content: ActivityContent(state: initial, staleDate: nil),
                pushType: nil
            )
            logger.info(
                "Activity.request succeeded id=\(activity.id, privacy: .public) state=\(String(describing: activity.activityState), privacy: .public)"
            )
            logActiveActivities(context: "after-request")

            if args.contains(updateFlag) {
                try? await Task.sleep(nanoseconds: 2_000_000_000)
                let updated = contentState(now: Date(), long: useLong, nearEnd: true)
                await activity.update(ActivityContent(state: updated, staleDate: nil))
                logger.info("Platform QA activity updated id=\(activity.id, privacy: .public)")
                logActiveActivities(context: "after-update")
            }
        } catch {
            logger.error("Platform QA request failed: \(String(describing: error), privacy: .public)")
        }
    }

    /// `nearEnd` keeps next-preview visible (≤5 min remaining per policy).
    private static func contentState(
        now: Date,
        long: Bool,
        nearEnd: Bool
    ) -> TodayRhythmActivityAttributes.ContentState {
        let title = long
            ? "아침부터 저녁까지 이어지는 아주 긴 오늘의 리듬 이름도 잘려 보이지 않아야 합니다"
            : "따뜻한 차 한잔 마시기"
        let next = long
            ? "다음에 이어질 아주 길고 자세한 리듬 미리보기 제목"
            : "가벼운 산책"
        let focusEnd = now.addingTimeInterval(nearEnd ? 3 * 60 : 20 * 60)

        return TodayRhythmActivityAttributes.ContentState(
            phase: .active,
            focusRoutineID: "platform-qa-focus",
            focusTitle: title,
            focusStart: now.addingTimeInterval(-10 * 60),
            focusEnd: focusEnd,
            nextRoutineID: "platform-qa-next",
            nextTitle: next,
            nextStart: now.addingTimeInterval(30 * 60),
            updatedAt: now
        )
    }
}
#endif
