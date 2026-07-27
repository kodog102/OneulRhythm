//
//  ORTodaySurface.swift
//  OneulRhythm
//
//  Today North Star card chrome — Sprint 18-2R (visual fidelity pass).
//  Visual Source of Truth: Docs/Visual/NorthStars/Today-NorthStar-v1.jpg
//
//  Judged by screenshot similarity, not token literalism.
//  Uses explicit translucency (not Material) so float/glass survive snapshot capture.
//

import SwiftUI

/// Today surface chrome tuned for an obvious floating / glass read on Warm Cream.
enum ORTodaySurface {
    /// Warm ambient shadow (sage-tinted).
    static let warmShadow = Color(red: 0.30, green: 0.36, blue: 0.30)
    /// Soft warm edge.
    static let edgeStroke = Color.black.opacity(0.09)
    /// Top rim highlight.
    static let highlightStroke = Color.white.opacity(0.95)
    /// North Star CTA `#6E8C74`
    static let ctaFill = Color(red: 110 / 255, green: 140 / 255, blue: 116 / 255)
    static let ctaHeight: CGFloat = 52
}

struct ORTodayPrimaryCardStyle: ViewModifier {
    private let radius = ORRadius.xl

    func body(content: Content) -> some View {
        content
            .background {
                primaryChrome
                    .compositingGroup()
                    // Wide soft lift — must read clearly on cream
                    .shadow(color: ORTodaySurface.warmShadow.opacity(0.34), radius: 44, x: 0, y: 26)
                    .shadow(color: Color.black.opacity(0.14), radius: 20, x: 0, y: 12)
                    .shadow(color: Color.black.opacity(0.08), radius: 4, x: 0, y: 2)
            }
    }

    private var primaryChrome: some View {
        ZStack {
            // Translucent white — lets sage mist read through as glass
            RoundedRectangle(cornerRadius: radius, style: .continuous)
                .fill(Color.white.opacity(0.78))

            // Soft luminous glaze
            RoundedRectangle(cornerRadius: radius, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [
                            Color.white.opacity(0.55),
                            Color.white.opacity(0.12),
                            Color.clear
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )

            RoundedRectangle(cornerRadius: radius, style: .continuous)
                .strokeBorder(
                    LinearGradient(
                        colors: [
                            ORTodaySurface.highlightStroke,
                            Color.white.opacity(0.4),
                            Color.white.opacity(0.08)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    ),
                    lineWidth: 1.35
                )

            RoundedRectangle(cornerRadius: radius, style: .continuous)
                .strokeBorder(ORTodaySurface.edgeStroke, lineWidth: 0.8)
        }
    }
}

struct ORTodaySecondaryCardStyle: ViewModifier {
    private let radius = ORRadius.lg

    func body(content: Content) -> some View {
        content
            .background {
                secondaryChrome
                    .compositingGroup()
                    .shadow(color: ORTodaySurface.warmShadow.opacity(0.24), radius: 28, x: 0, y: 14)
                    .shadow(color: Color.black.opacity(0.10), radius: 10, x: 0, y: 5)
            }
    }

    private var secondaryChrome: some View {
        ZStack {
            // More open glass — stronger background bleed than primary
            RoundedRectangle(cornerRadius: radius, style: .continuous)
                .fill(Color.white.opacity(0.58))

            RoundedRectangle(cornerRadius: radius, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [
                            Color.white.opacity(0.45),
                            Color.white.opacity(0.08),
                            Color.clear
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )

            RoundedRectangle(cornerRadius: radius, style: .continuous)
                .strokeBorder(
                    LinearGradient(
                        colors: [
                            Color.white.opacity(0.9),
                            Color.white.opacity(0.25),
                            Color.clear
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    ),
                    lineWidth: 1.1
                )

            RoundedRectangle(cornerRadius: radius, style: .continuous)
                .strokeBorder(ORTodaySurface.edgeStroke.opacity(0.85), lineWidth: 0.7)
        }
    }
}

extension View {
    func orTodayPrimaryCard() -> some View {
        modifier(ORTodayPrimaryCardStyle())
    }

    func orTodaySecondaryCard() -> some View {
        modifier(ORTodaySecondaryCardStyle())
    }
}
