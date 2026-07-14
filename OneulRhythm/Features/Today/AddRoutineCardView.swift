//
//  AddRoutineCardView.swift
//  OneulRhythm
//

import SwiftUI

struct AddRoutineCardView: View {
    let title: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: ORSpacing.sm) {
                Image(systemName: "plus")
                    .font(ORTypography.font(for: .body, weight: .medium))
                    .foregroundStyle(ORColors.primary)

                Text(title)
                    .orTypography(.body, weight: .medium)
                    .foregroundStyle(ORColors.textSecondary)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, ORSpacing.lg)
            .padding(.horizontal, ORSpacing.cardPadding)
            .background(
                RoundedRectangle(cornerRadius: ORRadius.lg, style: .continuous)
                    .strokeBorder(
                        ORColors.divider,
                        style: StrokeStyle(lineWidth: 1.5, dash: [ORSpacing.xs, ORSpacing.xxs])
                    )
            )
        }
        .buttonStyle(.plain)
        .accessibilityLabel(title)
        .accessibilityAddTraits(.isButton)
    }
}

#Preview {
    AddRoutineCardView(title: "리듬 추가하기", action: {})
        .padding(ORSpacing.screenHorizontal)
        .background(ORColors.background)
}
