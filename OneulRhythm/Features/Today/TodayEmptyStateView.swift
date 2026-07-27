//
//  TodayEmptyStateView.swift
//  OneulRhythm
//

import SwiftUI

/// Today Empty presentation phases from DR-015.
enum TodayEmptyPhase: Equatable {
    /// Before any successful rhythm creation — Welcome Experience.
    case firstJourney
    /// After first successful rhythm creation, even if Today is empty again.
    case normalExperience
}

/// Empty content for Today. Does not own greeting/date chrome.
/// First Journey presents the Welcome Experience (`Welcome-UI-Specification.md`).
/// Sprint 18-6: presentation aligned to Morning Landscape / Today shell — lifecycle unchanged.
/// Sprint 18.8: optional compact vertical rhythm for SE-class first-fold CTA visibility.
struct TodayEmptyStateView: View {
    let phase: TodayEmptyPhase
    /// When true, tighten Welcome vertical spacing only — content and hierarchy unchanged.
    var usesCompactVerticalSpacing: Bool = false
    let onCreateRhythm: () -> Void

    @Environment(\.sizeCategory) private var sizeCategory
    @Environment(\.verticalSizeClass) private var verticalSizeClass

    var body: some View {
        switch phase {
        case .firstJourney:
            welcomeExperience
        case .normalExperience:
            normalExperienceEmpty
        }
    }

    // MARK: - Welcome Experience (DR-015 First Journey)

