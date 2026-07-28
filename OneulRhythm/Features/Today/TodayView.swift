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
            Group {
                if usesBottomAnchoredContentLayout {
                    if usesActiveBottomAnchoredLayout {
                        // Active — keep Sprint 19-1D canvas (safeAreaInset CTA).
                        activeBottomAnchoredCanvas
                    } else {
                        // Empty / Day Complete — bottom inset + flexible column (Sprint 19-1F).
                        emptyOrCompleteBottomAnchoredCanvas
                    }
                } else {
                    topFlowTodayCanvas
                }
            }
            // 1. Safe Area
            .safeAreaPadding(
                .top,
                usesCompactWelcomeSpacing ? ORSpacing.sm : ORSpacing.screenTop
            )
            // 2. Background layer — shared atmosphere (Sprint 19-1A)
            .background {
                ORAtmosphereBackground()
            }
            .toolbar {
                // First Journey (Welcome) product exception — Settings UI Spec / DR-015:
                // Settings and My Rhythms stay hidden until first successful rhythm creation.
                // Same lifecycle gate for both entries; Welcome remains product introduction only.
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
                    onReturnToTodayAfterSave: {
                        // Sprint 19-2H — after save from Editor via My Rhythms, return to Today
                        // by dismissing the whole Management destination in one step.
                        isManageRhythmsPresented = false
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
            if isTodaySurfaceVisible {
                viewModel.startTimelineAutoRefresh()
            }
        }
        .onChange(of: scenePhase) { _, phase in
            guard launchState.didCompleteInitialRhythmSync else { return }
            if phase == .active {
                onAppBecomeActive()
                viewModel.loadRoutines()
                if isTodaySurfaceVisible {
                    viewModel.startTimelineAutoRefresh()
                }
            } else {
                viewModel.stopTimelineAutoRefresh()
            }
        }
        .onChange(of: isTodaySurfaceVisible) { _, visible in
            guard launchState.didCompleteInitialRhythmSync else { return }
            if visible, scenePhase == .active {
                // Catch up any boundaries that elapsed while Today was covered.
                viewModel.loadRoutines()
                viewModel.startTimelineAutoRefresh()
            } else {
                viewModel.stopTimelineAutoRefresh()
            }
        }
        .onDisappear {
            viewModel.stopTimelineAutoRefresh()
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

    /// Today is the uncovered foreground surface (not under create / manage / settings).
    private var isTodaySurfaceVisible: Bool {
        !isCreateRhythmPresented && !isManageRhythmsPresented && !isSettingsPresented
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

    /// Active / Empty / Day Complete — pin content from the bottom safe area upward (Sprint 19-1D/E).
    private var usesBottomAnchoredContentLayout: Bool {
        !isAwaitingInitialToday
            && !viewModel.isLoading
            && viewModel.loadErrorMessage == nil
            && {
                switch viewModel.screenPresentation {
                case .upcoming, .current, .pastIncomplete, .empty, .dayComplete:
                    return true
                }
            }()
    }

    /// Active Today only — existing 19-1D GeometryReader + safeAreaInset canvas.
    private var usesActiveBottomAnchoredLayout: Bool {
        usesBottomAnchoredContentLayout
            && {
                switch viewModel.screenPresentation {
                case .upcoming, .current, .pastIncomplete:
                    return true
                case .empty, .dayComplete:
                    return false
                }
            }()
    }

    /// Short Today canvas (SE-class / Visual QA 320×568).
    private var usesShortTodayCanvas: Bool {
        (viewportHeight > 0 && viewportHeight < 700)
            || verticalSizeClass == .compact
    }

    /// Bottom inset for Empty / Day Complete fill layout.
    private var bottomContentPadding: CGFloat {
        if usesCompactWelcomeSpacing || usesShortTodayCanvas {
            return ORSpacing.md
        }
        return ORSpacing.scrollBottom
    }

    // MARK: - Active bottom-anchored canvas (unchanged Sprint 19-1D)

    /// Active Today — header top, cards pinned above bottom CTA inset.
    private var activeBottomAnchoredCanvas: some View {
        GeometryReader { geometry in
            let canvasSize = geometry.size
            let isShortCanvas = canvasSize.height < 620

            ViewThatFits(in: .vertical) {
                activeBottomAnchoredStack(isShortCanvas: isShortCanvas)
                    .frame(width: canvasSize.width, height: canvasSize.height, alignment: .top)

                ScrollView {
                    activeBottomAnchoredStack(isShortCanvas: isShortCanvas)
                        .frame(minHeight: canvasSize.height, alignment: .top)
                }
            }
        }
        .safeAreaInset(edge: .bottom, spacing: 0) {
            if showsBottomActionSlot, let primaryRhythm = viewModel.primaryRhythm {
                completionButton(for: primaryRhythm)
                    .padding(.horizontal, ORSpacing.screenHorizontal)
                    .padding(.top, ORSpacing.md)
                    .padding(.bottom, ORSpacing.md)
            }
        }
    }

    private func activeBottomAnchoredStack(isShortCanvas: Bool) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            headerGroup
            Spacer(minLength: isShortCanvas ? ORSpacing.xxs : ORSpacing.md)
            screenContent(isShortCanvas: isShortCanvas)
                .frame(maxWidth: .infinity, alignment: .leading)
                .id(contentTransitionID)
                .transition(contentTransition)
        }
        .padding(.horizontal, ORSpacing.screenHorizontal)
        .frame(maxWidth: .infinity, alignment: .leading)
        .animation(contentAnimation, value: contentTransitionID)
    }

    // MARK: - Empty / Day Complete bottom-anchored canvas (Sprint 19-1F)

    /// Empty / Day Complete — top header, flexible space, bottom stack via safeAreaInset (Sprint 19-1F).
    /// No GeometryReader: a full-height reader + external inset overflowed SE; padding inside the
    /// inset is reserved by the safe-area layout so CTA/card cannot paint under the bottom edge.
    @ViewBuilder
    private var emptyOrCompleteBottomAnchoredCanvas: some View {
        let isShortCanvas = usesShortTodayCanvas
        let bottomPad = emptyOrCompleteBottomPad(isShortCanvas: isShortCanvas)

        Group {
            if isWelcomeExperienceActive && isShortCanvas {
                ScrollView {
                    VStack(alignment: .leading, spacing: 0) {
                        headerGroup
                        emptyOrCompleteScrollableBody(isShortCanvas: isShortCanvas)
                            .padding(.top, ORSpacing.md)
                            .id(contentTransitionID)
                            .transition(contentTransition)
                    }
                    .padding(.horizontal, ORSpacing.screenHorizontal)
                    .padding(.bottom, ORSpacing.md)
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            } else {
                VStack(alignment: .leading, spacing: 0) {
                    headerGroup
                    Spacer(minLength: 0)
                    emptyOrCompleteInsetBody(isShortCanvas: isShortCanvas)
                        .id(contentTransitionID)
                        .transition(contentTransition)
                }
                .padding(.horizontal, ORSpacing.screenHorizontal)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            }
        }
        .animation(contentAnimation, value: contentTransitionID)
        .safeAreaInset(edge: .bottom, spacing: 0) {
            emptyOrCompleteBottomInset(isShortCanvas: isShortCanvas, bottomPad: bottomPad)
        }
    }

    /// Bottom clearance above the physical bottom edge (SE keeps lg; taller canvases use scrollBottom).
    private func emptyOrCompleteBottomPad(isShortCanvas: Bool) -> CGFloat {
        isShortCanvas ? ORSpacing.lg : bottomContentPadding
    }

    /// Main-column body above the bottom inset (message/card only — Empty CTA lives in the inset).
    @ViewBuilder
    private func emptyOrCompleteInsetBody(isShortCanvas: Bool) -> some View {
        switch viewModel.screenPresentation {
        case .empty:
            TodayEmptyStateView(
                phase: emptyPhase,
                usesCompactVerticalSpacing: usesCompactWelcomeSpacing || isShortCanvas,
                embedsPrimaryAction: false,
                onCreateRhythm: { isCreateRhythmPresented = true }
            )
        case .dayComplete:
            // Day Complete card is the bottom inset itself (no duplicate in the column).
            EmptyView()
        default:
            EmptyView()
        }
    }

    /// Scroll body for First Journey short canvas (CTA remains in the bottom inset).
    @ViewBuilder
    private func emptyOrCompleteScrollableBody(isShortCanvas: Bool) -> some View {
        switch viewModel.screenPresentation {
        case .empty:
            TodayEmptyStateView(
                phase: emptyPhase,
                usesCompactVerticalSpacing: usesCompactWelcomeSpacing || isShortCanvas,
                embedsPrimaryAction: false,
                onCreateRhythm: { isCreateRhythmPresented = true }
            )
        case .dayComplete:
            EmptyView()
        default:
            EmptyView()
        }
    }

    /// Bottom safe-area inset: Empty CTA, or Day Complete card. Padding is part of the inset.
    @ViewBuilder
    private func emptyOrCompleteBottomInset(isShortCanvas: Bool, bottomPad: CGFloat) -> some View {
        VStack(spacing: 0) {
            switch viewModel.screenPresentation {
            case .empty:
                if showsEmptyPrimaryActionInset {
                    emptyPrimaryActionInset
                        .padding(.horizontal, ORSpacing.screenHorizontal)
                        .padding(.top, ORSpacing.md)
                }
            case .dayComplete:
                dayCompleteMessage
                    .padding(.horizontal, ORSpacing.screenHorizontal)
            default:
                EmptyView()
            }

            Color.clear
                .frame(height: bottomPad)
                .accessibilityHidden(true)
        }
    }

    private var showsEmptyPrimaryActionInset: Bool {
        !isAwaitingInitialToday
            && !viewModel.isLoading
            && viewModel.loadErrorMessage == nil
            && viewModel.screenPresentation == .empty
    }

    /// Loading / error / awaiting — top-flow scroll layout (not bottom-anchored states).
    private var topFlowTodayCanvas: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                headerGroup

                screenContent(isShortCanvas: false)
                    .padding(.top, contentTopSpacing)
                    .id(contentTransitionID)
                    .transition(contentTransition)

                if showsBottomActionSlot, let primaryRhythm = viewModel.primaryRhythm {
                    completionButton(for: primaryRhythm)
                        .padding(.top, ORSpacing.xl)
                }
            }
            .padding(.horizontal, ORSpacing.screenHorizontal)
            .padding(.bottom, bottomContentPadding)
            .frame(maxWidth: .infinity, alignment: .leading)
            .animation(contentAnimation, value: contentTransitionID)
        }
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
    private func screenContent(isShortCanvas: Bool) -> some View {
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
                primaryRhythmArea(isShortCanvas: isShortCanvas)
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
    /// Top-flow / Active paths only — Empty bottom-anchored canvas builds its own stack.
    private var emptyState: some View {
        TodayEmptyStateView(
            phase: emptyPhase,
            usesCompactVerticalSpacing: usesCompactWelcomeSpacing,
            embedsPrimaryAction: true,
            onCreateRhythm: { isCreateRhythmPresented = true }
        )
    }

    /// Create action for Empty scroll fallback (safeAreaInset).
    @ViewBuilder
    private var emptyPrimaryActionInset: some View {
        TodayEmptyStateView(
            phase: emptyPhase,
            usesCompactVerticalSpacing: usesCompactWelcomeSpacing || usesShortTodayCanvas,
            embedsPrimaryAction: true,
            onCreateRhythm: { isCreateRhythmPresented = true }
        )
        .primaryActionView
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
        Text("오늘의 리듬을 모두 마쳤어요.")
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
    private func primaryRhythmArea(isShortCanvas: Bool) -> some View {
        if let primaryRhythm = viewModel.primaryRhythm {
            VStack(alignment: .leading, spacing: isShortCanvas ? ORSpacing.sm : ORSpacing.md) {
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
        let label = TodayPrimaryRingPresentation.label(
            role: viewModel.primaryRole,
            routine: routine,
            now: nowProvider()
        )
        let trim = TodayPrimaryRingPresentation.trim(
            role: viewModel.primaryRole,
            routine: routine,
            now: nowProvider()
        )

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
