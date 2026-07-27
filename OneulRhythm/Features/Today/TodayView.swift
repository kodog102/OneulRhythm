//
//  TodayView.swift
//  OneulRhythm
//

import SwiftUI
import UIKit

struct TodayView: View {
    @Environment(\.scenePhase) private var scenePhase
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Environment(\.verticalSizeClass) private var verticalSizeClass
    @EnvironmentObject private var launchState: AppLaunchState
    @EnvironmentObject private var firstRhythmJourneyProgress: FirstRhythmJourneyProgress
    @StateObject private var viewModel: TodayViewModel
    @State private var isCreateRhythmPresented = false
    @State private var isManageRhythmsPresented = false
    @State private var isSettingsPresented = false
    /// Visible ScrollView height — drives SE-class Welcome spacing only (Sprint 18.8).
    @State private var viewportHeight: CGFloat = 0

    private let repository: RoutineRepository
    private let recurringRhythmRepository: RecurringRhythmRepository
    private let onSaveRoutine: (RoutineCreationInput) throws -> Void
    private let onUpdateRoutine: (RoutineCreationInput) throws -> Void
    private let onDeleteRoutine: (UUID) throws -> Void
    private let onAppBecomeActive: () -> Void
    private let nowProvider: () -> Date

    init(
        repository: RoutineRepository,
        recurringRhythmRepository: RecurringRhythmRepository,
        onSaveRoutine: @escaping (RoutineCreationInput) throws -> Void = { _ in },
        onUpdateRoutine: @escaping (RoutineCreationInput) throws -> Void = { _ in },
        onDeleteRoutine: @escaping (UUID) throws -> Void = { _ in },
        onAppBecomeActive: @escaping () -> Void = {},
        liveActivityCoordinator: LiveActivityCoordinating? = nil,
        nowProvider: @escaping () -> Date = Date.init
    ) {
        _viewModel = StateObject(
            wrappedValue: TodayViewModel(
                repository: repository,
                liveActivityCoordinator: liveActivityCoordinator,
                nowProvider: nowProvider
            )
        )
        self.repository = repository
        self.recurringRhythmRepository = recurringRhythmRepository
        self.onSaveRoutine = onSaveRoutine
        self.onUpdateRoutine = onUpdateRoutine
        self.onDeleteRoutine = onDeleteRoutine
        self.onAppBecomeActive = onAppBecomeActive
        self.nowProvider = nowProvider
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    // 3–4. Hero / Greeting + Date
                    headerGroup

                    // 5–6. Primary Rhythm + Supporting content
                    screenContent
                        .padding(.top, contentTopSpacing)
                        .id(contentTransitionID)
                        .transition(contentTransition)

                    // Bottom action slot (North Star CTA position)
                    if showsBottomActionSlot, let primaryRhythm = viewModel.primaryRhythm {
                        completionButton(for: primaryRhythm)
                            .padding(.top, ORSpacing.xl)
                    }
                }
                .padding(.horizontal, ORSpacing.screenHorizontal)
                // 7. Bottom spacing — tighter on SE-class Welcome so CTA clears the fold.
                .padding(.bottom, usesCompactWelcomeSpacing ? ORSpacing.md : ORSpacing.scrollBottom)
                .frame(maxWidth: .infinity, alignment: .leading)
                .animation(contentAnimation, value: contentTransitionID)
            }
            // 1. Safe Area
            .safeAreaPadding(
                .top,
                usesCompactWelcomeSpacing ? ORSpacing.sm : ORSpacing.screenTop
            )
            // 2. Background layer
            .background {
                LandscapeBackground()
            }
            .toolbar {
                // Settings + My Rhythms: hidden on Welcome (First Journey). Settings UI Spec / DR-015.
                if firstRhythmJourneyProgress.hasCompletedFirstRhythmJourney {
                    ToolbarItem(placement: .topBarLeading) {
                        Button {
                            isSettingsPresented = true
                        } label: {
                            Image(systemName: "gearshape")
                                .font(.system(size: 17, weight: .regular))
                                .foregroundStyle(ORTodayTypography.quietInk)
                                .frame(width: 44, height: 44)
                                .contentShape(Rectangle())
                        }
                        .buttonStyle(.plain)
                        .accessibilityLabel("설정")
                        .accessibilityHint("앱 설정을 엽니다")
                    }

                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            isManageRhythmsPresented = true
                        } label: {
                            Text("내 리듬")
                                .todayNavigationTypography()
                                .foregroundStyle(ORTodayTypography.quietInk)
                                .frame(minWidth: 44, minHeight: 44)
                                .contentShape(Rectangle())
                        }
                        .buttonStyle(.plain)
                        .accessibilityLabel("내 리듬")
                        .accessibilityHint("리듬 목록을 엽니다")
                    }
                }
            }
            .navigationDestination(isPresented: $isCreateRhythmPresented) {
                AddRoutineView(
                    mode: .create,
                    onSave: { input in
                        try onSaveRoutine(input)
                        viewModel.loadRoutines()
                    },
                    nowProvider: nowProvider
                )
            }
            .navigationDestination(isPresented: $isManageRhythmsPresented) {
                RoutineManagementView(
                    repository: repository,
                    recurringRhythmRepository: recurringRhythmRepository,
                    onSaveRoutine: onSaveRoutine,
                    onUpdateRoutine: onUpdateRoutine,
                    onDeleteRoutine: onDeleteRoutine,
                    onRoutinesChanged: {
                        viewModel.loadRoutines()
                    },
                    nowProvider: nowProvider
                )
            }
            .navigationDestination(isPresented: $isSettingsPresented) {
                SettingsView()
            }
        }
        .task(id: launchState.didCompleteInitialRhythmSync) {
            guard launchState.didCompleteInitialRhythmSync else { return }
            viewModel.loadRoutines()
        }
        .onChange(of: scenePhase) { _, phase in
            guard launchState.didCompleteInitialRhythmSync else { return }
            if phase == .active {
                onAppBecomeActive()
                viewModel.loadRoutines()
            }
        }
        .background {
            TodayWindowHeightReader(height: $viewportHeight)
        }
        .alert(
            "리듬을 이어내지 못했어요",
            isPresented: Binding(
                get: { viewModel.completionErrorMessage != nil },
                set: { isPresented in
                    if !isPresented {
                        viewModel.completionErrorMessage = nil
                    }
                }
            )
        ) {
            Button("확인", role: .cancel) {}
        } message: {
            Text(viewModel.completionErrorMessage ?? "잠시 후 다시 시도해주세요.")
        }
    }

    // MARK: - Always Visible

    /// North Star header: Hero greeting, then Date — left-aligned atmospheric entry.
    private var headerGroup: some View {
        VStack(alignment: .leading, spacing: ORSpacing.xs) {
            Text(viewModel.greetingText)
                .modifier(TodayGreetingTypeModifier(isWelcome: isWelcomeExperienceActive))
                .foregroundStyle(
                    isWelcomeExperienceActive
                        ? ORColors.textSecondary
                        : ORTodayTypography.displayInk
                )
                // Welcome: atmosphere only — Hero Meaning owns the primary header.
                .accessibilityAddTraits(isWelcomeExperienceActive ? [] : .isHeader)

            Text(viewModel.formattedTodayDate)
                .modifier(TodayDateTypeModifier(isWelcome: isWelcomeExperienceActive))
                .foregroundStyle(
                    isWelcomeExperienceActive
                        ? ORColors.textTertiary
                        : ORTodayTypography.supportingInk
                )
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    /// Completion sits in the North Star bottom CTA slot, not inside the primary card.
    private var showsBottomActionSlot: Bool {
        !isAwaitingInitialToday
            && !viewModel.isLoading
            && viewModel.loadErrorMessage == nil
            && viewModel.showsCompletionButton
            && viewModel.primaryRhythm != nil
    }

    /// True until initial sync finishes and the first Today load has resolved.
    /// Holds the cream shell so Empty / Welcome / Create never flash on launch.
    private var isAwaitingInitialToday: Bool {
        !launchState.didCompleteInitialRhythmSync
            || !viewModel.hasResolvedInitialSnapshot
    }

    /// First Journey Empty — Welcome Experience is active (DR-015 + Welcome UI Spec).
    private var isWelcomeExperienceActive: Bool {
        !isAwaitingInitialToday
            && !viewModel.isLoading
            && viewModel.loadErrorMessage == nil
            && viewModel.screenPresentation == .empty
            && emptyPhase == .firstJourney
    }

    // MARK: - Screen Content

    @ViewBuilder
    private var screenContent: some View {
        if isAwaitingInitialToday {
            initialTodayHold
        } else if viewModel.isLoading {
            loadingState
        } else if let loadErrorMessage = viewModel.loadErrorMessage {
            errorState(message: loadErrorMessage)
        } else {
            switch viewModel.screenPresentation {
            case .empty:
                emptyState
            case .dayComplete:
                dayCompleteMessage
            case .upcoming, .current, .pastIncomplete:
                primaryRhythmArea
            }
        }
    }

    /// Stable Today content identity — drives restrained enter transition only when focus changes.
    /// Primary states key on rhythm identity (not role), so Upcoming → Current for the same
    /// rhythm stays continuous rather than remounting as a new page.
    private var contentTransitionID: String {
        if isAwaitingInitialToday {
            return "awaiting-initial"
        }

        // Omit loading: loadRoutines toggles isLoading synchronously and must not re-animate.
        if viewModel.loadErrorMessage != nil {
            return "error"
        }

        switch viewModel.screenPresentation {
        case .empty:
            switch emptyPhase {
            case .firstJourney:
                return "empty-firstJourney"
            case .normalExperience:
                return "empty-normalExperience"
            }
        case .dayComplete:
            return "dayComplete"
        case .upcoming, .current, .pastIncomplete:
            let rhythmID = viewModel.primaryRhythm?.id.uuidString ?? "none"
            return "primary-\(rhythmID)"
        }
    }

    private var contentTransition: AnyTransition {
        if reduceMotion {
            return .opacity
        }
        return .opacity.combined(with: .offset(y: 6))
    }

    private var contentAnimation: Animation {
        .easeInOut(duration: 0.28)
    }

    /// Calm cream continuation while launch sync + first snapshot resolve.
    /// No Empty, Welcome, Create CTA, spinner, or progress.
    private var initialTodayHold: some View {
        Color.clear
            .frame(maxWidth: .infinity)
            .frame(minHeight: 1)
            .accessibilityHidden(true)
    }

    private var loadingState: some View {
        HStack(spacing: ORSpacing.md) {
            ProgressView()
                .tint(ORColors.primary)

            Text("리듬을 불러오는 중이에요")
                .orTypography(.body)
                .foregroundStyle(ORColors.textSecondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.vertical, ORSpacing.lg)
    }

    private func errorState(message: String) -> some View {
        Text(message)
            .orTypography(.body)
            .foregroundStyle(ORColors.textSecondary)
            .fixedSize(horizontal: false, vertical: true)
            .frame(maxWidth: .infinity, alignment: .leading)
    }

    /// Empty phases from DR-015 — Welcome (First Journey) vs Normal Experience.
    private var emptyState: some View {
        TodayEmptyStateView(
            phase: emptyPhase,
            usesCompactVerticalSpacing: usesCompactWelcomeSpacing,
            onCreateRhythm: { isCreateRhythmPresented = true }
        )
    }

    private var emptyPhase: TodayEmptyPhase {
        firstRhythmJourneyProgress.hasCompletedFirstRhythmJourney
            ? .normalExperience
            : .firstJourney
    }

    /// SE-class / short viewport only — Standard and Pro Max keep the open Welcome rhythm.
    private var usesCompactWelcomeSpacing: Bool {
        guard isWelcomeExperienceActive else { return false }
        if verticalSizeClass == .compact { return true }
        // Full Today canvas under ~700pt (SE-class / 320×568 QA).
        return viewportHeight > 0 && viewportHeight < 700
    }

    /// Welcome gives Breath Flow generous air after the atmospheric layer.
    /// Active Today: North Star gap between Date and Primary card (~64pt on 8pt grid).
    private var contentTopSpacing: CGFloat {
        if isWelcomeExperienceActive {
            return usesCompactWelcomeSpacing ? ORSpacing.sm : ORSpacing.xxl
        }
        return ORSpacing.xxxl + ORSpacing.md
    }

    /// Approved Day Complete copy. Quiet closure — never celebratory.
    /// Soft secondary glass — lighter than Active primary stack; peaceful, not empty.
    private var dayCompleteMessage: some View {
        Text("오늘의 리듬을 모두 이어냈어요.")
            .todayPrimaryTitleTypography()
            .foregroundStyle(ORTodayTypography.displayInk)
            .fixedSize(horizontal: false, vertical: true)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, ORSpacing.lg)
            .padding(.vertical, ORSpacing.xl)
            .orTodaySecondaryCard()
            .accessibilityAddTraits(.isHeader)
    }

    // MARK: - Primary Rhythm Area

    /// North Star stack: Primary card → Supporting cards.
    @ViewBuilder
    private var primaryRhythmArea: some View {
        if let primaryRhythm = viewModel.primaryRhythm {
            VStack(alignment: .leading, spacing: ORSpacing.md) {
                primaryRhythmCard(for: primaryRhythm)

                if hasSupportingContent {
                    supportingContentArea
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }

    private var hasSupportingContent: Bool {
        viewModel.secondaryNextRoutine != nil || viewModel.showsProgress
    }

    /// Supporting content area — secondary cards below Primary.
    @ViewBuilder
    private var supportingContentArea: some View {
        VStack(alignment: .leading, spacing: ORSpacing.sm) {
            if let secondaryNextRoutine = viewModel.secondaryNextRoutine {
                nextRhythmCard(for: secondaryNextRoutine)
            }

            if viewModel.showsProgress {
                progressCard
            }
        }
    }

    private var primaryRoleLabel: String {
        switch viewModel.primaryRole {
        case .current:
            return "현재"
        case .pastIncomplete:
            return "지나간 리듬"
        case .next:
            return "다음"
        case nil:
            return "현재"
        }
    }

    /// Primary Rhythm card — North Star chrome (glass, border, elevation).
    private func primaryRhythmCard(for primaryRhythm: Routine) -> some View {
        VStack(alignment: .leading, spacing: ORSpacing.md) {
            Text(primaryRoleLabel)
                .todayRoleLabelTypography()
                .foregroundStyle(ORTodayTypography.quietInk)
                .textCase(.uppercase)

            HStack(alignment: .center, spacing: ORSpacing.md) {
                Text(primaryRhythm.title)
                    .todayPrimaryTitleTypography()
                    .foregroundStyle(ORTodayTypography.displayInk)
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .accessibilityAddTraits(.isHeader)

                remainingTimeRing(for: primaryRhythm)
            }

            // Rhythm Meaning intentionally omitted — no approved data source.

            HStack(spacing: ORSpacing.xs) {
                Image(systemName: "clock")
                    .font(.system(size: 12, weight: .regular))
                    .foregroundStyle(ORTodayTypography.quietInk)

                Text(primaryMetaText(for: primaryRhythm))
                    .todayMetaTypography()
                    .foregroundStyle(ORTodayTypography.quietInk)
            }
        }
        .padding(ORSpacing.cardPadding)
        .frame(maxWidth: .infinity, alignment: .leading)
        .orTodayPrimaryCard()
    }

    /// Remaining-time ring — soft stroke, optically balanced beside the title.
    /// Trim follows remaining/total duration (presentation only). Falls back when duration is unknown.
    private func remainingTimeRing(for routine: Routine) -> some View {
        let label = remainingTimeLabel(for: routine)
        let trim = remainingTimeRingTrim(for: routine)

        return ZStack {
            Circle()
                .stroke(ORTodaySurface.ctaFill.opacity(0.14), lineWidth: 5)

            Circle()
                .trim(from: 0, to: trim)
                .stroke(
                    ORTodaySurface.ctaFill.opacity(0.72),
                    style: StrokeStyle(lineWidth: 5, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))

            Text(label)
                .todayRingTypography()
                .foregroundStyle(ORTodayTypography.supportingInk)
                .multilineTextAlignment(.center)
                .minimumScaleFactor(0.8)
                .padding(ORSpacing.xs)
        }
        .frame(width: 76, height: 76)
        .accessibilityLabel(label)
    }

    /// `remainingDuration / totalDuration`, clamped to 0...1. Fallback `0.72` if duration is unavailable.
    private func remainingTimeRingTrim(for routine: Routine) -> CGFloat {
        guard let endTime = routine.endTime else { return 0.72 }
        let totalDuration = endTime.timeIntervalSince(routine.startTime)
        guard totalDuration > 0 else { return 0.72 }

        let remainingDuration = max(0, endTime.timeIntervalSince(nowProvider()))
        return CGFloat(min(1, remainingDuration / totalDuration))
    }

    private func remainingTimeLabel(for routine: Routine) -> String {
        guard let endTime = routine.endTime else {
            return routine.formattedTime
        }

        let remaining = max(0, Int(endTime.timeIntervalSince(nowProvider()) / 60))
        if remaining <= 0 {
            return "곧"
        }
        return "\(remaining)분\n남음"
    }

    private func primaryMetaText(for routine: Routine) -> String {
        let category = categoryTitle(for: routine.category)
        if let minutes = durationMinutes(for: routine) {
            return "\(category) · \(minutes)분"
        }
        return "\(category) · \(routine.formattedTime)"
    }

    private func durationMinutes(for routine: Routine) -> Int? {
        guard let endTime = routine.endTime else { return nil }
        let minutes = Int(endTime.timeIntervalSince(routine.startTime) / 60)
        return minutes > 0 ? minutes : nil
    }

    private func categoryTitle(for category: RoutineCategory) -> String {
        switch category {
        case .morning: return "아침"
        case .focus: return "집중"
        case .movement: return "움직임"
        case .rest: return "휴식"
        case .evening: return "저녁"
        }
    }

    /// Gentle acknowledgment — soft sage glow so CTA belongs to the floating system.
    private func completionButton(for routine: Routine) -> some View {
        let isCompleting = viewModel.isCompleting(routine)

        return Button(action: { viewModel.completeRoutine(routine) }) {
            Group {
                if isCompleting {
                    ProgressView()
                        .tint(.white)
                        .accessibilityLabel("이어내는 중")
                } else {
                    Text("이어냈어요")
                        .todayCTATypography()
                        .foregroundStyle(.white)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: ORTodaySurface.ctaHeight)
            .background(ORTodaySurface.ctaFill)
            .clipShape(RoundedRectangle(cornerRadius: ORRadius.button, style: .continuous))
            .compositingGroup()
            .shadow(color: ORTodaySurface.ctaFill.opacity(0.38), radius: 18, x: 0, y: 10)
            .shadow(color: ORTodaySurface.ctaFill.opacity(0.22), radius: 6, x: 0, y: 3)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .disabled(isCompleting)
        .opacity(isCompleting ? 0.45 : 1)
        .accessibilityHint("이 리듬을 이어낸 것으로 표시합니다")
    }

    /// Up Next supporting card — North Star secondary chrome.
    private func nextRhythmCard(for routine: Routine) -> some View {
        HStack(alignment: .center, spacing: ORSpacing.md) {
            VStack(alignment: .leading, spacing: ORSpacing.xxs) {
                Text("다음 리듬")
                    .todaySecondaryLabelTypography()
                    .foregroundStyle(ORTodayTypography.quietInk)

                Text(routine.title)
                    .todaySecondaryValueTypography()
                    .foregroundStyle(ORTodayTypography.displayInk)
                    .lineLimit(1)
            }

            Spacer(minLength: ORSpacing.xs)

            Text(routine.startTime.formatted(Self.supportingTimeFormat))
                .todaySecondaryTrailingTypography()
                .foregroundStyle(ORTodayTypography.supportingInk)
        }
        .padding(.horizontal, ORSpacing.md)
        .padding(.vertical, ORSpacing.md)
        .frame(maxWidth: .infinity, alignment: .leading)
        .orTodaySecondaryCard()
        .accessibilityElement(children: .combine)
    }

    /// Today's Rhythm progress card — secondary glass + North Star flow indicator.
    private var progressCard: some View {
        VStack(alignment: .leading, spacing: ORSpacing.sm) {
            HStack {
                Text("오늘의 리듬")
                    .todayProgressLabelTypography()
                    .foregroundStyle(ORTodayTypography.supportingInk)

                Spacer(minLength: ORSpacing.xs)

                Text("\(viewModel.completedRoutineCount) / \(viewModel.totalRoutineCount)")
                    .todayProgressCountTypography()
                    .foregroundStyle(ORTodayTypography.quietInk)
            }

            TodayRhythmFlowIndicator(
                completedCount: viewModel.completedRoutineCount,
                totalCount: viewModel.totalRoutineCount
            )
        }
        .padding(.horizontal, ORSpacing.md)
        .padding(.vertical, ORSpacing.md)
        .frame(maxWidth: .infinity, alignment: .leading)
        .orTodaySecondaryCard()
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("오늘의 흐름")
        .accessibilityValue(
            "\(viewModel.totalRoutineCount)개의 리듬 중 \(viewModel.completedRoutineCount)개를 이어냈어요"
        )
    }

    private static let supportingTimeFormat = Date.FormatStyle(
        date: .omitted,
        time: .shortened
    )
    .locale(Locale(identifier: "ko_KR"))
}

// MARK: - Viewport height (Welcome compact spacing)

/// Reads the hosting window height so SE-class / Visual QA canvases (e.g. 320×568)
/// reliably trigger Welcome compact spacing — ScrollView GeometryReader is unreliable here.
private struct TodayWindowHeightReader: UIViewRepresentable {
    @Binding var height: CGFloat

    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        view.isUserInteractionEnabled = false
        view.backgroundColor = .clear
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        DispatchQueue.main.async {
            guard let windowHeight = uiView.window?.bounds.height, windowHeight > 0 else { return }
            if abs(height - windowHeight) > 0.5 {
                height = windowHeight
            }
        }
    }
}

// MARK: - Welcome-safe type modifiers (Active Today uses ORTodayTypography)

private struct TodayGreetingTypeModifier: ViewModifier {
    let isWelcome: Bool

    func body(content: Content) -> some View {
        if isWelcome {
            content.orTypography(.body, weight: .medium)
        } else {
            content.todayGreetingTypography()
        }
    }
}

private struct TodayDateTypeModifier: ViewModifier {
    let isWelcome: Bool

    func body(content: Content) -> some View {
        if isWelcome {
            content.orTypography(.caption)
        } else {
            content.todayDateTypography()
        }
    }
}


#Preview("Welcome Experience") {
    TodayView(
        repository: PreviewRoutineRepository(),
        recurringRhythmRepository: PreviewRecurringRhythmRepository(),
        liveActivityCoordinator: PreviewLiveActivityCoordinator(),
        nowProvider: { TodayPreviewData.morningNow }
    )
    .environmentObject(AppLaunchState.previewCompleted())
    .environmentObject(FirstRhythmJourneyProgress.preview(hasCompletedFirstRhythmJourney: false))
}

#Preview("Normal Experience Empty") {
    TodayView(
        repository: PreviewRoutineRepository(),
        recurringRhythmRepository: PreviewRecurringRhythmRepository(),
        liveActivityCoordinator: PreviewLiveActivityCoordinator(),
        nowProvider: { TodayPreviewData.morningNow }
    )
    .environmentObject(AppLaunchState.previewCompleted())
    .environmentObject(FirstRhythmJourneyProgress.preview(hasCompletedFirstRhythmJourney: true))
}

#Preview("Upcoming") {
    TodayView(
        repository: PreviewRoutineRepository(
            entities: TodayPreviewData.upcomingEntities()
        ),
        recurringRhythmRepository: PreviewRecurringRhythmRepository(),
        liveActivityCoordinator: PreviewLiveActivityCoordinator(),
        nowProvider: { TodayPreviewData.earlyMorningNow }
    )
    .environmentObject(AppLaunchState.previewCompleted())
    .environmentObject(FirstRhythmJourneyProgress.preview(hasCompletedFirstRhythmJourney: true))
}

#Preview("Current") {
    TodayView(
        repository: PreviewRoutineRepository(
            entities: TodayPreviewData.currentWithNextEntities()
        ),
        recurringRhythmRepository: PreviewRecurringRhythmRepository(),
        liveActivityCoordinator: PreviewLiveActivityCoordinator(),
        nowProvider: { TodayPreviewData.nowDuringCurrentRoutine }
    )
    .environmentObject(AppLaunchState.previewCompleted())
    .environmentObject(FirstRhythmJourneyProgress.preview(hasCompletedFirstRhythmJourney: true))
}

#Preview("Past Incomplete") {
    TodayView(
        repository: PreviewRoutineRepository(
            entities: TodayPreviewData.pastIncompleteOnlyEntities()
        ),
        recurringRhythmRepository: PreviewRecurringRhythmRepository(),
        liveActivityCoordinator: PreviewLiveActivityCoordinator(),
        nowProvider: { TodayPreviewData.nowDuringCurrentRoutine }
    )
    .environmentObject(AppLaunchState.previewCompleted())
    .environmentObject(FirstRhythmJourneyProgress.preview(hasCompletedFirstRhythmJourney: true))
}