    /// Hierarchy: Breath Flow → Hero Meaning → Philosophy → Primary CTA.
    /// Greeting / Date remain in `TodayView` as atmosphere only.
    /// Open composition — no competing elevated card around Hero / Philosophy.
    private var welcomeExperience: some View {
        VStack(alignment: .leading, spacing: 0) {
            breathFlowPresence
                .padding(.bottom, breathFlowBottomSpacing)

            heroMeaning
                .padding(.bottom, heroToPhilosophySpacing)

            philosophy
                .padding(.bottom, philosophyToCTASpacing)

            primaryCTA
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    /// Brand Presence — Sprint 14 Breath Flow E10. Not interactive; decorative for VoiceOver.
    private var breathFlowPresence: some View {
        let side = breathFlowSideLength
        let clearSpace = breathFlowClearSpace(for: side)

        return Image("BreathFlow")
            .resizable()
            .interpolation(.high)
            .aspectRatio(contentMode: .fit)
            .frame(width: side, height: side)
            // Leading clear space comes from screen margins; pad other sides so the mark breathes.
            .padding(.top, clearSpace)
            .padding(.trailing, clearSpace)
            .padding(.bottom, clearSpace)
            .accessibilityHidden(true)
    }

    private var heroMeaning: some View {
        Text("오늘을\n하나의 리듬으로\n만나보세요.")
            .todayWelcomeHeroTypography()
            .foregroundStyle(ORTodayTypography.displayInk)
            .fixedSize(horizontal: false, vertical: true)
            .frame(maxWidth: .infinity, alignment: .leading)
            .accessibilityAddTraits(.isHeader)
    }

    /// Open text — never an elevated card competing with Hero presence.
    private var philosophy: some View {
        VStack(alignment: .leading, spacing: philosophyInternalSpacing) {
            Text("모든 것을 끝내는 앱이 아니에요.")
                .todaySecondaryValueTypography()
                .foregroundStyle(ORTodayTypography.supportingInk)

            Text("지금 가장 중요한 하나에\n함께 머무르도록 도와줘요.")
                .todaySecondaryValueTypography()
                .foregroundStyle(ORTodayTypography.supportingInk)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .accessibilityElement(children: .combine)
    }

    /// Supportive doorway — Visible and tappable; never the Hero of Welcome.
    /// Shares Active Today CTA chrome so Welcome belongs to the same shell.
    private var primaryCTA: some View {
        Button(action: onCreateRhythm) {
            Text("오늘의 첫 리듬 만들기")
                .todayCTATypography()
                .foregroundStyle(.white)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
                .frame(minHeight: ORTodaySurface.ctaHeight)
                .background(ORTodaySurface.ctaFill)
                .clipShape(RoundedRectangle(cornerRadius: ORRadius.button, style: .continuous))
                .compositingGroup()
                .shadow(color: ORTodaySurface.ctaFill.opacity(0.32), radius: 16, x: 0, y: 8)
                .shadow(color: ORTodaySurface.ctaFill.opacity(0.18), radius: 4, x: 0, y: 2)
                .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityHint("리듬 만들기 화면으로 이동합니다")
    }

    private var prefersCompactWelcomeSpacing: Bool {
        usesCompactVerticalSpacing
            || verticalSizeClass == .compact
            || sizeCategory.isAccessibilityCategory
    }

    /// Presence scale: larger than toolbar glyphs; smaller than a full-bleed poster.
    private var breathFlowSideLength: CGFloat {
        if sizeCategory.isAccessibilityCategory {
            return 88
        }

        if usesCompactVerticalSpacing {
            return 80
        }

        if verticalSizeClass == .compact {
            return 96
        }

        switch sizeCategory {
        case .extraExtraLarge, .extraExtraExtraLarge:
            return 104
        default:
            return 128
        }
    }

    private func breathFlowClearSpace(for side: CGFloat) -> CGFloat {
        if usesCompactVerticalSpacing {
            return ORSpacing.xs
        }
        return max(side * 0.125, ORSpacing.sm)
    }

    /// Gap after Breath Flow clear space — tight enough that mark + Hero Meaning read as one group.
    private var breathFlowBottomSpacing: CGFloat {
        if usesCompactVerticalSpacing {
            return 0
        }
        if prefersCompactWelcomeSpacing {
            return ORSpacing.xs
        }
        return ORSpacing.md
    }

    private var heroToPhilosophySpacing: CGFloat {
        usesCompactVerticalSpacing ? ORSpacing.xs : (prefersCompactWelcomeSpacing ? ORSpacing.sm : ORSpacing.md)
    }

    private var philosophyInternalSpacing: CGFloat {
        usesCompactVerticalSpacing ? ORSpacing.xxs : (prefersCompactWelcomeSpacing ? ORSpacing.xs : ORSpacing.sm)
    }

    private var philosophyToCTASpacing: CGFloat {
        if usesCompactVerticalSpacing {
            return ORSpacing.md
        }
        if sizeCategory.isAccessibilityCategory || verticalSizeClass == .compact {
            return ORSpacing.xl
        }
        return ORSpacing.xxl
    }

    // MARK: - Normal Experience (DR-015 Phase 2)

    /// Quiet, familiar empty — not onboarding. Soft hierarchy + easy create route.
    private var normalExperienceEmpty: some View {
        VStack(alignment: .leading, spacing: ORSpacing.lg) {
            Text("오늘의 리듬을 만들어보세요.")
                .todayPrimaryTitleTypography()
                .foregroundStyle(ORTodayTypography.displayInk)
                .fixedSize(horizontal: false, vertical: true)
                .frame(maxWidth: .infinity, alignment: .leading)

            AddRoutineCardView(
                title: "리듬 만들기",
                action: onCreateRhythm
            )
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview("Welcome Experience") {
    TodayEmptyStateView(
        phase: .firstJourney,
        onCreateRhythm: {}
    )
    .padding(.horizontal, ORSpacing.screenHorizontal)
    .background { LandscapeBackground() }
}

#Preview("Welcome — Compact Height") {
    TodayEmptyStateView(
        phase: .firstJourney,
        usesCompactVerticalSpacing: true,
        onCreateRhythm: {}
    )
    .padding(.horizontal, ORSpacing.screenHorizontal)
    .background { LandscapeBackground() }
}

#Preview("Normal Experience Empty") {
    TodayEmptyStateView(
        phase: .normalExperience,
        onCreateRhythm: {}
    )
    .padding(.horizontal, ORSpacing.screenHorizontal)
    .background { LandscapeBackground() }
}

#Preview("Welcome — Large Dynamic Type") {
    TodayEmptyStateView(
        phase: .firstJourney,
        onCreateRhythm: {}
    )
    .padding(.horizontal, ORSpacing.screenHorizontal)
    .background { LandscapeBackground() }
    .environment(\.sizeCategory, .accessibilityLarge)
}
