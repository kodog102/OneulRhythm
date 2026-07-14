//
//  RoutineCardView.swift
//  OneulRhythm
//

import SwiftUI

struct RoutineCardView: View {
    let routine: Routine
    var primaryButtonTitle: String = "완료했어요"
    var secondaryActionTitle: String = "10분 뒤에 하기"
    var onComplete: (() -> Void)?
    var onSnooze: (() -> Void)?

    private var sectionLabel: String {
        switch routine.status {
        case .current, .completed: "현재 리듬"
        case .upcoming: "다음 리듬"
        }
    }

    private var showsActions: Bool {
        routine.status == .current
    }

    private var showsCompletionMessage: Bool {
        routine.status == .completed
    }

    private var contentSpacing: CGFloat {
        showsActions || showsCompletionMessage ? ORSpacing.cardContentGap : ORSpacing.sm
    }

    var body: some View {
        VStack(alignment: .leading, spacing: ORSpacing.md) {
            ORSectionLabel(text: sectionLabel)

            VStack(alignment: .leading, spacing: contentSpacing) {
                Text(routine.title)
                    .orTypography(.title)
                    .foregroundStyle(ORColors.textPrimary)
                    .fixedSize(horizontal: false, vertical: true)

                Text(routine.formattedTime)
                    .orTypography(.caption)
                    .foregroundStyle(ORColors.textSecondary)

                if showsActions {
                    primaryButton
                    secondaryButton
                }

                if showsCompletionMessage {
                    Text("오늘의 리듬을 완료했어요")
                        .orTypography(.body, weight: .medium)
                        .foregroundStyle(ORColors.primary)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(ORSpacing.cardPadding)
            .orCard()
        }
    }

    private var primaryButton: some View {
        Button(action: { onComplete?() }) {
            Text(primaryButtonTitle)
                .orTypography(.body, weight: .semibold)
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .frame(height: ORSpacing.primaryButtonHeight)
                .background(ORColors.primary)
                .clipShape(RoundedRectangle(cornerRadius: ORRadius.button, style: .continuous))
        }
        .buttonStyle(.plain)
        .disabled(onComplete == nil)
        .opacity(onComplete == nil ? 0.45 : 1)
    }

    private var secondaryButton: some View {
        Button(action: { onSnooze?() }) {
            Text(secondaryActionTitle)
                .orTypography(.body, weight: .medium)
                .foregroundStyle(ORColors.primaryEmphasis)
                .frame(maxWidth: .infinity)
                .padding(.vertical, ORSpacing.xs)
        }
        .buttonStyle(.plain)
        .disabled(onSnooze == nil)
        .opacity(onSnooze == nil ? 0.45 : 1)
    }
}

#Preview("Current Routine") {
    RoutineCardView(routine: MockRoutineData.currentRoutine)
        .padding(ORSpacing.screenHorizontal)
        .background(ORColors.background)
}

#Preview("Next Routine") {
    RoutineCardView(routine: MockRoutineData.nextRoutine)
        .padding(ORSpacing.screenHorizontal)
        .background(ORColors.background)
}

#Preview("Completed Routine") {
    RoutineCardView(
        routine: MockRoutineData.currentRoutine.updatingStatus(.completed)
    )
    .padding(ORSpacing.screenHorizontal)
    .background(ORColors.background)
}