#Preview("Day Complete") {
    TodayView(
        repository: PreviewRoutineRepository(
            entities: TodayPreviewData.completedEntities()
        ),
        recurringRhythmRepository: PreviewRecurringRhythmRepository(),
        liveActivityCoordinator: PreviewLiveActivityCoordinator(),
        nowProvider: { TodayPreviewData.nowDuringCurrentRoutine }
    )
    .environmentObject(AppLaunchState.previewCompleted())
    .environmentObject(FirstRhythmJourneyProgress.preview(hasCompletedFirstRhythmJourney: true))
}

#Preview("Current + Past Incomplete + Next") {
    TodayView(
        repository: PreviewRoutineRepository(
            entities: TodayPreviewData.currentOverdueNextEntities()
        ),
        recurringRhythmRepository: PreviewRecurringRhythmRepository(),
        liveActivityCoordinator: PreviewLiveActivityCoordinator(),
        nowProvider: { TodayPreviewData.nowDuringCurrentRoutine }
    )
    .environmentObject(AppLaunchState.previewCompleted())
    .environmentObject(FirstRhythmJourneyProgress.preview(hasCompletedFirstRhythmJourney: true))
}

#Preview("Multiple Past Incomplete") {
    TodayView(
        repository: PreviewRoutineRepository(
            entities: TodayPreviewData.multiplePastIncompleteEntities()
        ),
        recurringRhythmRepository: PreviewRecurringRhythmRepository(),
        liveActivityCoordinator: PreviewLiveActivityCoordinator(),
        nowProvider: { TodayPreviewData.nowDuringCurrentRoutine }
    )
    .environmentObject(AppLaunchState.previewCompleted())
    .environmentObject(FirstRhythmJourneyProgress.preview(hasCompletedFirstRhythmJourney: true))
}

