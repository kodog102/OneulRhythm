//
//  LiveActivityStateAccent.swift
//  OneulRhythmShared
//
//  Sprint 21-9 — single mutually exclusive Live Activity visual-state policy.
//  Presentation only — does not change ActivityKit lifecycle or business state.
//

import SwiftUI

/// Hybrid near-completion window for active focus rhythms.
///
/// `nearThreshold = min(maximumCap, totalDuration × ratio)`, then clamped so a
/// minimum running window always remains. Never classifies the entire duration
/// as near completion.
enum LiveActivityNearCompletionPolicy {
    /// Portion of total duration eligible for near completion (before cap).
    static let ratio: Double = 0.20
    /// Upper bound on the near-completion window.
    static let maximumCap: TimeInterval = 5 * 60
    /// Minimum time that must remain classified as running when duration allows.
    static let minimumRunningWindow: TimeInterval = 30

    /// Effective near window length in seconds (0 → never near; stay running until completed).
    static func effectiveNearWindow(totalDuration: TimeInterval) -> TimeInterval {
        guard totalDuration > 0 else { return 0 }
        let ratioThreshold = totalDuration * ratio
        let capped = min(maximumCap, ratioThreshold)
        let maxNearWhileKeepingRunning = max(0, totalDuration - minimumRunningWindow)
        return min(capped, maxNearWhileKeepingRunning)
    }

    static func isNearCompletion(
        focusStart: Date,
        focusEnd: Date,
        now: Date
    ) -> Bool {
        let total = focusEnd.timeIntervalSince(focusStart)
        guard total > 0 else { return false }
        let remaining = focusEnd.timeIntervalSince(now)
        guard remaining > 0 else { return false }
        let elapsed = now.timeIntervalSince(focusStart)
        let nearWindow = effectiveNearWindow(totalDuration: total)
        guard nearWindow > 0 else { return false }
        return remaining <= nearWindow && elapsed >= (total - nearWindow)
    }

    static func isNearCompletion(
        state: TodayRhythmActivityAttributes.ContentState,
        now: Date
    ) -> Bool {
        guard let start = state.focusStart, let end = state.focusEnd, end > start else {
            return false
        }
        return isNearCompletion(focusStart: start, focusEnd: end, now: now)
    }
}

/// Visual state for Live Activity status, accent, dots, and timer mode.
///
/// Production path emits only: scheduled, running, nearCompletion, completed.
/// `paused` remains for source compatibility and must not be emitted.
enum LiveActivityStateAccent: Equatable {
    case scheduled
    case running
    /// Compatibility only — never emitted by `resolve` (no domain pause source).
    case paused
    case nearCompletion
    case completed

    /// Calm accent colors — North Star state language.
    var color: Color {
        switch self {
        case .scheduled:
            // Low-emphasis sage / neutral
            return Color(red: 0.72, green: 0.78, blue: 0.74)
        case .running:
            // Sage green `#A7C8AB`
            return Color(red: 167 / 255, green: 200 / 255, blue: 171 / 255)
        case .paused:
            return Color(red: 0.90, green: 0.72, blue: 0.42)
        case .nearCompletion:
            // Soft orange
            return Color(red: 0.92, green: 0.58, blue: 0.38)
        case .completed:
            // Soft blue
            return Color(red: 0.62, green: 0.74, blue: 0.88)
        }
    }

    var statusLabel: String {
        switch self {
        case .scheduled:
            return "시작 전"
        case .running:
            return "진행 중"
        case .paused:
            return "일시정지"
        case .nearCompletion:
            return "완료 임박"
        case .completed:
            return "완료"
        }
    }

    /// Derives accent from mapped `ContentState` + presentation decision.
    ///
    /// Presentation-only bridge (Sprint 21-11): while `phase` is still `.active`,
    /// `now >= focusEnd` / softClosing may show **completed** without an
    /// Activity.update. This must not select another rhythm or invent overdue /
    /// dayComplete / next-handoff ContentState — those wait for foreground sync.
    static func resolve(
        state: TodayRhythmActivityAttributes.ContentState,
        decision: TodayRhythmLivePresentationDecision,
        now: Date
    ) -> LiveActivityStateAccent {
        // 1. Completed — mapped Snapshot phase, or end-time bridge before next update.
        if decision.primaryFocus == .dayComplete || state.phase == .dayComplete {
            return .completed
        }
        if state.phase == .overdue {
            return .completed
        }
        if state.phase == .active {
            if decision.completionAffordance == .softClosing {
                return .completed
            }
            if let end = state.focusEnd, now >= end {
                return .completed
            }
        }

        // 2. Scheduled — before start / next primary. Never “일시정지”.
        if decision.primaryFocus == .nextRhythm || decision.primaryFocus == .none {
            return .scheduled
        }
        if state.phase == .upcoming || state.phase == .betweenRhythms {
            return .scheduled
        }
        if let start = state.focusStart, now < start {
            return .scheduled
        }

        // 3–4. Active focus window.
        if state.phase == .active {
            if LiveActivityNearCompletionPolicy.isNearCompletion(state: state, now: now) {
                return .nearCompletion
            }
            return .running
        }

        // Safe fallback — never infer paused.
        return .scheduled
    }

    /// Convenience: evaluate policy + resolve in one call.
    static func resolve(
        state: TodayRhythmActivityAttributes.ContentState,
        now: Date
    ) -> LiveActivityStateAccent {
        let decision = TodayRhythmLivePresentationPolicy.evaluate(
            contentState: state,
            now: now
        )
        return resolve(state: state, decision: decision, now: now)
    }
}
