//
//  ORAtmosphereBackground.swift
//  OneulRhythm
//
//  Shared atmospheric background — Sprint 19-1A / 19-1B / corrected 19-1C.
//  Visual Source of Truth: Docs/Visual/NorthStars/Today/Today-NorthStar-v1.jpg
//
//  Composition (bottom → top):
//  1. Morning Landscape
//  2. Bottom-only fog gradient (clear upper half)
//
//  Fog belongs only to this background layer — never to content.
//  Valley fog rises from the lower landscape; greeting / mid stay open.
//

import SwiftUI

/// Full-bleed atmospheric field for major product surfaces.
///
/// Today is the visual source of truth. Primary screens (Today, My Rhythms,
/// Rhythm Editor, Settings) must use this component with default parameters —
/// do not locally customize opacity, overlays, or safe-area behavior.
///
/// Landscape stays visible above mid-screen; soft cream fog dissolves only the lower field.
struct ORAtmosphereBackground: View {
    private enum Palette {
        /// North Star Warm Cream `#F6F3EC`
        static let warmCream = Color(red: 246 / 255, green: 243 / 255, blue: 236 / 255)
    }

    var body: some View {
        GeometryReader { geometry in
            let size = geometry.size

            ZStack {
                landscapeLayer(size: size)
                bottomFogGradient
            }
        }
        .ignoresSafeArea()
        .accessibilityHidden(true)
    }

    // MARK: - Layers

    /// Official Morning Landscape — asset unchanged.
    private func landscapeLayer(size: CGSize) -> some View {
        Image("Morning Landscape")
            .resizable()
            .scaledToFill()
            .frame(
                width: size.width,
                height: size.height,
                alignment: .top
            )
            .clipped()
    }

    /// Bottom-only fog — clear through the upper half; mist rises from mid-lower to bottom.
    /// Does not sit above content; applied only inside this background.
    private var bottomFogGradient: some View {
        LinearGradient(
            stops: [
                .init(color: Color.clear, location: 0.00),
                .init(color: Color.clear, location: 0.50),
                .init(color: Color.clear, location: 0.58),
                .init(color: Palette.warmCream.opacity(0.08), location: 0.66),
                .init(color: Color.white.opacity(0.18), location: 0.78),
                .init(color: Palette.warmCream.opacity(0.42), location: 0.90),
                .init(color: Color.white.opacity(0.58), location: 1.00)
            ],
            startPoint: .top,
            endPoint: .bottom
        )
        .allowsHitTesting(false)
    }
}

#Preview("Atmosphere Background") {
    ORAtmosphereBackground()
}

#Preview("Atmosphere + Sample Content") {
    VStack(alignment: .leading, spacing: 8) {
        Text("좋은 아침이에요.")
            .font(.system(size: 34, weight: .semibold, design: .serif))
            .foregroundStyle(Color(red: 0.22, green: 0.21, blue: 0.20))
        Text("5월 12일 월요일")
            .font(.system(size: 15, weight: .regular))
            .foregroundStyle(Color(red: 0.45, green: 0.43, blue: 0.40))
        Spacer()
    }
    .padding(.horizontal, 24)
    .padding(.top, 72)
    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    .background { ORAtmosphereBackground() }
}