#Preview("Completion Promotion") {
    TodayView(
        repository: PreviewRoutineRepository(
            entities: TodayPreviewData.pastIncompleteOnlyEntities()
        ),
        recurringRhythmRepository: PreviewRecurringRhythmRepository(),
        liveActivityCoordinator: PreviewLiveActivityCoordinator(),
        nowProvider: { TodayPreviewData.nowDuringCurrentRoutine }
    )
    .environmentObject(AppLaunchState.previewCompleted())
    .environmentObject(FirstRhythmJourneyProgress.preview(hasCompletedFirstRhythmJourney: true))
}

#Preview("Afternoon Greeting") {
    TodayView(
        repository: PreviewRoutineRepository(),
        recurringRhythmRepository: PreviewRecurringRhythmRepository(),
        liveActivityCoordinator: PreviewLiveActivityCoordinator(),
        nowProvider: { TodayPreviewData.afternoonNow }
    )
    .environmentObject(AppLaunchState.previewCompleted())
    .environmentObject(FirstRhythmJourneyProgress.preview(hasCompletedFirstRhythmJourney: false))
}

#Preview("Evening Greeting") {
    TodayView(
        repository: PreviewRoutineRepository(
            entities: TodayPreviewData.completedEntities()
        ),
        recurringRhythmRepository: PreviewRecurringRhythmRepository(),
        liveActivityCoordinator: PreviewLiveActivityCoordinator(),
        nowProvider: { TodayPreviewData.eveningNow }
    )
    .environmentObject(AppLaunchState.previewCompleted())
    .environmentObject(FirstRhythmJourneyProgress.preview(hasCompletedFirstRhythmJourney: true))
}

