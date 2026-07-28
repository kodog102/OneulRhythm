//
//  ORRhythmCategoryStyle.swift
//  OneulRhythmShared
//
//  Shared category visual identity — My Rhythms + Live Activity (Sprint 21-4).
//  Single mapping for symbol + colors. Keys match `RoutineCategory.rawValue`.
//

import SwiftUI

/// Category chrome shared across Management and Live Activity surfaces.
struct ORRhythmCategoryStyle: Equatable {
    let symbolName: String
    let background: Color
    let foreground: Color

    /// Resolves style from a `RoutineCategory.rawValue` string.
    static func style(forRawValue rawValue: String?) -> ORRhythmCategoryStyle {
        switch rawValue {
        case "morning":
            return ORRhythmCategoryStyle(
                symbolName: "sun.max.fill",
                background: Color(red: 1.0, green: 0.90, blue: 0.72),
                foreground: Color(red: 0.86, green: 0.55, blue: 0.22)
            )
        case "focus":
            return ORRhythmCategoryStyle(
                symbolName: "leaf.fill",
                background: Color(red: 0.86, green: 0.93, blue: 0.84),
                foreground: Color(red: 0.40, green: 0.55, blue: 0.40)
            )
        case "movement":
            return ORRhythmCategoryStyle(
                symbolName: "figure.walk",
                background: Color(red: 0.82, green: 0.91, blue: 0.91),
                foreground: Color(red: 0.35, green: 0.55, blue: 0.56)
            )
        case "rest":
            return ORRhythmCategoryStyle(
                symbolName: "cup.and.saucer.fill",
                background: Color(red: 0.93, green: 0.90, blue: 0.84),
                foreground: Color(red: 0.55, green: 0.48, blue: 0.38)
            )
        case "evening":
            return ORRhythmCategoryStyle(
                symbolName: "moon.fill",
                background: Color(red: 0.90, green: 0.86, blue: 0.95),
                foreground: Color(red: 0.48, green: 0.40, blue: 0.62)
            )
        default:
            // Calm fallback — same as focus.
            return ORRhythmCategoryStyle(
                symbolName: "leaf.fill",
                background: Color(red: 0.86, green: 0.93, blue: 0.84),
                foreground: Color(red: 0.40, green: 0.55, blue: 0.40)
            )
        }
    }
}
