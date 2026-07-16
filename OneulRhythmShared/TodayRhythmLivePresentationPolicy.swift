//
//  TodayRhythmLivePresentationPolicy.swift
//  OneulRhythm
//

import Foundation

/// Semantic primary content for Live Activity surfaces.
enum TodayRhythmLivePrimaryFocus: Equatable {
    case focusRhythm
    case nextRhythm
    case dayComplete
    case none
}

/// Quiet secondary content when contextually useful.
enum TodayRhythmLiveSecondaryFocus: Equatable {
    case none
    case nextPreview
}

/// How remaining or upcoming time should be expressed.
enum TodayRhythmLiveRemainingTimeMode: Equatable {
    case hidden
    case countdownToFocusEnd
    case countdownToNextStart
    case absoluteNextStart
}

/// Whether completion can appear, and how softly.
enum TodayRhythmLiveCompletionAffordance: Equatable {
    case hidden
    case available
    case softClosing
}

/// Presentation intensity — semantic, not layout-specific.
enum TodayRhythmLivePresentationStyle: Equatable {
    case focused
    case preview
    case minimal
    case completion
}

/// Shared presentation decision for Lock Screen, Dynamic Island, and future surfaces.
struct TodayRhythmLivePresentationDecision: Equatable {
    let primaryFocus: TodayRhythmLivePrimaryFocus
    let secondaryFocus: TodayRhythmLiveSecondaryFocus
    let remainingTimeMode: TodayRhythmLiveRemainingTimeMode
    let completionAffordance: TodayRhythmLiveCompletionAffordance
    let style: TodayRhythmLivePresentationStyle

    /// Semantic signal that the day Live Activity should end.
    let shouldEndActivity: Bool
}

/// Pure presentation policy for Live Activity surfaces.
///
/// Owns product behavior thresholds. UI owns appearance and copy.
enum TodayRhythmLivePresentationPolicy {
    /// Show next preview during an active focus when this much time (or less) remains.
    static let activeNextPreviewThreshold: TimeInterval = 5 * 60

    /// Treat the next rhythm as near when it starts within this interval.
    static let betweenRhythmsNearThreshold: TimeInterval = 30 * 60

    /// Completion unlocks after the focus has been active this long.
    static let completionUnlockDelay: TimeInterval = 1 * 60

    /// Evaluates presentation decisions from Activity content and an explicit clock.
    static func evaluate(
        contentState: TodayRhythmActivityAttributes.ContentState,
        now: Date
    ) -> TodayRhythmLivePresentationDecision {
        switch contentState.phase {
        case .active:
            return evaluateActive(contentState: contentState, now: now)
        case .overdue:
            return evaluateOverdue(contentState: contentState, now: now)
        case .upcoming, .betweenRhythms:
            return evaluateUpcomingOrBetween(contentState: contentState, now: now)
        case .dayComplete:
            return evaluateDayComplete(contentState: contentState, now: now)
        }
    }

    // MARK: - Active

    private static func evaluateActive(
        contentState: TodayRhythmActivityAttributes.ContentState,
        now: Date
    ) -> TodayRhythmLivePresentationDecision {
        let completion = completionAffordance(
            focusStart: contentState.focusStart,
            focusEnd: contentState.focusEnd,
            now: now
        )

        guard let focusEnd = contentState.focusEnd else {
            return TodayRhythmLivePresentationDecision(
                primaryFocus: .focusRhythm,
                secondaryFocus: .none,
                remainingTimeMode: .hidden,
                completionAffordance: completion,
                style: .focused,
                shouldEndActivity: false
            )
        }

        let remainingUntilEnd = focusEnd.timeIntervalSince(now)

        if remainingUntilEnd <= 0 {
            return TodayRhythmLivePresentationDecision(
                primaryFocus: .focusRhythm,
                secondaryFocus: .none,
                remainingTimeMode: .hidden,
                completionAffordance: .softClosing,
                style: .focused,
                shouldEndActivity: false
            )
        }

        if remainingUntilEnd > activeNextPreviewThreshold {
            return TodayRhythmLivePresentationDecision(
                primaryFocus: .focusRhythm,
                secondaryFocus: .none,
                remainingTimeMode: .countdownToFocusEnd,
                completionAffordance: completion,
                style: .focused,
                shouldEndActivity: false
            )
        }

        if hasNextRhythm(contentState) {
            return TodayRhythmLivePresentationDecision(
                primaryFocus: .focusRhythm,
                secondaryFocus: .nextPreview,
                remainingTimeMode: .countdownToFocusEnd,
                completionAffordance: completion,
                style: .preview,
                shouldEndActivity: false
            )
        }

        return TodayRhythmLivePresentationDecision(
            primaryFocus: .focusRhythm,
            secondaryFocus: .none,
            remainingTimeMode: .countdownToFocusEnd,
            completionAffordance: completion,
            style: .focused,
            shouldEndActivity: false
        )
    }

