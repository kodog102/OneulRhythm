//
//  LandscapeBackground.swift
//  OneulRhythm
//
//  Today morning landscape — Sprint 18-3R.
//  Official asset: Assets.xcassets / "Morning Landscape"
//

import SwiftUI

/// Full-bleed morning landscape from the official Morning Landscape asset.
/// Lightweight wrapper only — no SwiftUI-drawn scenery.
struct LandscapeBackground: View {
    var body: some View {
        GeometryReader { geometry in
            Image("Morning Landscape")
                .resizable()
                .scaledToFill()
                // Prefer sky at the top (greeting) and valley behind mid/lower cards.
                .frame(
                    width: geometry.size.width,
                    height: geometry.size.height,
                    alignment: .top
                )
                .clipped()
        }
        .ignoresSafeArea()
        .accessibilityHidden(true)
    }
}

#Preview("Morning Landscape") {
    LandscapeBackground()
}
