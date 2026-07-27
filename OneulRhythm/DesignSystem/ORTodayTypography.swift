//
//  ORTodayTypography.swift
//  OneulRhythm
//
//  Today North Star typography — Sprint 18-4.
//  Scoped to Active Today; does not change global ORTypography.
//
//  North Star targets: Playfair Display (greeting) + Pretendard (UI).
//  Closest available system alternatives used — no external font bundles.
//

import SwiftUI

/// Today-only type ramp tuned for calm editorial hierarchy and Korean readability.
enum ORTodayTypography {
    /// Greeting — editorial, calm. Closest to Playfair: system serif.
    static let greeting = Font.system(size: 33, weight: .medium, design: .serif)
    static let greetingLineSpacing: CGFloat = 4
    static let greetingTracking: CGFloat = -0.3

    /// Welcome Hero Meaning — strongest text on First Journey; still calm.
    static let welcomeHero = Font.system(size: 36, weight: .medium, design: .serif)
    static let welcomeHeroLineSpacing: CGFloat = 6
    static let welcomeHeroTracking: CGFloat = -0.4

    /// Date — quieter supporting line under greeting.
    static let date = Font.system(size: 16, weight: .regular, design: .default)
    static let dateTracking: CGFloat = 0.1

    /// Primary role label ("현재") — small, wide, low contrast.
    static let roleLabel = Font.system(size: 12, weight: .medium, design: .default)
    static let roleLabelTracking: CGFloat = 1.4

    /// Primary rhythm title — strong but soft (Pretendard Medium analogue).
    static let primaryTitle = Font.system(size: 25, weight: .semibold, design: .default)
    static let primaryTitleLineSpacing: CGFloat = 5
    static let primaryTitleTracking: CGFloat = -0.2

    /// Remaining-time ring copy — compact, quiet.
    static let ring = Font.system(size: 12, weight: .medium, design: .default)
    static let ringTracking: CGFloat = -0.1

    /// Primary metadata ("아침 · 15분").
    static let meta = Font.system(size: 13, weight: .regular, design: .default)
    static let metaTracking: CGFloat = 0.15

    /// Secondary card eyebrow labels.
    static let secondaryLabel = Font.system(size: 12, weight: .regular, design: .default)
    static let secondaryLabelTracking: CGFloat = 0.2

    /// Secondary card primary value (next rhythm title).
    static let secondaryValue = Font.system(size: 16, weight: .medium, design: .default)
    static let secondaryValueTracking: CGFloat = -0.1

    /// Secondary card trailing time / quiet values.
    static let secondaryTrailing = Font.system(size: 14, weight: .regular, design: .default)

    /// Progress section label.
    static let progressLabel = Font.system(size: 12, weight: .medium, design: .default)
    static let progressLabelTracking: CGFloat = 0.2

    /// Progress count ("0 / 2") — quieter than the label.
    static let progressCount = Font.system(size: 13, weight: .regular, design: .default)

    /// CTA — confident, not loud.
    static let cta = Font.system(size: 17, weight: .medium, design: .default)
    static let ctaTracking: CGFloat = 0.2

    /// Top navigation ("내 리듬") — unobtrusive.
    static let navigation = Font.system(size: 14, weight: .regular, design: .default)
    static let navigationTracking: CGFloat = 0.15

    /// Soft charcoal for greeting / primary title (slightly warmer than pure black).
    static let displayInk = Color(red: 0.22, green: 0.21, blue: 0.19)
    /// Quieter ink for date and supporting values.
    static let supportingInk = Color(red: 0.48, green: 0.47, blue: 0.44)
    /// Lowest-contrast labels / meta.
    static let quietInk = Color(red: 0.62, green: 0.60, blue: 0.56)
}

extension View {
    func todayGreetingTypography() -> some View {
        font(ORTodayTypography.greeting)
            .lineSpacing(ORTodayTypography.greetingLineSpacing)
            .kerning(ORTodayTypography.greetingTracking)
    }

    func todayWelcomeHeroTypography() -> some View {
        font(ORTodayTypography.welcomeHero)
            .lineSpacing(ORTodayTypography.welcomeHeroLineSpacing)
            .kerning(ORTodayTypography.welcomeHeroTracking)
    }

    func todayDateTypography() -> some View {
        font(ORTodayTypography.date)
            .kerning(ORTodayTypography.dateTracking)
    }

    func todayRoleLabelTypography() -> some View {
        font(ORTodayTypography.roleLabel)
            .kerning(ORTodayTypography.roleLabelTracking)
    }

    func todayPrimaryTitleTypography() -> some View {
        font(ORTodayTypography.primaryTitle)
            .lineSpacing(ORTodayTypography.primaryTitleLineSpacing)
            .kerning(ORTodayTypography.primaryTitleTracking)
    }

    func todayRingTypography() -> some View {
        font(ORTodayTypography.ring)
            .kerning(ORTodayTypography.ringTracking)
    }

    func todayMetaTypography() -> some View {
        font(ORTodayTypography.meta)
            .kerning(ORTodayTypography.metaTracking)
    }

    func todaySecondaryLabelTypography() -> some View {
        font(ORTodayTypography.secondaryLabel)
            .kerning(ORTodayTypography.secondaryLabelTracking)
    }

    func todaySecondaryValueTypography() -> some View {
        font(ORTodayTypography.secondaryValue)
            .kerning(ORTodayTypography.secondaryValueTracking)
    }

    func todaySecondaryTrailingTypography() -> some View {
        font(ORTodayTypography.secondaryTrailing)
    }

    func todayProgressLabelTypography() -> some View {
        font(ORTodayTypography.progressLabel)
            .kerning(ORTodayTypography.progressLabelTracking)
    }

    func todayProgressCountTypography() -> some View {
        font(ORTodayTypography.progressCount)
    }

    func todayCTATypography() -> some View {
        font(ORTodayTypography.cta)
            .kerning(ORTodayTypography.ctaTracking)
    }

    func todayNavigationTypography() -> some View {
        font(ORTodayTypography.navigation)
            .kerning(ORTodayTypography.navigationTracking)
    }
}
