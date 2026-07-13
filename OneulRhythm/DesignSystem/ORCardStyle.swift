//
//  ORCardStyle.swift
//  OneulRhythm
//

import SwiftUI

struct ORCardStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(ORColors.card)
            .clipShape(RoundedRectangle(cornerRadius: ORRadius.lg, style: .continuous))
            .shadow(color: ORColors.cardShadow, radius: 10, x: 0, y: 4)
    }
}

extension View {
    func orCard() -> some View {
        modifier(ORCardStyle())
    }
}
