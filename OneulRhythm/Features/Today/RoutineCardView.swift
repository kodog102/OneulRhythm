//
//  RoutineCardView.swift
//  OneulRhythm
//

import SwiftUI

struct RoutineCardView: View {
    let routine: Routine
    var scheduleRole: RoutineScheduleRole? = nil
    var showsSectionLabel: Bool = true
    var primaryButtonTitle: String = "완료했어요"
    var secondaryActionTitle: String = "10분 뒤에 하기"
    var isCompleting: Bool = false
    var onComplete: (() -> Void)?
    var onSnooze: (() -> Void)?

    private var resolvedRole: RoutineScheduleRole {
        if let scheduleRole {
            return scheduleRole
        }

        switch routine.status {
        case .current:
            return .current
        case .completed:
            return .completed
        case .upcoming:
            return .next
        }
    }

    private var sectionLabel: String {
        switch resolvedRole {
        case .current:
            return "현재 리듬"
        case .overdue:
            return "지나간 리듬"
        case .next:
            return "다음 리듬"
        case .completed:
            return "현재 리듬"
        }
    }

    private var showsActions: Bool {
        switch resolvedRole {
        case .current, .overdue:
            return true
        case .next, .completed:
            return false
        }
    }

    private var showsSecondaryAction: Bool {
        resolvedRole == .current
    }

    private var isPrimaryDisabled: Bool {
        onComplete == nil || isCompleting
    }

    private var showsCompletionMessage: Bool {
        resolvedRole == .completed || routine.isCompleted
    }

    private var contentSpacing: CGFloat {
        showsActions || showsCompletionMessage ? ORSpacing.cardContentGap : ORSpacing.sm
    }

    var body: some View {
        VStack(alignment: .leading, spacing: ORSpacing.md) {
            if showsSectionLabel {
                ORSectionLabel(text: sectionLabel)
            }

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

                    if showsSecondaryAction {
                        secondaryButton
                    }
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
            Group {
                if isCompleting {
                    ProgressView()
                        .tint(.white)
                        .accessibilityLabel("완료 저장 중")
                } else {
                    Text(primaryButtonTitle)
                        .orTypography(.body, weight: .semibold)
                        .foregroundStyle(.white)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: ORSpacing.primaryButtonHeight)
            .background(ORColors.primary)
            .clipShape(RoundedRectangle(cornerRadius: ORRadius.button, style: .continuous))
        }
        .buttonStyle(.plain)
        .disabled(isPrimaryDisabled)
        .opacity(isPrimaryDisabled ? 0.45 : 1)
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
    RoutineCardView(
        routine: MockRoutineData.currentRoutine,
        scheduleRole: .current
    )
    .padding(ORSpacing.screenHorizontal)
    .background(ORColors.background)
}

#Preview("Past Incomplete Routine") {
    RoutineCardView(
        routine: MockRoutineData.currentRoutine.updatingStatus(.upcoming),
        scheduleRole: .overdue,
        onComplete: {}
    )
    .padding(ORSpacing.screenHorizontal)
    .background(ORColors.background)
}

#Preview("Next Routine") {
    RoutineCardView(
        routine: MockRoutineData.nextRoutine,
        scheduleRole: .next
    )
    .padding(ORSpacing.screenHorizontal)
    .background(ORColors.background)
}

#Preview("Completed Routine") {
    RoutineCardView(
        routine: MockRoutineData.currentRoutine.updatingStatus(.completed),
        scheduleRole: .completed
    )
    .padding(ORSpacing.screenHorizontal)
    .background(ORColors.background)
}
