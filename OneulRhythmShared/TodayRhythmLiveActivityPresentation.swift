//
//  TodayRhythmLiveActivityPresentation.swift
//  OneulRhythmShared
//
//  Live Activity presentation — Sprint 21-4 category identity + state accents.
//  Visual Source of Truth: Docs/Visual/NorthStars/LiveActivity/LiveActivity-NorthStar-v1.png
//
//  Category identity ≠ state accent.
//  ActivityKit configuration stays in the Widget extension.
//  No lifecycle or mapping logic here.
//

import SwiftUI

// MARK: - Visual tokens (Live Activity surface only)

enum TodayRhythmLiveActivityPalette {
    /// Expanded card field — North Star `#2F473A` @ ~85%. Stable across states.
    static let expandedField = Color(red: 47 / 255, green: 71 / 255, blue: 58 / 255)
    /// Inactive progress — white @ 20%.
    static let progressInactive = Color.white.opacity(0.20)
    /// Soft card edge.
    static let edgeStroke = Color.white.opacity(0.08)
    /// Notification / compact light field.
    static let notificationField = Color(red: 0.97, green: 0.96, blue: 0.94)
    static let notificationInk = Color(red: 0.22, green: 0.21, blue: 0.19)
    static let notificationSecondary = Color(red: 0.48, green: 0.47, blue: 0.44)
}

enum TodayRhythmLiveActivityMetrics {
    static let expandedCorner: CGFloat = 16
    static let iconWell: CGFloat = 42
    static let islandExpandedMark: CGFloat = 16
    static let compactMark: CGFloat = 13
    static let minimalMark: CGFloat = 12
    static let progressDotCount: Int = 5
    static let progressDotSize: CGFloat = 6
    static let standByIconWell: CGFloat = 60
    static let trailingColumnWidth: CGFloat = 118
    static let timerTokenWidth: CGFloat = 48
    /// Dynamic Island single state indicator (not daily progress).
    static let islandStateDot: CGFloat = 9
    static let islandStateDotCompact: CGFloat = 8
}

// MARK: - Category identity helpers

enum LiveActivityCategoryIdentity {
    /// Category raw value for the rhythm currently presented as primary.
    static func rawValue(
        state: TodayRhythmActivityAttributes.ContentState,
        decision: TodayRhythmLivePresentationDecision
    ) -> String? {
        switch decision.primaryFocus {
        case .focusRhythm, .none:
            return state.focusCategoryRawValue ?? state.nextCategoryRawValue
        case .nextRhythm:
            return state.nextCategoryRawValue ?? state.focusCategoryRawValue
        case .dayComplete:
            return state.focusCategoryRawValue ?? state.nextCategoryRawValue
        }
    }

    static func style(
        state: TodayRhythmActivityAttributes.ContentState,
        decision: TodayRhythmLivePresentationDecision
    ) -> ORRhythmCategoryStyle {
        ORRhythmCategoryStyle.style(
            forRawValue: rawValue(state: state, decision: decision)
        )
    }
}

// MARK: - Lock Screen / Banner / StandBy host

struct TodayRhythmLockScreenView: View {
    let state: TodayRhythmActivityAttributes.ContentState
    let now: Date

    @State private var containerSize: CGSize = .zero

    var body: some View {
        Group {
            switch LiveActivityPresentationFamily.resolve(size: containerSize) {
            case .standBy:
                TodayRhythmStandByView(state: state, now: now)
            case .notification:
                TodayRhythmNotificationCompactView(state: state, now: now)
            case .expanded:
                TodayRhythmExpandedCardView(state: state, now: now)
            }
        }
        .frame(maxWidth: .infinity)
        .background {
            GeometryReader { proxy in
                Color.clear
                    .preference(key: LiveActivityContainerSizeKey.self, value: proxy.size)
            }
        }
        .onPreferenceChange(LiveActivityContainerSizeKey.self) { containerSize = $0 }
    }
}

private struct LiveActivityContainerSizeKey: PreferenceKey {
    static var defaultValue: CGSize = .zero
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
        value = nextValue()
    }
}

private enum LiveActivityPresentationFamily {
    case expanded
    case notification
    case standBy

    static func resolve(size: CGSize) -> Self {
        if size.width >= 420 && size.width > size.height * 1.35 {
            return .standBy
        }
        if size.height > 0 && size.height < 78 {
            return .notification
        }
        return .expanded
    }
}