#Preview("Current — Large Dynamic Type") {
    TodayView(
        repository: PreviewRoutineRepository(
            entities: TodayPreviewData.currentWithNextEntities()
        ),
        recurringRhythmRepository: PreviewRecurringRhythmRepository(),
        liveActivityCoordinator: PreviewLiveActivityCoordinator(),
        nowProvider: { TodayPreviewData.nowDuringCurrentRoutine }
    )
    .environmentObject(AppLaunchState.previewCompleted())
    .environmentObject(FirstRhythmJourneyProgress.preview(hasCompletedFirstRhythmJourney: true))
    .environment(\.sizeCategory, .accessibilityLarge)
}

@MainActor
private final class PreviewRoutineRepository: RoutineRepository {
    private var entities: [RoutineEntity]

    init(entities: [RoutineEntity] = []) {
        self.entities = entities
    }

    func fetchRoutines() throws -> [RoutineEntity] {
        entities
    }

    func insert(_ input: RoutineCreationInput) throws {}

    func insert(_ routine: RoutineEntity) throws {
        entities.append(routine)
    }

    func update(_ input: RoutineCreationInput) throws {}

    func clearRecurrenceMetadata(id: UUID) throws {}

    func updateStatus(id: UUID, status: RoutineStatus) throws {
        guard let index = entities.firstIndex(where: { $0.id == id }) else {
            throw RoutineRepositoryError.routineNotFound
        }

        entities[index].statusRawValue = status.rawValue
        entities[index].updatedAt = Date()
    }

