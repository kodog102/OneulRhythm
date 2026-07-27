//
//  TodayProgressView.swift
//  OneulRhythm
//
//  Calm rhythm-flow progress — Sprint 18-5 / 18-5R.
//  Fixed checkpoints map overall progress ratio — not one dot per routine.
//

import SwiftUI

/// Level 6 supporting progress — quiet orientation only.
/// Must never compete with Primary Rhythm.
struct TodayProgressView: View {
    let completedCount: Int
    let totalCount: Int
    let progress: Double

    private var accessibilitySummary: String {
        "\(totalCount)개의 리듬 중 \(completedCount)개를 이어냈어요"
    }

    var body: some View {
        TodayRhythmFlowIndicator(
            completedCount: completedCount,
            totalCount: totalCount
        )
        .frame(maxWidth: .infinity, alignment: .leading)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("오늘의 흐름")
        .accessibilityValue(accessibilitySummary)
    }
}

/// Gentle wave + fixed rhythm checkpoints.
/// Exact counts stay in the numeric label; this view only shows journey progress.
struct TodayRhythmFlowIndicator: View {
    let completedCount: Int
    let totalCount: Int

    /// Stable visual rhythm — never scales with routine count.
    static let checkpointCount: Int = 5

    private let waveHeight: CGFloat = 28
    private let amplitude: CGFloat = 5.5
    /// Soft half-cycles across the width — organic, not mechanical.
    private let waveCycles: CGFloat = 1.75

    private var safeTotal: Int {
        max(totalCount, 0)
    }

    private var safeCompleted: Int {
        min(max(completedCount, 0), safeTotal)
    }

    /// Overall journey progress `completed / total`, clamped to 0...1.
    private var progressRatio: CGFloat {
        guard safeTotal > 0 else { return 0 }
        return CGFloat(safeCompleted) / CGFloat(safeTotal)
    }

    /// Active checkpoint from progress ratio (fixed 5 nodes: indices 0...4).
    /// 0% → no focus; 100% → final; otherwise proportional along the journey.
    private var focusIndex: Int? {
        guard safeTotal > 0 else { return nil }
        if progressRatio <= 0 { return nil }
        if progressRatio >= 1 { return Self.checkpointCount - 1 }
        // Truncate so 18/20 (~0.9) lands on "near final" (index 3), not the last node.
        let raw = Int(progressRatio * CGFloat(Self.checkpointCount - 1))
        return min(Self.checkpointCount - 1, max(0, raw))
    }

    var body: some View {
        Group {
            if safeTotal == 0 {
                Color.clear.frame(height: waveHeight)
            } else {
                GeometryReader { geometry in
                    let width = geometry.size.width
                    let midY = waveHeight / 2

                    ZStack {
                        wavePath(width: width, midY: midY)
                            .stroke(
                                ORTodaySurface.ctaFill.opacity(0.28),
                                style: StrokeStyle(lineWidth: 1.4, lineCap: .round, lineJoin: .round)
                            )

                        ForEach(0..<Self.checkpointCount, id: \.self) { index in
                            let point = pointOnWave(index: index, width: width, midY: midY)
                            rhythmDot(at: index)
                                .position(point)
                        }
                    }
                    .frame(width: width, height: waveHeight)
                }
                .frame(height: waveHeight)
            }
        }
        .accessibilityHidden(true)
    }

    private func wavePath(width: CGFloat, midY: CGFloat) -> Path {
        Path { path in
            guard width > 0 else { return }
            path.move(to: CGPoint(x: 0, y: midY))
            let steps = max(Int(width), 2)
            for step in 1...steps {
                let x = CGFloat(step)
                let t = x / width
                let y = midY + sin(t * .pi * waveCycles) * amplitude
                path.addLine(to: CGPoint(x: x, y: y))
            }
        }
    }

    private func pointOnWave(index: Int, width: CGFloat, midY: CGFloat) -> CGPoint {
        let t = CGFloat(index) / CGFloat(Self.checkpointCount - 1)
        let x = t * width
        let y = midY + sin(t * .pi * waveCycles) * amplitude
        return CGPoint(x: x, y: y)
    }

    @ViewBuilder
    private func rhythmDot(at index: Int) -> some View {
        let focus = focusIndex
        let isReached = focus.map { index <= $0 } ?? false
        let isFocus = focus == index

        ZStack {
            if isFocus {
                Circle()
                    .stroke(ORTodaySurface.ctaFill.opacity(0.45), lineWidth: 1.25)
                    .frame(width: 14, height: 14)
            }

            Circle()
                .fill(dotFill(reached: isReached, focus: isFocus))
                .frame(
                    width: isFocus ? 6.5 : (isReached ? 5.5 : 4.5),
                    height: isFocus ? 6.5 : (isReached ? 5.5 : 4.5)
                )
                .overlay {
                    if !isReached && !isFocus {
                        Circle()
                            .stroke(ORTodayTypography.quietInk.opacity(0.50), lineWidth: 1)
                    }
                }
        }
        .frame(width: 16, height: 16)
    }

    private func dotFill(reached: Bool, focus: Bool) -> Color {
        if focus {
            return ORTodaySurface.ctaFill.opacity(0.90)
        }
        if reached {
            return ORTodaySurface.ctaFill.opacity(0.62)
        }
        return Color.white.opacity(0.35)
    }
}

#Preview("1 / 2 — midpoint") {
    progressPreview(completed: 1, total: 2)
}

#Preview("2 / 6 — about one-third") {
    progressPreview(completed: 2, total: 6)
}

#Preview("6 / 12 — halfway") {
    progressPreview(completed: 6, total: 12)
}

#Preview("18 / 20 — near final") {
    progressPreview(completed: 18, total: 20)
}

#Preview("2 / 2 — final") {
    progressPreview(completed: 2, total: 2)
}

@MainActor
private func progressPreview(completed: Int, total: Int) -> some View {
    VStack(alignment: .leading, spacing: ORSpacing.sm) {
        HStack {
            Text("오늘의 리듬")
                .todayProgressLabelTypography()
                .foregroundStyle(ORTodayTypography.supportingInk)
            Spacer()
            Text("\(completed) / \(total)")
                .todayProgressCountTypography()
                .foregroundStyle(ORTodayTypography.quietInk)
        }
        TodayRhythmFlowIndicator(completedCount: completed, totalCount: total)
    }
    .padding(ORSpacing.md)
    .orTodaySecondaryCard()
    .padding(ORSpacing.screenHorizontal)
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(ORColors.background)
}
