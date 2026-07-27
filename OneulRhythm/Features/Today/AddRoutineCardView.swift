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
            Text(title)
                .orTypography(.body, weight: .medium)
                .foregroundStyle(ORColors.textSecondary)
                .frame(maxWidth: .infinity)
                .padding(.vertical, ORSpacing.md)
                .padding(.horizontal, ORSpacing.cardPadding)
                .frame(minHeight: ORSpacing.primaryButtonHeight)
                .background(
                    RoundedRectangle(cornerRadius: ORRadius.button, style: .continuous)
                        .fill(ORColors.card.opacity(0.72))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: ORRadius.button, style: .continuous)
                        .strokeBorder(
                            ORColors.divider,
                            style: StrokeStyle(lineWidth: 1)
                        )
                )
                .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityLabel(title)
        .accessibilityHint("리듬 만들기 화면으로 이동합니다")
    }
}

#Preview {
    AddRoutineCardView(title: "리듬 만들기", action: {})
        .padding(ORSpacing.screenHorizontal)
        .background(ORColors.background)
}
