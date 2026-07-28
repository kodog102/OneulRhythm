//
//  TodayRhythmLiveActivityPresentation.swift
//  OneulRhythmShared
//
//  Live Activity presentation views — shared so Lock Screen / Island stay aligned
//  with Design System tokens (DR-021). ActivityKit configuration stays in the
//  Widget extension. No lifecycle or mapping logic here.
//

import SwiftUI

// MARK: - Brand Presence (quiet)

/// Compact Breath Flow for Live Activity / Dynamic Island.
/// Presence only — never a competing hero.
struct BreathFlowMark: View {
    let size: CGFloat

    var body: some View {
        Image("BreathFlow")
            .resizable()
            .interpolation(.high)
            .scaledToFit()
            .frame(width: size, height: size)
            .accessibilityHidden(true)
    }
}

// MARK: - Lock Screen

/// Warm Light Lock Screen presentation — cream field + Design System tokens (DR-021).
struct TodayRhythmLockScreenView: View {
    let state: TodayRhythmActivityAttributes.ContentState
    let now: Date

    var body: some View {
        let decision = TodayRhythmLivePresentationPolicy.evaluate(
            contentState: state,
            now: now
        )
        let title = TodayRhythmLiveActivityCopy.primaryTitle(
            state: state,
            decision: decision
        )
        let remaining = TodayRhythmLiveActivityCopy.remainingTimeText(
            state: state,
            decision: decision,
            now: now
        )
        let secondaryPreview = TodayRhythmLiveActivityCopy.secondaryPreviewTitle(
            state: state,
            decision: decision
        )

        VStack(alignment: .leading, spacing: ORSpacing.xs) {
            BreathFlowMark(size: 28)

            if let title {
                // Primary: current rhythm — strongest type on the Lock Screen.
                Text(title)
                    .orTypography(.body, weight: .semibold)
                    .foregroundStyle(ORColors.textPrimary)
                    .lineLimit(2)
                    .minimumScaleFactor(0.85)
            }

            if let remaining {
                // Secondary: remaining / clock time.
                Text(remaining)
                    .orTypography(.caption)
                    .foregroundStyle(ORColors.textSecondary)
                    .lineLimit(1)
            }

            if let secondaryPreview {
                // Tertiary: quiet next-rhythm preview — never equal to primary.
                Text(secondaryPreview)
                    .orTypography(.caption)
                    .foregroundStyle(ORColors.textTertiary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.9)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(ORSpacing.md)
    }
}

// MARK: - Dynamic Island Expanded

/// Expanded Island content. Platform owns dark materials; app owns hierarchy only.
struct TodayRhythmIslandExpandedView: View {
    let state: TodayRhythmActivityAttributes.ContentState
    let now: Date

    var body: some View {
        let decision = TodayRhythmLivePresentationPolicy.evaluate(
            contentState: state,
            now: now
        )
        let title = TodayRhythmLiveActivityCopy.primaryTitle(
            state: state,
            decision: decision
        )
        let remaining = TodayRhythmLiveActivityCopy.remainingTimeText(
            state: state,
            decision: decision,
            now: now
        )

        VStack(alignment: .leading, spacing: ORSpacing.xxs) {
            if let title {
                Text(title)
                    .orTypography(.body, weight: .semibold)
                    .foregroundStyle(.white)
                    .lineLimit(1)
                    .minimumScaleFactor(0.75)
                    .frame(maxWidth: .infinity, alignment: .leading)

            }

            if let remaining {
                // Explicit light secondary — avoids scheme-dependent `.secondary` on dark Island chrome.
                // Kept as a dedicated second line so remaining time is not clipped by a long title.
                Text(remaining)
                    .orTypography(.caption)
                    .foregroundStyle(Color.white.opacity(0.72))
                    .lineLimit(1)
                    .minimumScaleFactor(0.85)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .fixedSize(horizontal: false, vertical: true)
    }
}

// MARK: - Compact / Minimal helpers (Widget composes ActivityKit slots)

enum TodayRhythmLiveActivityIslandMetrics {
    static let expandedMark: CGFloat = 18
    static let compactMark: CGFloat = 14
    static let minimalMark: CGFloat = 12
}

// MARK: - UI copy (presentation layer only)

enum TodayRhythmLiveActivityCopy {
    static func primaryTitle(
        state: TodayRhythmActivityAttributes.ContentState,
        now: Date
    ) -> String? {
        let decision = TodayRhythmLivePresentationPolicy.evaluate(
            contentState: state,
            now: now
        )
        return primaryTitle(state: state, decision: decision)
    }

    static func primaryTitle(
        state: TodayRhythmActivityAttributes.ContentState,
        decision: TodayRhythmLivePresentationDecision
    ) -> String? {
        switch decision.primaryFocus {
        case .focusRhythm:
            return state.focusTitle
        case .nextRhythm:
            return state.nextTitle
        case .dayComplete:
            // Shared closure voice with Today (DR-017).
            return "오늘의 리듬을 모두 마쳤어요."
        case .none:
            return state.focusTitle ?? state.nextTitle
        }
    }

    /// Quiet next-rhythm preview shown only during a natural transition (DR-009).
    /// Intentionally has no label such as "다음" or "곧" — order and quiet styling
    /// communicate meaning instead.
    static func secondaryPreviewTitle(
        state: TodayRhythmActivityAttributes.ContentState,
        decision: TodayRhythmLivePresentationDecision
    ) -> String? {
        guard decision.secondaryFocus == .nextPreview else { return nil }
        return state.nextTitle
    }

    /// Sprint 6-1 renders truthful, locale-aware absolute clock times instead
    /// of relative minute countdowns. A countdown string only stays accurate
    /// while something keeps recomputing it; without a backend or push, this
    /// surface can go long stretches without a fresh render, so a clock time
    /// (always true regardless of when it is drawn) replaces it. Policy still
    /// decides *whether* time should be shown and *which* moment it anchors to.
    static func remainingTimeText(
        state: TodayRhythmActivityAttributes.ContentState,
        decision: TodayRhythmLivePresentationDecision,
        now: Date
    ) -> String? {
        switch decision.remainingTimeMode {
        case .hidden:
            return nil

        case .countdownToFocusEnd:
            guard let focusEnd = state.focusEnd else { return nil }
            return clockTimeText(for: focusEnd, suffix: "까지")

        case .countdownToNextStart, .absoluteNextStart:
            guard let nextStart = state.nextStart else { return nil }
            return clockTimeText(for: nextStart, suffix: nil)
        }
    }

    /// Locale-aware, seconds-free clock time using the device's own locale and
    /// 12/24-hour preference (no forced locale).
    private static func clockTimeText(for date: Date, suffix: String?) -> String {
        let time = date.formatted(Date.FormatStyle(date: .omitted, time: .shortened))
        guard let suffix else { return time }
        return "\(time) \(suffix)"
    }
}