    func delete(_ routine: RoutineEntity) throws {
        entities.removeAll { $0.id == routine.id }
    }

    func delete(id: UUID) throws {
        entities.removeAll { $0.id == id }
    }

    func hasOccurrence(
        recurringRhythmID: UUID,
        occurrenceDate: Date
    ) throws -> Bool {
        entities.contains {
            $0.recurringRhythmID == recurringRhythmID
                && $0.occurrenceDate == occurrenceDate
        }
    }
}

@MainActor
private final class PreviewRecurringRhythmRepository: RecurringRhythmRepository {
    func insert(_ definition: RecurringRhythmEntity) throws {}
    func fetchActive() throws -> [RecurringRhythmEntity] { [] }
    func update(
        id: UUID,
        title: String,
        category: RoutineCategory,
        startMinutes: Int,
        durationMinutes: Int,
        recurrence: RecurrenceRule,
        reminderMinutes: Int?
    ) throws {}
    func deactivate(id: UUID) throws {}
}

/// Keeps previews deterministic and side-effect free.
/// Real Live Activity behavior is exercised in the app and widget targets, not previews.
private struct PreviewLiveActivityCoordinator: LiveActivityCoordinating {
    func sync(snapshot: TodayRhythmSnapshot) {}
    func end() {}
}

