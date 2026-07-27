//
//  AddRoutineCardView.swift
//  OneulRhythm
//

import SwiftUI

/// Quiet create affordance for Normal Experience Empty.
/// Uses Today secondary glass chrome — softer than Welcome / Active primary CTA.
struct AddRoutineCardView: View {
    let title: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .todaySecondaryValueTypography()
                .foregroundStyle(ORTodayTypography.displayInk)
                .frame(maxWidth: .infinity)
                .padding(.vertical, ORSpacing.md)
                .padding(.horizontal, ORSpacing.cardPadding)
                .frame(minHeight: ORTodaySurface.ctaHeight)
                .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .orTodaySecondaryCard()
        .accessibilityLabel(title)
        .accessibilityHint("리듬 만들기 화면으로 이동합니다")
    }
}

#Preview {
    AddRoutineCardView(title: "리듬 만들기", action: {})
        .padding(ORSpacing.screenHorizontal)
        .background { LandscapeBackground() }
}
