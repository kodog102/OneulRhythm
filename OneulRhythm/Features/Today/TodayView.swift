//
//  TodayView.swift
//  OneulRhythm
//

import SwiftUI

struct TodayView: View {
    @Environment(\.scenePhase) private var scenePhase
    @EnvironmentObject private var launchState: AppLaunchState
    @StateObject private var viewModel: TodayViewModel
    @State private var isCreateRhythmPresented = false

    private let onSaveRoutine: (RoutineCreationInput) throws -> Void
    private let onAppBecomeActive: () -> Void
    private let nowProvider: () -> Date

    init(
        repository: RoutineRepository,
        onSaveRoutine: @escaping (RoutineCreationInput) throws -> Void = { _ in },
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
        self.onSaveRoutine = onSaveRoutine
        self.onAppBecomeActive = onAppBecomeActive
        self.nowProvider = nowProvider
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    greetingSection

                    dateSection
                        .padding(.top, ORSpacing.xs)

                    screenContent
                        .padding(.top, ORSpacing.xxxl)

                    if viewModel.showsProgress,
                       viewModel.screenPresentation != .empty {
                        TodayProgressView(
                            completedCount: viewModel.completedRoutineCount,
                            totalCount: viewModel.totalRoutineCount,
                            progress: viewModel.progress
                        )
                        .padding(.top, ORSpacing.xxxl)
                    }
                }
                .padding(.horizontal, ORSpacing.screenHorizontal)
                .padding(.bottom, ORSpacing.scrollBottom)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .safeAreaPadding(.top, ORSpacing.screenTop)
            .background(ORColors.background.ignoresSafeArea())
            .navigationDestination(isPresented: $isCreateRhythmPresented) {
                AddRoutineView(
                    onSave: { input in
                        try onSaveRoutine(input)
                        viewModel.loadRoutines()
                    },
                    nowProvider: nowProvider
                )
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
            "리듬을 완료하지 못했어요",
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

    /// Level 2 — warm emotional entry. Never interactive.
    private var greetingSection: some View {
        Text(viewModel.greetingText)
            .orTypography(.title)
            .foregroundStyle(ORColors.textPrimary)
            .accessibilityAddTraits(.isHeader)
    }

    /// Level 3 — temporal orientation. Secondary emphasis.
    private var dateSection: some View {
        Text(viewModel.formattedTodayDate)
            .orTypography(.body)
            .foregroundStyle(ORColors.textSecondary)
    }

    // MARK: - Screen Content

    @ViewBuilder
    private var screenContent: some View {
        if viewModel.isLoading {
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

    /// Empty: Guidance + Create Rhythm CTA only.
    /// CTA is Level 7 — subordinate to Empty Guidance; visible only when zero routines.
    private var emptyState: some View {
        VStack(alignment: .leading, spacing: ORSpacing.xl) {
            emptyGuidance
            createRhythmCTA
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    /// Approved Empty copy. Friendly, calm, never urgent.
    private var emptyGuidance: some View {
        Text("오늘의 첫 리듬을 만들어보세요.")
            .orTypography(.title)
            .foregroundStyle(ORColors.textPrimary)
            .fixedSize(horizontal: false, vertical: true)
            .frame(maxWidth: .infinity, alignment: .leading)
    }

    /// Approved Create Rhythm CTA. Empty-only onboarding affordance.
    private var createRhythmCTA: some View {
        AddRoutineCardView(
            title: "리듬 만들기",
            action: { isCreateRhythmPresented = true }
        )
    }

    /// Approved Day Complete copy. Quiet closure — never celebratory.
    private var dayCompleteMessage: some View {
        Text("오늘의 리듬을 모두 이어냈어요.")
            .orTypography(.title)
            .foregroundStyle(ORColors.textPrimary)
            .fixedSize(horizontal: false, vertical: true)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.vertical, ORSpacing.xl)
    }

    // MARK: - Primary Rhythm Area

    /// Emotional center of Today.
    /// Order: Primary Rhythm → Rhythm Meaning (hidden) → Time → Completion → Next.
    @ViewBuilder
    private var primaryRhythmArea: some View {
        if let primaryRhythm = viewModel.primaryRhythm {
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
                    .padding(.top, ORSpacing.lg)

                if viewModel.showsCompletionButton {
                    completionButton(for: primaryRhythm)
                        .padding(.top, ORSpacing.xl)
                }

                if let secondaryNextRoutine = viewModel.secondaryNextRoutine {
                    nextRhythmSection(for: secondaryNextRoutine)
                        .padding(.top, ORSpacing.xxxl)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .animation(.easeInOut(duration: 0.25), value: primaryRhythm.id)
        }
    }

    /// Gentle acknowledgment. Visible only when completion is possible.
    private func completionButton(for routine: Routine) -> some View {
        let isCompleting = viewModel.isCompleting(routine)

        return Button(action: { viewModel.completeRoutine(routine) }) {
            Group {
                if isCompleting {
                    ProgressView()
                        .tint(.white)
                        .accessibilityLabel("완료 저장 중")
                } else {
                    Text("완료했어요")
                        .orTypography(.body, weight: .semibold)
                        .foregroundStyle(.white)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: ORSpacing.primaryButtonHeight)
            .background(ORColors.primary)
            .clipShape(RoundedRectangle(cornerRadius: ORRadius.button, style: .continuous))
        }
        .buttonStyle(.plain)
        .disabled(isCompleting)
        .opacity(isCompleting ? 0.45 : 1)
        .accessibilityHint("이 리듬을 완료로 표시합니다")
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

#Preview("Empty") {
    TodayView(
        repository: PreviewRoutineRepository(),
        liveActivityCoordinator: PreviewLiveActivityCoordinator(),
        nowProvider: { TodayPreviewData.morningNow }
    )
    .environmentObject(AppLaunchState.previewCompleted())
}

#Preview("Upcoming") {
    TodayView(
        repository: PreviewRoutineRepository(
            entities: TodayPreviewData.upcomingEntities()
        ),
        liveActivityCoordinator: PreviewLiveActivityCoordinator(),
        nowProvider: { TodayPreviewData.earlyMorningNow }
    )
    .environmentObject(AppLaunchState.previewCompleted())
}

#Preview("Current") {
    TodayView(
        repository: PreviewRoutineRepository(
            entities: TodayPreviewData.currentWithNextEntities()
        ),
        liveActivityCoordinator: PreviewLiveActivityCoordinator(),
        nowProvider: { TodayPreviewData.nowDuringCurrentRoutine }
    )
    .environmentObject(AppLaunchState.previewCompleted())
}

#Preview("Past Incomplete") {
    TodayView(
        repository: PreviewRoutineRepository(
            entities: TodayPreviewData.pastIncompleteOnlyEntities()
        ),
        liveActivityCoordinator: PreviewLiveActivityCoordinator(),
        nowProvider: { TodayPreviewData.nowDuringCurrentRoutine }
    )
    .environmentObject(AppLaunchState.previewCompleted())
}

#Preview("Day Complete") {
    TodayView(
        repository: PreviewRoutineRepository(
            entities: TodayPreviewData.completedEntities()
        ),
        liveActivityCoordinator: PreviewLiveActivityCoordinator(),
        nowProvider: { TodayPreviewData.nowDuringCurrentRoutine }
    )
    .environmentObject(AppLaunchState.previewCompleted())
}

#Preview("Current + Past Incomplete + Next") {
    TodayView(
        repository: PreviewRoutineRepository(
            entities: TodayPreviewData.currentOverdueNextEntities()
        ),
        liveActivityCoordinator: PreviewLiveActivityCoordinator(),
        nowProvider: { TodayPreviewData.nowDuringCurrentRoutine }
    )
    .environmentObject(AppLaunchState.previewCompleted())
}

#Preview("Multiple Past Incomplete") {
    TodayView(
        repository: PreviewRoutineRepository(
            entities: TodayPreviewData.multiplePastIncompleteEntities()
        ),
        liveActivityCoordinator: PreviewLiveActivityCoordinator(),
        nowProvider: { TodayPreviewData.nowDuringCurrentRoutine }
    )
    .environmentObject(AppLaunchState.previewCompleted())
}

#Preview("Completion Promotion") {
    TodayView(
        repository: PreviewRoutineRepository(
            entities: TodayPreviewData.pastIncompleteOnlyEntities()
        ),
        liveActivityCoordinator: PreviewLiveActivityCoordinator(),
        nowProvider: { TodayPreviewData.nowDuringCurrentRoutine }
    )
    .environmentObject(AppLaunchState.previewCompleted())
}

#Preview("Afternoon Greeting") {
    TodayView(
        repository: PreviewRoutineRepository(),
        liveActivityCoordinator: PreviewLiveActivityCoordinator(),
        nowProvider: { TodayPreviewData.afternoonNow }
    )
    .environmentObject(AppLaunchState.previewCompleted())
}

#Preview("Evening Greeting") {
    TodayView(
        repository: PreviewRoutineRepository(
            entities: TodayPreviewData.completedEntities()
        ),
        liveActivityCoordinator: PreviewLiveActivityCoordinator(),
        nowProvider: { TodayPreviewData.eveningNow }
    )
    .environmentObject(AppLaunchState.previewCompleted())
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