private enum TodayPreviewData {
    static var morningNow: Date {
        MockRoutineData.date(hour: 9, minute: 0)
    }

    static var earlyMorningNow: Date {
        MockRoutineData.date(hour: 6, minute: 0)
    }

    static var afternoonNow: Date {
        MockRoutineData.date(hour: 14, minute: 0)
    }

    static var eveningNow: Date {
        MockRoutineData.date(hour: 20, minute: 0)
    }

    static var nowDuringCurrentRoutine: Date {
        MockRoutineData.date(hour: 7, minute: 35)
    }

    @MainActor
    static func upcomingEntities() -> [RoutineEntity] {
        [
            RoutineEntity(
                routine: MockRoutineData.currentRoutine.updatingStatus(.upcoming)
            ),
            RoutineEntity(
                routine: MockRoutineData.nextRoutine
            )
        ]
    }

    @MainActor
    static func currentWithNextEntities() -> [RoutineEntity] {
        [
            RoutineEntity(
                routine: MockRoutineData.currentRoutine.updatingStatus(.upcoming)
            ),
            RoutineEntity(
                routine: MockRoutineData.nextRoutine
            )
        ]
    }

    @MainActor
    static func currentOverdueNextEntities() -> [RoutineEntity] {
        [
            RoutineEntity(
                routine: Routine(
                    title: "아침 스트레칭",
                    startTime: MockRoutineData.date(hour: 6, minute: 30),
                    endTime: MockRoutineData.date(hour: 6, minute: 45),
                    category: .morning,
                    status: .upcoming
                )
            ),
            RoutineEntity(
                routine: MockRoutineData.currentRoutine.updatingStatus(.upcoming)
            ),
            RoutineEntity(
                routine: MockRoutineData.nextRoutine
            )
        ]
    }

