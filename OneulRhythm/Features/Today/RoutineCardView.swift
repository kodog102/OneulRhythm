//
//  RoutineCardView.swift
//  OneulRhythm
//

import SwiftUI

/// Legacy preview/card helper. Not used by production Today.
/// Snooze / checklist completion framing removed per DR-017.
struct RoutineCardView: View {
    let routine: Routine
    var scheduleRole: RoutineScheduleRole? = nil
    var showsSectionLabel: Bool = true
    var primaryButtonTitle: String = "이어냈어요"
    var isCompleting: Bool = false
    var onComplete: (() -> Void)?

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

    private var isPrimaryDisabled: Bool {
        onComplete == nil || isCompleting
    }

    private var showsAcknowledgmentMessage: Bool {
        resolvedRole == .completed || routine.isCompleted
    }

    private var contentSpacing: CGFloat {
        showsActions || showsAcknowledgmentMessage ? ORSpacing.cardContentGap : ORSpacing.sm
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
                }

                if showsAcknowledgmentMessage {
                    Text("오늘의 리듬을 이어냈어요")
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
                        .accessibilityLabel("이어내는 중")
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
        .accessibilityHint("이 리듬을 이어낸 것으로 표시합니다")
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

#Preview("Acknowledged Routine") {
    RoutineCardView(
        routine: MockRoutineData.currentRoutine.updatingStatus(.completed),
        scheduleRole: .completed
    )
    .padding(ORSpacing.screenHorizontal)
    .background(ORColors.background)
}
