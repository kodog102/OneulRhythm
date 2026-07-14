//
//  TodayProgressView.swift
//  OneulRhythm
//

import SwiftUI

struct TodayProgressView: View {
    let title: String
    let completedCount: Int
    let totalCount: Int
    let message: String
    let progress: Double

    private var countText: String {
        "\(completedCount) / \(totalCount) 리듬 완료"
    }

    private var accessibilitySummary: String {
        "\(title). \(countText). \(message)"
    }

    var body: some View {
        VStack(alignment: .leading, spacing: ORSpacing.md) {
            VStack(alignment: .leading, spacing: ORSpacing.xs) {
                Text(title)
                    .orTypography(.title)
                    .foregroundStyle(ORColors.textPrimary)

                Text(countText)
                    .orTypography(.caption)
                    .foregroundStyle(ORColors.textSecondary)

                Text(message)
                    .orTypography(.body)
                    .foregroundStyle(ORColors.textSecondary)
                    .fixedSize(horizontal: false, vertical: true)
            }

            FlowProgressBar(progress: progress)
                .accessibilityHidden(true)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(ORSpacing.cardPadding)
        .orCard()
        .accessibilityElement(children: .combine)
        .accessibilityLabel(accessibilitySummary)
    }
}

private struct FlowProgressBar: View {
    let progress: Double

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Capsule()
                    .fill(ORColors.primaryMuted)
                    .frame(height: ORSpacing.progressBarHeight)

                Capsule()
                    .fill(
                        LinearGradient(
                            colors: [
                                ORColors.primary.opacity(0.7),
                                ORColors.primary
                            ],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(
                        width: geometry.size.width * min(max(progress, 0), 1),
                        height: ORSpacing.progressBarHeight
                    )
            }
        }
        .frame(height: ORSpacing.progressBarHeight)
    }
}

#Preview("None Completed") {
    TodayProgressView(
        title: "오늘의 흐름",
        completedCount: 0,
        totalCount: 3,
        message: "첫 리듬부터 천천히 시작해보세요.",
        progress: 0
    )
    .padding(ORSpacing.screenHorizontal)
    .background(ORColors.background)
}

#Preview("Partial") {
    TodayProgressView(
        title: "오늘의 흐름",
        completedCount: 2,
        totalCount: 5,
        message: "오늘의 흐름이 차분하게 이어지고 있어요.",
        progress: 0.4
    )
    .padding(ORSpacing.screenHorizontal)
    .background(ORColors.background)
}

#Preview("Complete") {
    TodayProgressView(
        title: "오늘의 흐름",
        completedCount: 3,
        totalCount: 3,
        message: "오늘의 리듬을 모두 이어냈어요.",
        progress: 1
    )
    .padding(ORSpacing.screenHorizontal)
    .background(ORColors.background)
}
