//
//  TodayRhythmLiveActivityWidget.swift
//  OneulRhythmWidgets
//

import ActivityKit
import SwiftUI
import WidgetKit

struct TodayRhythmLiveActivityWidget: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: TodayRhythmActivityAttributes.self) { context in
            TodayRhythmLockScreenView(
                state: context.state,
                now: Date()
            )
            .activityBackgroundTint(Color(red: 0.97, green: 0.95, blue: 0.91))
            .activitySystemActionForegroundColor(Color(red: 0.52, green: 0.64, blue: 0.54))
        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.leading) {
                    Text("🌿")
                }
                DynamicIslandExpandedRegion(.center) {
                    TodayRhythmIslandExpandedView(
                        state: context.state,
                        now: Date()
                    )
                }
            } compactLeading: {
                Text("🌿")
            } compactTrailing: {
                if let title = TodayRhythmLiveActivityCopy.primaryTitle(state: context.state, now: Date()) {
                    Text(title)
                        .font(.caption2)
                        .lineLimit(1)
                        .minimumScaleFactor(0.7)
                }
            } minimal: {
                Text("🌿")
            }
        }
    }
}

// MARK: - Lock Screen MVP

private struct TodayRhythmLockScreenView: View {
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

        VStack(alignment: .leading, spacing: 8) {
            Text("🌿")
                .font(.title3)

            if let title {
                Text(title)
                    .font(.headline)
                    .foregroundStyle(Color(red: 0.20, green: 0.19, blue: 0.18))
                    .lineLimit(2)
                    .minimumScaleFactor(0.85)
            }

            if let remaining {
                Text(remaining)
                    .font(.subheadline)
                    .foregroundStyle(Color(red: 0.52, green: 0.50, blue: 0.47))
                    .lineLimit(1)
            }

            if let secondaryPreview {
                Text(secondaryPreview)
                    .font(.caption)
                    .foregroundStyle(Color(red: 0.63, green: 0.61, blue: 0.58))
                    .lineLimit(1)
                    .minimumScaleFactor(0.9)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
    }
}

// MARK: - Dynamic Island Expanded MVP

private struct TodayRhythmIslandExpandedView: View {
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

        VStack(alignment: .leading, spacing: 4) {
            if let title {
                Text(title)
                    .font(.headline)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
            }

            if let remaining {
                Text(remaining)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

// MARK: - UI copy (presentation layer only)

private enum TodayRhythmLiveActivityCopy {
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
            return "오늘의 리듬을 잘 마무리했어요"
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

#if DEBUG
private struct TodayRhythmLiveActivityWidget_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            TodayRhythmLockScreenView(
                state: .previewActive,
                now: Date()
            )
            .padding()
            .background(Color(red: 0.97, green: 0.95, blue: 0.91))
            .previewDisplayName("Lock Screen MVP")

            TodayRhythmIslandExpandedView(
                state: .previewActive,
                now: Date()
            )
            .padding()
            .background(Color.black)
            .foregroundStyle(.white)
            .previewDisplayName("Dynamic Island Expanded MVP")
        }
    }
}
#endif