    /// No current routine — only a past incomplete routine and a future next.
    @MainActor
    static func pastIncompleteOnlyEntities() -> [RoutineEntity] {
        [
            RoutineEntity(
                routine: Routine(
                    title: "아침 스트레칭",
                    startTime: MockRoutineData.date(hour: 6, minute: 30),
                    endTime: MockRoutineData.date(hour: 6, minute: 45),
                    category: .morning,
                    status: .upcoming
                )
            ),
            RoutineEntity(
                routine: MockRoutineData.nextRoutine
            )
        ]
    }

    /// Two past incomplete routines. Only the earliest should appear as primary.
    @MainActor
    static func multiplePastIncompleteEntities() -> [RoutineEntity] {
        [
            RoutineEntity(
                routine: Routine(
                    title: "아침 스트레칭",
                    startTime: MockRoutineData.date(hour: 6, minute: 0),
                    endTime: MockRoutineData.date(hour: 6, minute: 15),
                    category: .morning,
                    status: .upcoming
                )
            ),
            RoutineEntity(
                routine: Routine(
                    title: "물 한잔 마시기",
                    startTime: MockRoutineData.date(hour: 6, minute: 30),
                    endTime: MockRoutineData.date(hour: 6, minute: 45),
                    category: .morning,
                    status: .upcoming
                )
            ),
            RoutineEntity(
                routine: MockRoutineData.nextRoutine
            )
        ]
    }

    @MainActor
    static func completedEntities() -> [RoutineEntity] {
        [
            RoutineEntity(
                routine: MockRoutineData.currentRoutine.updatingStatus(.completed)
            ),
            RoutineEntity(
                routine: MockRoutineData.nextRoutine.updatingStatus(.completed)
            )
        ]
    }
}
