//
//  TodayProgressView.swift
//  OneulRhythm
//

import SwiftUI

struct TodayProgressView: View {
    let title: String
    let description: String
    let completedCount: Int
    let totalCount: Int

    private var progress: Double {
        guard totalCount > 0 else { return 0 }
        return Double(completedCount) / Double(totalCount)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: ORSpacing.md) {
            VStack(alignment: .leading, spacing: ORSpacing.xs) {
                Text(title)
                    .orTypography(.title)
                    .foregroundStyle(ORColors.textPrimary)

                Text(description)
                    .orTypography(.body)
                    .foregroundStyle(ORColors.textSecondary)
                    .fixedSize(horizontal: false, vertical: true)
            }

            FlowProgressBar(progress: progress)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(ORSpacing.cardPadding)
        .orCard()
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
                        width: max(geometry.size.width * progress, ORSpacing.progressBarHeight),
                        height: ORSpacing.progressBarHeight
                    )
            }
        }
        .frame(height: ORSpacing.progressBarHeight)
    }
}

#Preview {
    TodayProgressView(
        title: "오늘의 흐름",
        description: "오늘의 흐름이 차분하게 이어지고 있어요",
        completedCount: 2,
        totalCount: 5
    )
    .padding(ORSpacing.screenHorizontal)
    .background(ORColors.background)
}