    // MARK: - Overdue

    private static func evaluateOverdue(
        contentState: TodayRhythmActivityAttributes.ContentState,
        now: Date
    ) -> TodayRhythmLivePresentationDecision {
        // DR-007: once overdue, the experience returns to a single focus.
        // The next rhythm stays hidden until a new active/upcoming phase begins.
        TodayRhythmLivePresentationDecision(
            primaryFocus: .focusRhythm,
            secondaryFocus: .none,
            remainingTimeMode: .hidden,
            completionAffordance: .softClosing,
            style: .focused,
            shouldEndActivity: false
        )
    }

    // MARK: - Upcoming / Between

    private static func evaluateUpcomingOrBetween(
        contentState: TodayRhythmActivityAttributes.ContentState,
        now: Date
    ) -> TodayRhythmLivePresentationDecision {
        guard hasNextRhythm(contentState) else {
            return TodayRhythmLivePresentationDecision(
                primaryFocus: .none,
                secondaryFocus: .none,
                remainingTimeMode: .hidden,
                completionAffordance: .hidden,
                style: .minimal,
                shouldEndActivity: false
            )
        }

        guard let nextStart = contentState.nextStart else {
            return TodayRhythmLivePresentationDecision(
                primaryFocus: .nextRhythm,
                secondaryFocus: .none,
                remainingTimeMode: .hidden,
                completionAffordance: .hidden,
                style: .minimal,
                shouldEndActivity: false
            )
        }

        let untilNext = nextStart.timeIntervalSince(now)

        if untilNext <= betweenRhythmsNearThreshold {
            return TodayRhythmLivePresentationDecision(
                primaryFocus: .nextRhythm,
                secondaryFocus: .none,
                remainingTimeMode: .countdownToNextStart,
                completionAffordance: .hidden,
                style: .preview,
                shouldEndActivity: false
            )
        }

        return TodayRhythmLivePresentationDecision(
            primaryFocus: .nextRhythm,
            secondaryFocus: .none,
            remainingTimeMode: .absoluteNextStart,
            completionAffordance: .hidden,
            style: .minimal,
            shouldEndActivity: false
        )
    }

    // MARK: - Day complete

    private static func evaluateDayComplete(
        contentState: TodayRhythmActivityAttributes.ContentState,
        now: Date
    ) -> TodayRhythmLivePresentationDecision {
        // Day complete semantically means the Live Activity ends immediately.
        // The peaceful completion experience continues in TodayView, not here.
        TodayRhythmLivePresentationDecision(
            primaryFocus: .dayComplete,
            secondaryFocus: .none,
            remainingTimeMode: .hidden,
            completionAffordance: .hidden,
            style: .completion,
            shouldEndActivity: true
        )
    }

    // MARK: - Completion

    private static func completionAffordance(
        focusStart: Date?,
        focusEnd: Date?,
        now: Date
    ) -> TodayRhythmLiveCompletionAffordance {
        guard let focusStart else {
            return .hidden
        }

        if now < focusStart {
            return .hidden
        }

        guard let focusEnd else {
            return .hidden
        }

        if now >= focusEnd {
            return .softClosing
        }

        let totalDuration = focusEnd.timeIntervalSince(focusStart)
        if totalDuration < completionUnlockDelay {
            return .available
        }

        let unlockAt = focusStart.addingTimeInterval(completionUnlockDelay)
        if now < unlockAt {
            return .hidden
        }

        return .available
    }

    // MARK: - Helpers

    private static func hasNextRhythm(
        _ contentState: TodayRhythmActivityAttributes.ContentState
    ) -> Bool {
        contentState.nextRoutineID != nil
            || contentState.nextTitle != nil
            || contentState.nextStart != nil
    }
}
