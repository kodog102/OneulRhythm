//
//  TodayProgressView.swift
//  OneulRhythm
//

import SwiftUI

/// Level 6 supporting progress — quiet orientation only.
/// Must never compete with Primary Rhythm.
struct TodayProgressView: View {
    let completedCount: Int
    let totalCount: Int
    let progress: Double

    private var summaryText: String {
        if completedCount == 0 {
            return "\(totalCount)개의 리듬이 남아 있어요"
        }
        let remaining = totalCount - completedCount
        if remaining == 0 {
            return "오늘의 리듬을 모두 이어냈어요"
        }
        return "\(remaining)개의 리듬이 남아 있어요"
    }

    private var accessibilitySummary: String {
        "\(totalCount)개의 리듬 중 \(completedCount)개를 이어냈어요"
    }

    var body: some View {
        VStack(alignment: .leading, spacing: ORSpacing.xs) {
            FlowProgressBar(progress: progress)
                .accessibilityHidden(true)

            Text(summaryText)
                .orTypography(.caption)
                .foregroundStyle(ORColors.textTertiary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("오늘의 흐름")
        .accessibilityValue(accessibilitySummary)
    }
}

private struct FlowProgressBar: View {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    let progress: Double

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Capsule()
                    .fill(ORColors.primaryMuted)
                    .frame(height: ORSpacing.progressBarHeight)

                Capsule()
                    .fill(ORColors.primary.opacity(0.55))
                    .frame(
                        width: geometry.size.width * min(max(progress, 0), 1),
                        height: ORSpacing.progressBarHeight
                    )
                    .animation(
                        reduceMotion ? nil : .easeInOut(duration: 0.3),
                        value: progress
                    )
            }
        }
        .frame(height: ORSpacing.progressBarHeight)
    }
}

#Preview("None Completed") {
    TodayProgressView(
        completedCount: 0,
        totalCount: 3,
        progress: 0
    )
    .padding(ORSpacing.screenHorizontal)
    .background(ORColors.background)
}

#Preview("Partial") {
    TodayProgressView(
        completedCount: 2,
        totalCount: 5,
        progress: 0.4
    )
    .padding(ORSpacing.screenHorizontal)
    .background(ORColors.background)
}

#Preview("Complete") {
    TodayProgressView(
        completedCount: 3,
        totalCount: 3,
        progress: 1
    )
    .padding(ORSpacing.screenHorizontal)
    .background(ORColors.background)
}
