//
//  AddRoutineCardView.swift
//  OneulRhythm
//

import SwiftUI

struct AddRoutineCardView: View {
    let title: String

    var body: some View {
        Button(action: {}) {
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
    }
}

#Preview {
    AddRoutineCardView(title: "리듬 추가하기")
        .padding(ORSpacing.screenHorizontal)
        .background(ORColors.background)
}
