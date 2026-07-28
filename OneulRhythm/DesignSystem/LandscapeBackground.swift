//
//  LandscapeBackground.swift
//  OneulRhythm
//
//  Today morning landscape — Sprint 18-3R.
//  Official asset: Assets.xcassets / "Morning Landscape"
//
//  Sprint 19-1A: Prefer `ORAtmosphereBackground` for product surfaces.
//  This type remains the bare landscape layer for previews / composition.
//

import SwiftUI

/// Full-bleed morning landscape from the official Morning Landscape asset.
/// Lightweight wrapper only — no SwiftUI-drawn scenery.
/// Product screens should use `ORAtmosphereBackground` (landscape + atmosphere overlays).
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

#Preview("Morning Landscape (bare)") {
    LandscapeBackground()
}
