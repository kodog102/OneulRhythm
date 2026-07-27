//
//  TodayView.swift
//  OneulRhythm
//

import SwiftUI

struct TodayView: View {
    @Environment(\.scenePhase) private var scenePhase
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @EnvironmentObject private var launchState: AppLaunchState
    @EnvironmentObject private var firstRhythmJourneyProgress: FirstRhythmJourneyProgress
    @StateObject private var viewModel: TodayViewModel
    @State private var isCreateRhythmPresented = false
    @State private var isManageRhythmsPresented = false
    @State private var isSettingsPresented = false

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
                    headerGroup

                    screenContent
                        .padding(.top, contentTopSpacing)
                        .id(contentTransitionID)
                        .transition(contentTransition)
                }
                .padding(.horizontal, ORSpacing.screenHorizontal)
                .padding(.bottom, ORSpacing.xl)
                .frame(maxWidth: .infinity, alignment: .leading)
                .animation(contentAnimation, value: contentTransitionID)
            }
            .safeAreaPadding(.top, ORSpacing.screenTop)
            .background(ORColors.background.ignoresSafeArea())
            .toolbar {
                // Settings + My Rhythms: hidden on Welcome (First Journey). Settings UI Spec / DR-015.
                if firstRhythmJourneyProgress.hasCompletedFirstRhythmJourney {
                    ToolbarItem(placement: .topBarLeading) {
                        Button {
                            isSettingsPresented = true
                        } label: {
                            Image(systemName: "gearshape")
                                .foregroundStyle(ORColors.textSecondary)
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
                                .orTypography(.caption, weight: .medium)
                                .foregroundStyle(ORColors.textSecondary)
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

    /// Greeting + Date as one atmospheric header group. Never competes with Hero.
    private var headerGroup: some View {
        VStack(alignment: .leading, spacing: ORSpacing.xxs) {
            Text(viewModel.greetingText)
                .orTypography(
                    isWelcomeExperienceActive ? .body : .title,
                    weight: .medium
                )
                .foregroundStyle(
                    isWelcomeExperienceActive
                        ? ORColors.textSecondary
                        : ORColors.textPrimary
                )
                // Welcome: atmosphere only — Hero Meaning owns the primary header.
                .accessibilityAddTraits(isWelcomeExperienceActive ? [] : .isHeader)

            Text(viewModel.formattedTodayDate)
                .orTypography(isWelcomeExperienceActive ? .caption : .body)
                .foregroundStyle(
                    isWelcomeExperienceActive
                        ? ORColors.textTertiary
                        : ORColors.textSecondary
                )
        }
        .frame(maxWidth: .infinity, alignment: .leading)
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
            onCreateRhythm: { isCreateRhythmPresented = true }
        )
    }

    private var emptyPhase: TodayEmptyPhase {
        firstRhythmJourneyProgress.hasCompletedFirstRhythmJourney
            ? .normalExperience
            : .firstJourney
    }

    /// Welcome gives Breath Flow generous air after the atmospheric layer.
    /// Non-Welcome uses a tighter gap for glanceable density.
    private var contentTopSpacing: CGFloat {
        isWelcomeExperienceActive ? ORSpacing.xxl : ORSpacing.lg
    }

    /// Approved Day Complete copy. Quiet closure — never celebratory.
    private var dayCompleteMessage: some View {
        Text("오늘의 리듬을 모두 이어냈어요.")
            .orTypography(.title)
            .foregroundStyle(ORColors.textPrimary)
            .fixedSize(horizontal: false, vertical: true)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.vertical, ORSpacing.lg)
    }

    // MARK: - Primary Rhythm Area

    /// Emotional center of Today.
    /// Order: Primary → Next → Progress as one continuous supporting flow.
    @ViewBuilder
    private var primaryRhythmArea: some View {
        if let primaryRhythm = viewModel.primaryRhythm {
            VStack(alignment: .leading, spacing: 0) {
                primaryRhythmCard(for: primaryRhythm)

                if let secondaryNextRoutine = viewModel.secondaryNextRoutine {
                    nextRhythmSection(for: secondaryNextRoutine)
                        .padding(.top, ORSpacing.sm)
                        .padding(.leading, supportingContentLeadingInset)
                }

                if viewModel.showsProgress {
                    TodayProgressView(
                        completedCount: viewModel.completedRoutineCount,
                        totalCount: viewModel.totalRoutineCount,
                        progress: viewModel.progress
                    )
                    .padding(.top, ORSpacing.sm)
                    .padding(.leading, supportingContentLeadingInset)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }

    /// Soft inset so Next / Progress align with Primary card content, not the card chrome edge.
    private var supportingContentLeadingInset: CGFloat {
        ORSpacing.cardPadding
    }

    /// Primary surface — emphasized by hierarchy and surrounding space, not enlargement.
    private func primaryRhythmCard(for primaryRhythm: Routine) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            // Level 1 — Primary Rhythm
            Text(primaryRhythm.title)
                .orTypography(.largeTitle)
                .foregroundStyle(ORColors.textPrimary)
                .lineLimit(2)
                .fixedSize(horizontal: false, vertical: true)
                .frame(maxWidth: .infinity, alignment: .leading)
                .accessibilityAddTraits(.isHeader)

            // Rhythm Meaning intentionally omitted in Sprint 8 —
            // no approved data source; never show placeholder.

            // Level 4 — Time
            Text(primaryRhythm.formattedTime)
                .orTypography(.caption)
                .foregroundStyle(ORColors.textTertiary)
                .padding(.top, ORSpacing.xs)

            if viewModel.showsCompletionButton {
                completionButton(for: primaryRhythm)
                    .padding(.top, ORSpacing.md)
            }
        }
        .padding(.vertical, ORSpacing.lg)
        .padding(.horizontal, ORSpacing.cardPadding)
        .frame(maxWidth: .infinity, alignment: .leading)
        .orCard()
    }

    /// Gentle acknowledgment. Visible only when acknowledgment is possible.
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
                        .orTypography(.body, weight: .semibold)
                        .foregroundStyle(.white)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: ORSpacing.primaryButtonHeight)
            .background(ORColors.primary)
            .clipShape(RoundedRectangle(cornerRadius: ORRadius.button, style: .continuous))
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .disabled(isCompleting)
        .opacity(isCompleting ? 0.45 : 1)
        .accessibilityHint("이 리듬을 이어낸 것으로 표시합니다")
    }

    /// Level 5 — quiet orientation for what follows. Never a second focus.
    private func nextRhythmSection(for routine: Routine) -> some View {
        VStack(alignment: .leading, spacing: ORSpacing.xxs) {
            Text("다음 리듬")
                .orTypography(.caption)
                .foregroundStyle(ORColors.textTertiary)

            Text(routine.title)
                .orTypography(.caption)
                .foregroundStyle(ORColors.textSecondary)

            Text(routine.formattedTime)
                .orTypography(.caption)
                .foregroundStyle(ORColors.textTertiary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .accessibilityElement(children: .combine)
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
