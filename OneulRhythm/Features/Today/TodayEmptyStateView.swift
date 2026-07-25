//
//  TodayEmptyStateView.swift
//  OneulRhythm
//

import SwiftUI

/// Today Empty presentation phases from DR-015.
enum TodayEmptyPhase: Equatable {
    /// Before any successful rhythm creation.
    case firstJourney
    /// After first successful rhythm creation, even if Today is empty again.
    case normalExperience
}

/// Empty content for Today. Does not own greeting/date chrome.
struct TodayEmptyStateView: View {
    let phase: TodayEmptyPhase
    let onCreateRhythm: () -> Void

    var body: some View {
        switch phase {
        case .firstJourney:
            firstJourneyEmpty
        case .normalExperience:
            normalExperienceEmpty
        }
    }

    // MARK: - First Journey (DR-015 Phase 1)

    private var firstJourneyEmpty: some View {
        VStack(alignment: .leading, spacing: ORSpacing.xxl) {
            firstJourneyHero

            philosophyCard

            firstJourneyCTA

            brandFooter
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var firstJourneyHero: some View {
        Text("오늘을\n하나의 리듬으로\n시작해보세요.")
            .orTypography(.largeTitle)
            .foregroundStyle(ORColors.textPrimary)
            .fixedSize(horizontal: false, vertical: true)
            .frame(maxWidth: .infinity, alignment: .leading)
            .accessibilityAddTraits(.isHeader)
    }

    /// Product philosophy introduction. Supports the hero; never competes with it.
    private var philosophyCard: some View {
        VStack(alignment: .leading, spacing: ORSpacing.sm) {
            Text("모든 것을 끝내는 앱이 아니에요.")
                .orTypography(.body, weight: .medium)
                .foregroundStyle(ORColors.textPrimary)

            Text("지금 가장 중요한 하나의 리듬에 집중하도록 도와줘요.")
                .orTypography(.body)
                .foregroundStyle(ORColors.textSecondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(ORSpacing.cardPadding)
        .frame(maxWidth: .infinity, alignment: .leading)
        .orCard()
        .accessibilityElement(children: .combine)
    }

    private var firstJourneyCTA: some View {
        Button(action: onCreateRhythm) {
            Text("오늘의 첫 리듬 만들기")
                .orTypography(.body, weight: .semibold)
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .frame(height: ORSpacing.primaryButtonHeight)
                .background(ORColors.primary)
                .clipShape(RoundedRectangle(cornerRadius: ORRadius.button, style: .continuous))
        }
        .buttonStyle(.plain)
        .accessibilityHint("리듬 만들기 화면으로 이동합니다")
    }

    private var brandFooter: some View {
        Text("One rhythm at a time.")
            .orTypography(.caption)
            .foregroundStyle(ORColors.textTertiary)
            .frame(maxWidth: .infinity, alignment: .center)
            .padding(.top, ORSpacing.sm)
            .accessibilityHidden(true)
    }

    // MARK: - Normal Experience (DR-015 Phase 2)

    private var normalExperienceEmpty: some View {
        VStack(alignment: .leading, spacing: ORSpacing.xl) {
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

#Preview("First Journey Empty") {
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
