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
struct TodayEmptyStateView: View {
    let phase: TodayEmptyPhase
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
    private var welcomeExperience: some View {
        VStack(alignment: .leading, spacing: 0) {
            breathFlowPresence
                .padding(.bottom, breathFlowBottomSpacing)

            heroMeaning
                .padding(.bottom, ORSpacing.lg)

            philosophy
                .padding(.bottom, philosophyToCTASpacing)

            primaryCTA
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    /// Brand Presence — Sprint 14 Breath Flow E10. Not interactive; decorative for VoiceOver.
    private var breathFlowPresence: some View {
        let side = breathFlowSideLength
        let clearSpace = max(side * 0.125, ORSpacing.sm)

        return Image("BreathFlow")
            .resizable()
            .interpolation(.high)
            .aspectRatio(contentMode: .fit)
            .frame(width: side, height: side)
            .padding(.trailing, clearSpace)
            .padding(.bottom, clearSpace)
            .accessibilityHidden(true)
    }

    private var heroMeaning: some View {
        Text("오늘을\n하나의 리듬으로\n만나보세요.")
            .orTypography(.largeTitle)
            .foregroundStyle(ORColors.textPrimary)
            .fixedSize(horizontal: false, vertical: true)
            .frame(maxWidth: .infinity, alignment: .leading)
            .accessibilityAddTraits(.isHeader)
    }

    /// Open text — never an elevated card competing with Hero presence.
    private var philosophy: some View {
        VStack(alignment: .leading, spacing: ORSpacing.sm) {
            Text("모든 것을 끝내는 앱이 아니에요.")
                .orTypography(.body)
                .foregroundStyle(ORColors.textSecondary)

            Text("지금 가장 중요한 하나에\n함께 머무르도록 도와줘요.")
                .orTypography(.body)
                .foregroundStyle(ORColors.textSecondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .accessibilityElement(children: .combine)
    }

    private var primaryCTA: some View {
        Button(action: onCreateRhythm) {
            Text("오늘의 첫 리듬 만들기")
                .orTypography(.body, weight: .semibold)
                .foregroundStyle(.white)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
                .padding(.vertical, ORSpacing.md)
                .frame(minHeight: ORSpacing.primaryButtonHeight)
                .background(ORColors.primary)
                .clipShape(RoundedRectangle(cornerRadius: ORRadius.button, style: .continuous))
        }
        .buttonStyle(.plain)
        .accessibilityHint("리듬 만들기 화면으로 이동합니다")
    }

    /// Presence scale: larger than toolbar glyphs; smaller than a full-bleed poster.
    private var breathFlowSideLength: CGFloat {
        if sizeCategory.isAccessibilityCategory {
            return 88
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

    /// Gap after Breath Flow clear space — tight enough that mark + Hero Meaning read as one group.
    private var breathFlowBottomSpacing: CGFloat {
        if sizeCategory.isAccessibilityCategory || verticalSizeClass == .compact {
            return ORSpacing.md
        }
        return ORSpacing.lg
    }

    private var philosophyToCTASpacing: CGFloat {
        if sizeCategory.isAccessibilityCategory || verticalSizeClass == .compact {
            return ORSpacing.lg
        }
        return ORSpacing.xl
    }

    // MARK: - Normal Experience (DR-015 Phase 2)

    private var normalExperienceEmpty: some View {
        VStack(alignment: .leading, spacing: ORSpacing.lg) {
            Text("오늘의 리듬을 만들어보세요.")
                .orTypography(.title)
                .foregroundStyle(ORColors.textPrimary)
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
    .background(ORColors.background)
}

#Preview("Normal Experience Empty") {
    TodayEmptyStateView(
        phase: .normalExperience,
        onCreateRhythm: {}
    )
    .padding(.horizontal, ORSpacing.screenHorizontal)
    .background(ORColors.background)
}

#Preview("Welcome — Large Dynamic Type") {
    TodayEmptyStateView(
        phase: .firstJourney,
        onCreateRhythm: {}
    )
    .padding(.horizontal, ORSpacing.screenHorizontal)
    .background(ORColors.background)
    .environment(\.sizeCategory, .accessibilityLarge)
}

#Preview("Welcome — Compact Height") {
    TodayEmptyStateView(
        phase: .firstJourney,
        onCreateRhythm: {}
    )
    .padding(.horizontal, ORSpacing.screenHorizontal)
    .background(ORColors.background)
    .environment(\.verticalSizeClass, .compact)
}