// MARK: - Expanded (Lock Screen)

struct TodayRhythmExpandedCardView: View {
    @Environment(\.isLuminanceReduced) private var isLuminanceReduced

    let state: TodayRhythmActivityAttributes.ContentState
    /// Fallback clock for call-site compatibility / first paint.
    let now: Date

    var body: some View {
        // Status / accent / daily progress refresh on explicit Snapshot-aligned
        // transition points (near-end, focusEnd, minute marks). Completion accent
        // follows mapped ContentState.phase / softClosing — not a second clock rule.
        TimelineView(.explicit(presentationDates)) { timeline in
            expandedContent(at: timeline.date)
        }
    }

    /// Near-completion, focus-end, and minute marks for daily progress dots.
    private var presentationDates: [Date] {
        lockScreenPresentationDates(state: state, now: now)
    }

    private func expandedContent(at clock: Date) -> some View {
        let decision = TodayRhythmLivePresentationPolicy.evaluate(
            contentState: state,
            now: clock
        )
        let visualState = LiveActivityStateAccent.resolve(
            state: state,
            decision: decision,
            now: clock
        )
        let category = LiveActivityCategoryIdentity.style(
            state: state,
            decision: decision
        )
        let title = TodayRhythmLiveActivityCopy.primaryTitle(
            state: state,
            decision: decision
        )
        let scheduled = TodayRhythmLiveActivityCopy.scheduledTimeText(
            state: state,
            decision: decision
        )
        let progress = visualState == .scheduled
            ? nil
            : TodayRhythmLiveActivityCopy.focusProgress(
                state: state,
                now: clock
            )

        return HStack(alignment: .center, spacing: 12) {
            LiveActivityCategoryIconWell(
                style: category,
                size: TodayRhythmLiveActivityMetrics.iconWell
            )

            VStack(alignment: .leading, spacing: 4) {
                if let title {
                    Text(title)
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(Color.white)
                        .lineLimit(1)
                        .minimumScaleFactor(0.85)
                }

                if let scheduled {
                    Text(scheduled)
                        .font(.system(size: 13, weight: .medium, design: .rounded))
                        .monospacedDigit()
                        .foregroundStyle(Color.white.opacity(0.68))
                        .lineLimit(1)
                }

                // Lock Screen only — today’s rhythm sequence / progress.
                // Never show elapsed progress before the rhythm starts.
                if let progress, visualState != .scheduled {
                    LiveActivityProgressDots(
                        filledCount: progress.filledDots,
                        totalCount: TodayRhythmLiveActivityMetrics.progressDotCount,
                        accent: visualState.color,
                        emphasizeCurrent: visualState != .completed
                    )
                    .padding(.top, 3)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            LiveActivityTrailingStatusGroup(
                status: visualState.statusLabel,
                accent: visualState.color,
                state: state,
                clock: clock,
                visualState: visualState,
                luminanceReduced: isLuminanceReduced
            )
            .frame(
                width: TodayRhythmLiveActivityMetrics.trailingColumnWidth,
                alignment: .trailing
            )
        }
        .padding(.leading, 14)
        .padding(.trailing, 14)
        .padding(.vertical, 13)
        .background { expandedChrome }
    }

    private var expandedChrome: some View {
        RoundedRectangle(
            cornerRadius: TodayRhythmLiveActivityMetrics.expandedCorner,
            style: .continuous
        )
        .fill(TodayRhythmLiveActivityPalette.expandedField.opacity(0.92))
        .overlay(
            RoundedRectangle(
                cornerRadius: TodayRhythmLiveActivityMetrics.expandedCorner,
                style: .continuous
            )
            .strokeBorder(TodayRhythmLiveActivityPalette.edgeStroke, lineWidth: 1)
        )
    }
}

/// Right-side status + elapsed/duration — one stable visual group.
private struct LiveActivityTrailingStatusGroup: View {
    let status: String
    let accent: Color
    let state: TodayRhythmActivityAttributes.ContentState
    let clock: Date
    let visualState: LiveActivityStateAccent
    let luminanceReduced: Bool

    var body: some View {
        VStack(alignment: .trailing, spacing: 6) {
            Text(status)
                .font(.system(size: 12, weight: .semibold))
                .foregroundStyle(accent)
                .lineLimit(1)
                .frame(maxWidth: .infinity, alignment: .trailing)

            LiveActivityElapsedDurationLabel(
                state: state,
                clock: clock,
                visualState: visualState,
                luminanceReduced: luminanceReduced
            )
            .frame(maxWidth: .infinity, alignment: .trailing)
        }
    }
}

/// Lock Screen elapsed / duration.
///
/// Verified stall cause (Sprint 21-7): driving second-by-second digits with
/// `TimelineView(.animation(minimumInterval: 1))` can stop refreshing after
/// repeated Lock Screen enter/leave. The system does not reliably resume that
/// custom animation schedule in Live Activities.
///
/// Interactive Lock Screen: `Text(timerInterval:)` — system-owned, resumes
/// after lock/unlock, no Activity push per second.
/// Reduced luminance / Always-On: minute-stable formatted `mm:ss` (avoids `--`).
struct LiveActivityElapsedDurationLabel: View {
    let state: TodayRhythmActivityAttributes.ContentState
    let clock: Date
    let visualState: LiveActivityStateAccent
    let luminanceReduced: Bool

    var body: some View {
        if visualState == .scheduled {
            scheduledTimeLabel
        } else if let start = state.focusStart, let end = state.focusEnd, end > start {
            focusElapsedDuration(start: start, end: end)
        } else if let remaining = TodayRhythmLiveActivityCopy.remainingTimeText(
            state: state,
            decision: TodayRhythmLivePresentationPolicy.evaluate(
                contentState: state,
                now: clock
            ),
            now: clock
        ) {
            Text(remaining)
                .font(.system(size: 14, weight: .medium, design: .monospaced))
                .monospacedDigit()
                .foregroundStyle(Color.white.opacity(0.92))
                .frame(
                    width: TodayRhythmLiveActivityMetrics.trailingColumnWidth - 8,
                    alignment: .trailing
                )
                .lineLimit(1)
        }
    }

    @ViewBuilder
    private var scheduledTimeLabel: some View {
        let decision = TodayRhythmLivePresentationPolicy.evaluate(
            contentState: state,
            now: clock
        )
        if let text = TodayRhythmLiveActivityCopy.remainingTimeText(
            state: state,
            decision: decision,
            now: clock
        ) ?? TodayRhythmLiveActivityCopy.scheduledTimeText(
            state: state,
            decision: decision
        ) {
            Text(text)
                .font(.system(size: 14, weight: .medium, design: .monospaced))
                .monospacedDigit()
                .foregroundStyle(Color.white.opacity(0.92))
                .frame(
                    width: TodayRhythmLiveActivityMetrics.trailingColumnWidth - 8,
                    alignment: .trailing
                )
                .lineLimit(1)
        }
    }

    @ViewBuilder
    private func focusElapsedDuration(start: Date, end: Date) -> some View {
        let total = end.timeIntervalSince(start)
        let totalText = TodayRhythmLiveActivityCopy.durationText(interval: total)

        switch visualState {
        case .completed:
            elapsedDurationPair(
                elapsedText: totalText,
                totalText: totalText
            )

        case .scheduled, .paused:
            // No elapsed progress before start; paused is never emitted.
            scheduledTimeLabel

        case .running, .nearCompletion:
            if luminanceReduced {
                // AOD: system timerInterval masks seconds as `--`. Minute-stable text.
                let elapsed = min(max(clock.timeIntervalSince(start), 0), total)
                elapsedDurationPair(
                    elapsedText: TodayRhythmLiveActivityCopy.durationText(
                        interval: Self.flooredToMinute(elapsed)
                    ),
                    totalText: totalText
                )
            } else {
                // Interactive: system-owned live timer — resumes across Lock Screen cycles.
                systemTimerIntervalPair(start: start, end: end, totalText: totalText)
            }
        }
    }

    private func systemTimerIntervalPair(
        start: Date,
        end: Date,
        totalText: String
    ) -> some View {
        HStack(alignment: .firstTextBaseline, spacing: 4) {
            Text(
                timerInterval: start...end,
                pauseTime: nil,
                countsDown: false,
                showsHours: false
            )
            .multilineTextAlignment(.trailing)
            .frame(
                width: TodayRhythmLiveActivityMetrics.timerTokenWidth,
                alignment: .trailing
            )

            Text("/")
                .frame(width: 8, alignment: .center)

            Text(totalText)
                .frame(
                    width: TodayRhythmLiveActivityMetrics.timerTokenWidth,
                    alignment: .leading
                )
        }
        .font(.system(size: 14, weight: .medium, design: .monospaced))
        .monospacedDigit()
        .foregroundStyle(Color.white.opacity(0.92))
        .lineLimit(1)
    }

    private func elapsedDurationPair(
        elapsedText: String,
        totalText: String
    ) -> some View {
        HStack(alignment: .firstTextBaseline, spacing: 4) {
            Text(elapsedText)
                .frame(
                    width: TodayRhythmLiveActivityMetrics.timerTokenWidth,
                    alignment: .trailing
                )
            Text("/")
                .frame(width: 8, alignment: .center)
            Text(totalText)
                .frame(
                    width: TodayRhythmLiveActivityMetrics.timerTokenWidth,
                    alignment: .leading
                )
        }
        .font(.system(size: 14, weight: .medium, design: .monospaced))
        .monospacedDigit()
        .foregroundStyle(Color.white.opacity(0.92))
        .lineLimit(1)
    }

    private static func flooredToMinute(_ interval: TimeInterval) -> TimeInterval {
        TimeInterval((Int(interval) / 60) * 60)
    }
}

// MARK: - Notification (compact)

struct TodayRhythmNotificationCompactView: View {
    let state: TodayRhythmActivityAttributes.ContentState
    /// Kept for call-site compatibility; live fields use `TimelineView`.
    let now: Date

    var body: some View {
        TimelineView(.explicit(notificationPresentationDates)) { timeline in
            notificationContent(at: timeline.date)
        }
    }

    private var notificationPresentationDates: [Date] {
        lockScreenPresentationDates(state: state, now: now)
    }

    private func notificationContent(at clock: Date) -> some View {
        let decision = TodayRhythmLivePresentationPolicy.evaluate(
            contentState: state,
            now: clock
        )
        let accent = LiveActivityStateAccent.resolve(
            state: state,
            decision: decision,
            now: clock
        )
        let category = LiveActivityCategoryIdentity.style(
            state: state,
            decision: decision
        )
        let title = TodayRhythmLiveActivityCopy.primaryTitle(
            state: state,
            decision: decision
        )

        return HStack(alignment: .center, spacing: 12) {
            LiveActivityCategoryIconWell(
                style: category,
                size: 34,
                onLightSurface: true
            )

            VStack(alignment: .leading, spacing: 3) {
                if let title {
                    Text(title)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(TodayRhythmLiveActivityPalette.notificationInk)
                        .lineLimit(1)
                        .minimumScaleFactor(0.85)
                }
                Text(accent.statusLabel)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(accent.color)
                    .lineLimit(1)
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            Text("지금")
                .font(.system(size: 12, weight: .medium))
                .foregroundStyle(TodayRhythmLiveActivityPalette.notificationSecondary)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
        .background {
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(TodayRhythmLiveActivityPalette.notificationField)
                .overlay(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .strokeBorder(Color.black.opacity(0.04), lineWidth: 1)
                )
        }
    }
}

// MARK: - StandBy (landscape)

struct TodayRhythmStandByView: View {
    let state: TodayRhythmActivityAttributes.ContentState
    /// Kept for call-site compatibility; live fields use `TimelineView`.
    let now: Date

    var body: some View {
        TimelineView(.explicit(standByPresentationDates)) { timeline in
            standByContent(at: timeline.date)
        }
    }

    private var standByPresentationDates: [Date] {
        lockScreenPresentationDates(state: state, now: now)
    }

    private func standByContent(at clock: Date) -> some View {
        let decision = TodayRhythmLivePresentationPolicy.evaluate(
            contentState: state,
            now: clock
        )
        let visualState = LiveActivityStateAccent.resolve(
            state: state,
            decision: decision,
            now: clock
        )
        let category = LiveActivityCategoryIdentity.style(
            state: state,
            decision: decision
        )
        let title = TodayRhythmLiveActivityCopy.primaryTitle(
            state: state,
            decision: decision
        )
        let progress = visualState == .scheduled
            ? nil
            : TodayRhythmLiveActivityCopy.focusProgress(
                state: state,
                now: clock
            )

        return HStack(alignment: .center, spacing: 24) {
            LiveActivityCategoryIconWell(
                style: category,
                size: TodayRhythmLiveActivityMetrics.standByIconWell
            )

            VStack(alignment: .center, spacing: 10) {
                if let title {
                    Text(title)
                        .font(.system(size: 22, weight: .semibold))
                        .foregroundStyle(Color.white)
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)
                }

                if let progress {
                    LiveActivityProgressDots(
                        filledCount: progress.filledDots,
                        totalCount: TodayRhythmLiveActivityMetrics.progressDotCount,
                        size: 7.5,
                        spacing: 11,
                        accent: visualState.color,
                        emphasizeCurrent: visualState != .completed
                    )
                }
            }
            .frame(maxWidth: .infinity)

            Text(visualState.statusLabel)
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(visualState.color)
                .frame(minWidth: 64, alignment: .trailing)
        }
        .padding(.horizontal, 22)
        .padding(.vertical, 16)
        .background {
            RoundedRectangle(
                cornerRadius: TodayRhythmLiveActivityMetrics.expandedCorner,
                style: .continuous
            )
            .fill(TodayRhythmLiveActivityPalette.expandedField.opacity(0.92))
            .overlay(
                RoundedRectangle(
                    cornerRadius: TodayRhythmLiveActivityMetrics.expandedCorner,
                    style: .continuous
                )
                .strokeBorder(TodayRhythmLiveActivityPalette.edgeStroke, lineWidth: 1)
            )
        }
    }
}

// MARK: - Dynamic Island Expanded

struct TodayRhythmIslandExpandedView: View {
    let state: TodayRhythmActivityAttributes.ContentState
    let now: Date

    var body: some View {
        let clock = presentationClock(now: now, state: state)
        let decision = TodayRhythmLivePresentationPolicy.evaluate(
            contentState: state,
            now: clock
        )
        let accent = LiveActivityStateAccent.resolve(
            state: state,
            decision: decision,
            now: clock
        )
        let title = TodayRhythmLiveActivityCopy.primaryTitle(
            state: state,
            decision: decision
        )

        HStack(alignment: .center, spacing: 8) {
            if let title {
                Text(title)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(.white)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }

            LiveActivityStateDot(
                accent: accent,
                size: TodayRhythmLiveActivityMetrics.islandStateDot
            )

            Text(accent.statusLabel)
                .font(.system(size: 11, weight: .semibold))
                .foregroundStyle(accent.color)
                .lineLimit(1)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .fixedSize(horizontal: false, vertical: true)
    }
}

// MARK: - Compact trailing (title-first)

struct TodayRhythmIslandCompactTrailingView: View {
    let state: TodayRhythmActivityAttributes.ContentState
    let now: Date

    var body: some View {
        let clock = presentationClock(now: now, state: state)
        let decision = TodayRhythmLivePresentationPolicy.evaluate(
            contentState: state,
            now: clock
        )
        let accent = LiveActivityStateAccent.resolve(
            state: state,
            decision: decision,
            now: clock
        )
        let title = TodayRhythmLiveActivityCopy.primaryTitle(
            state: state,
            decision: decision
        ) ?? ""

        ViewThatFits(in: .horizontal) {
            HStack(spacing: 6) {
                Text(title)
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(.white)
                    .lineLimit(1)

                LiveActivityStateDot(
                    accent: accent,
                    size: TodayRhythmLiveActivityMetrics.islandStateDotCompact
                )
            }

            Text(title)
                .font(.system(size: 12, weight: .semibold))
                .foregroundStyle(.white)
                .lineLimit(1)
                .minimumScaleFactor(0.75)
        }
    }
}

/// Compact / Expanded / Minimal category symbol for Dynamic Island slots.
struct TodayRhythmIslandCategoryMark: View {
    let state: TodayRhythmActivityAttributes.ContentState
    let now: Date
    var size: CGFloat

    var body: some View {
        let decision = TodayRhythmLivePresentationPolicy.evaluate(
            contentState: state,
            now: now
        )
        let style = LiveActivityCategoryIdentity.style(state: state, decision: decision)
        Image(systemName: style.symbolName)
            .font(.system(size: size * 0.72, weight: .semibold))
            .foregroundStyle(Color.white)
            .frame(width: size, height: size)
            .accessibilityHidden(true)
    }
}

/// Explicit Lock Screen timeline entries — transition points + minute marks.
/// Avoids `.animation(minimumInterval: 1)` which can stall after Lock Screen cycles.
private func lockScreenPresentationDates(
    state: TodayRhythmActivityAttributes.ContentState,
    now: Date
) -> [Date] {
    let liveNow = Date()
    var dates: [Date] = [now, liveNow]
    if let start = state.focusStart, let end = state.focusEnd, end > start {
        let nearWindow = LiveActivityNearCompletionPolicy.effectiveNearWindow(
            totalDuration: end.timeIntervalSince(start)
        )
        if nearWindow > 0 {
            dates.append(end.addingTimeInterval(-nearWindow))
        }
        dates.append(end)
        dates.append(end.addingTimeInterval(1))
        if start > liveNow {
            dates.append(start)
        }
    } else if let end = state.focusEnd {
        dates.append(end)
        dates.append(end.addingTimeInterval(1))
    }
    if let nextStart = state.nextStart, nextStart > liveNow {
        dates.append(nextStart)
    }
    let windowEnd = state.focusEnd ?? liveNow.addingTimeInterval(60 * 60)
    var tick = liveNow.addingTimeInterval(60)
    var guardCount = 0
    while tick <= windowEnd.addingTimeInterval(60), guardCount < 120 {
        dates.append(tick)
        tick = tick.addingTimeInterval(60)
        guardCount += 1
    }
    return Array(Set(dates.map { $0.timeIntervalSinceReferenceDate }))
        .sorted()
        .map { Date(timeIntervalSinceReferenceDate: $0) }
}

/// Presentation clock for Island / surfaces that receive a stale config `Date()`.
/// Near-completion polish may use live time while phase is still `.active`.
/// Completion itself follows mapped `ContentState.phase` / softClosing.
private func presentationClock(
    now: Date,
    state: TodayRhythmActivityAttributes.ContentState
) -> Date {
    max(now, Date())
}

// MARK: - Shared pieces

struct LiveActivityCategoryIconWell: View {
    let style: ORRhythmCategoryStyle
    var size: CGFloat
    var onLightSurface: Bool = false

    var body: some View {
        let symbolSize = size * (onLightSurface ? 0.42 : 0.40)
        return ZStack {
            Circle()
                .fill(
                    onLightSurface
                        ? style.background
                        : style.background.opacity(0.92)
                )
            Image(systemName: style.symbolName)
                .font(.system(size: symbolSize, weight: .semibold))
                .foregroundStyle(style.foreground)
        }
        .frame(width: size, height: size)
        .accessibilityHidden(true)
    }
}

/// Single Dynamic Island state indicator — not daily progress.
struct LiveActivityStateDot: View {
    let accent: LiveActivityStateAccent
    var size: CGFloat = TodayRhythmLiveActivityMetrics.islandStateDot

    var body: some View {
        Circle()
            .fill(accent.color)
            .frame(width: size, height: size)
            .accessibilityHidden(true)
    }
}

struct LiveActivityProgressDots: View {
    let filledCount: Int
    let totalCount: Int
    var size: CGFloat = TodayRhythmLiveActivityMetrics.progressDotSize
    var spacing: CGFloat = 7
    var accent: Color = LiveActivityStateAccent.running.color
    var emphasizeCurrent: Bool = false

    var body: some View {
        HStack(spacing: spacing) {
            ForEach(0..<totalCount, id: \.self) { index in
                let isReached = index < filledCount
                let isCurrent = emphasizeCurrent && filledCount > 0 && index == filledCount - 1
                ZStack {
                    Circle()
                        .fill(
                            isReached
                                ? accent
                                : TodayRhythmLiveActivityPalette.progressInactive
                        )
                        .frame(
                            width: isCurrent ? size + 1.5 : size,
                            height: isCurrent ? size + 1.5 : size
                        )

                    if isCurrent {
                        Circle()
                            .strokeBorder(accent.opacity(0.55), lineWidth: 1.1)
                            .frame(width: size + 5, height: size + 5)
                    }
                }
                .frame(width: size + 5, height: size + 5)
            }
        }
        .accessibilityHidden(true)
    }
}

// MARK: - Compact / Minimal helpers

enum TodayRhythmLiveActivityIslandMetrics {
    static let expandedMark: CGFloat = TodayRhythmLiveActivityMetrics.islandExpandedMark
    static let compactMark: CGFloat = TodayRhythmLiveActivityMetrics.compactMark
    static let minimalMark: CGFloat = TodayRhythmLiveActivityMetrics.minimalMark
}

/// Compatibility wrapper — category mark for Island slots / QA that previously used Breath Flow.
struct BreathFlowMark: View {
    let size: CGFloat

    var body: some View {
        // Fallback leaf when no state context is available (previews / legacy call sites).
        Image(systemName: "leaf.fill")
            .font(.system(size: size * 0.72, weight: .semibold))
            .foregroundStyle(Color.white)
            .frame(width: size, height: size)
            .accessibilityHidden(true)
    }
}

// MARK: - UI copy (presentation layer only)

enum TodayRhythmLiveActivityCopy {
    struct FocusProgress {
        let ratio: Double
        let filledDots: Int
        let ratioLabel: String
    }

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
            return "오늘의 리듬을 모두 마쳤어요."
        case .none:
            return state.focusTitle ?? state.nextTitle
        }
    }

    static func secondaryPreviewTitle(
        state: TodayRhythmActivityAttributes.ContentState,
        decision: TodayRhythmLivePresentationDecision
    ) -> String? {
        guard decision.secondaryFocus == .nextPreview else { return nil }
        return state.nextTitle
    }

    static func scheduledTimeText(
        state: TodayRhythmActivityAttributes.ContentState
    ) -> String? {
        scheduledTimeText(
            state: state,
            decision: TodayRhythmLivePresentationPolicy.evaluate(
                contentState: state,
                now: Date()
            )
        )
    }

    static func scheduledTimeText(
        state: TodayRhythmActivityAttributes.ContentState,
        decision: TodayRhythmLivePresentationDecision
    ) -> String? {
        switch decision.primaryFocus {
        case .nextRhythm:
            guard let nextStart = state.nextStart else { return nil }
            return clockTimeText(for: nextStart, suffix: nil)
        case .focusRhythm, .none:
            guard let focusStart = state.focusStart else { return nil }
            return clockTimeText(for: focusStart, suffix: nil)
        case .dayComplete:
            return nil
        }
    }

    /// Prefer centralized state accent labels for Live Activity surfaces.
    static func statusLabel(
        state: TodayRhythmActivityAttributes.ContentState,
        decision: TodayRhythmLivePresentationDecision,
        now: Date = Date()
    ) -> String? {
        LiveActivityStateAccent.resolve(
            state: state,
            decision: decision,
            now: now
        ).statusLabel
    }

    static func focusProgress(
        state: TodayRhythmActivityAttributes.ContentState,
        now: Date
    ) -> FocusProgress? {
        guard let start = state.focusStart, let end = state.focusEnd, end > start else {
            return nil
        }
        let total = end.timeIntervalSince(start)
        guard total > 0 else { return nil }
        let elapsed = min(max(now.timeIntervalSince(start), 0), total)
        let ratio = elapsed / total
        let filled: Int
        if ratio <= 0 {
            filled = 0
        } else if ratio >= 1 {
            filled = TodayRhythmLiveActivityMetrics.progressDotCount
        } else {
            let raw = Int(ratio * Double(TodayRhythmLiveActivityMetrics.progressDotCount - 1)) + 1
            filled = min(TodayRhythmLiveActivityMetrics.progressDotCount, max(1, raw))
        }
        return FocusProgress(
            ratio: ratio,
            filledDots: filled,
            ratioLabel: "\(durationText(interval: elapsed)) / \(durationText(interval: total))"
        )
    }

    static func durationText(from start: Date, to end: Date) -> String {
        durationText(interval: end.timeIntervalSince(start))
    }

    static func durationText(interval: TimeInterval) -> String {
        let totalSeconds = max(0, Int(interval.rounded()))
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }

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

    private static func clockTimeText(for date: Date, suffix: String?) -> String {
        let time = date.formatted(Date.FormatStyle(date: .omitted, time: .shortened))
        guard let suffix else { return time }
        return "\(time) \(suffix)"
    }
}
