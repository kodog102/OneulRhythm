//
//  TodayView.swift
//  OneulRhythm
//

import SwiftUI

struct TodayView: View {
    @Environment(\.scenePhase) private var scenePhase
    @EnvironmentObject private var launchState: AppLaunchState
    @StateObject private var viewModel: TodayViewModel
    @State private var isAddRoutinePresented = false

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
                VStack(alignment: .leading, spacing: ORSpacing.sectionGap) {
                    header
                    screenContent

                    AddRoutineCardView(
                        title: "리듬 추가하기",
                        action: { isAddRoutinePresented = true }
                    )
                }
                .padding(.horizontal, ORSpacing.screenHorizontal)
                .padding(.bottom, ORSpacing.scrollBottom)
            }
            .safeAreaPadding(.top, ORSpacing.screenTop)
            .background(ORColors.background.ignoresSafeArea())
            .navigationDestination(isPresented: $isAddRoutinePresented) {
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

    private var header: some View {
        VStack(alignment: .leading, spacing: ORSpacing.xs) {
            Text(viewModel.formattedTodayDate)
                .orTypography(.caption)
                .foregroundStyle(ORColors.textSecondary)
                .accessibilityAddTraits(.isHeader)

            Text("오늘 당신의 리듬은\n어떤가요")
                .orTypography(.largeTitle)
                .foregroundStyle(ORColors.textPrimary)
        }
        .padding(.bottom, ORSpacing.xs)
    }

    @ViewBuilder
    private var screenContent: some View {
        if viewModel.isLoading {
            loadingState
        } else if let loadErrorMessage = viewModel.loadErrorMessage {
            errorState(message: loadErrorMessage)
        } else if viewModel.routines.isEmpty {
            emptyState
        } else {
            routineContent
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
        .frame(maxWidth: .infinity, alignment: .center)
        .padding(.vertical, ORSpacing.lg)
    }

    private var emptyState: some View {
        VStack(alignment: .leading, spacing: ORSpacing.xs) {
            Text("아직 등록된 리듬이 없어요")
                .orTypography(.title)
                .foregroundStyle(ORColors.textPrimary)

            Text("오늘의 첫 리듬을 만들어보세요.")
                .orTypography(.body)
                .foregroundStyle(ORColors.textSecondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(ORSpacing.cardPadding)
        .orCard()
    }

    private func errorState(message: String) -> some View {
        Text(message)
            .orTypography(.body)
            .foregroundStyle(ORColors.textSecondary)
            .fixedSize(horizontal: false, vertical: true)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(ORSpacing.cardPadding)
            .orCard()
    }

    @ViewBuilder
    private var routineContent: some View {
        primaryRoutineCard

        TodayProgressView(
            title: "오늘의 흐름",
            completedCount: viewModel.completedRoutineCount,
            totalCount: viewModel.totalRoutineCount,
            message: viewModel.progressMessage,
            progress: viewModel.progress
        )
    }

    /// Renders exactly one primary routine card, chosen by
    /// `TodayViewModel.primaryRole` (current → past incomplete → next).
    /// The next routine, when not primary itself, may appear only as quiet
    /// secondary information — never as a second competing card.
    @ViewBuilder
    private var primaryRoutineCard: some View {
        if let primaryRoutine = viewModel.primaryRoutine, let primaryRole = viewModel.primaryRole {
            VStack(alignment: .leading, spacing: ORSpacing.xs) {
                RoutineCardView(
                    routine: primaryRoutine,
                    scheduleRole: primaryRole.scheduleRole,
                    isCompleting: viewModel.isCompleting(primaryRoutine),
                    onComplete: { viewModel.completeRoutine(primaryRoutine) }
                )

                if primaryRole == .pastIncomplete {
                    Text("지금 이어가도 괜찮아요")
                        .orTypography(.caption)
                        .foregroundStyle(ORColors.textSecondary)
                        .padding(.horizontal, ORSpacing.xs)
                }

                if let secondaryNextRoutine = viewModel.secondaryNextRoutine {
                    nextRhythmPreview(for: secondaryNextRoutine)
                }
            }
            .animation(.easeInOut(duration: 0.25), value: primaryRoutine.id)
        }
    }

    /// A lightweight, non-interactive preview of the next rhythm shown
    /// beneath the primary card. Deliberately card-less and button-less so
    /// it never competes with the one primary routine. A subtle vertical
    /// accent visually connects it to the primary rhythm above.
    private func nextRhythmPreview(for routine: Routine) -> some View {
        HStack(alignment: .top, spacing: ORSpacing.xs) {
            Capsule()
                .fill(ORColors.divider)
                .frame(width: 2)
                .frame(maxHeight: .infinity)

            VStack(alignment: .leading, spacing: ORSpacing.xxs) {
                Text("다음 리듬")
                    .orTypography(.caption, weight: .medium)
                    .foregroundStyle(ORColors.textTertiary)

                Text(routine.title)
                    .orTypography(.body)
                    .foregroundStyle(ORColors.textSecondary)

                Text(routine.formattedTime)
                    .orTypography(.caption)
                    .foregroundStyle(ORColors.textTertiary)
            }
        }
        .padding(.horizontal, ORSpacing.xs)
        .padding(.top, ORSpacing.xxs)
    }
}

private extension TodayPrimaryRole {
    /// Maps the ViewModel's presentation role onto `RoutineCardView`'s
    /// existing role-driven styling. `.pastIncomplete` reuses the card's
    /// current "지나간 리듬" section label and completion flow unchanged.
    var scheduleRole: RoutineScheduleRole {
        switch self {
        case .current:
            return .current
        case .pastIncomplete:
            return .overdue
        case .next:
            return .next
        }
    }
}

#Preview("Empty Day") {
    TodayView(
        repository: PreviewRoutineRepository(),
        liveActivityCoordinator: PreviewLiveActivityCoordinator(),
        nowProvider: { TodayPreviewData.nowDuringCurrentRoutine }
    )
    .environmentObject(AppLaunchState.previewCompleted())
}

#Preview("None Completed") {
    TodayView(
        repository: PreviewRoutineRepository(
            entities: TodayPreviewData.currentOverdueNextEntities()
        ),
        liveActivityCoordinator: PreviewLiveActivityCoordinator(),
        nowProvider: { TodayPreviewData.nowDuringCurrentRoutine }
    )
    .environmentObject(AppLaunchState.previewCompleted())
}

#Preview("Partially Completed") {
    TodayView(
        repository: PreviewRoutineRepository(
            entities: TodayPreviewData.partiallyCompletedEntities()
        ),
        liveActivityCoordinator: PreviewLiveActivityCoordinator(),
        nowProvider: { TodayPreviewData.nowDuringCurrentRoutine }
    )
    .environmentObject(AppLaunchState.previewCompleted())
}

#Preview("All Completed") {
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

#Preview("Past Incomplete Only") {
    TodayView(
        repository: PreviewRoutineRepository(
            entities: TodayPreviewData.pastIncompleteOnlyEntities()
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

#Preview("Current + Past Incomplete") {
    TodayView(
        repository: PreviewRoutineRepository(
            entities: TodayPreviewData.currentAndPastIncompleteEntities()
        ),
        liveActivityCoordinator: PreviewLiveActivityCoordinator(),
        nowProvider: { TodayPreviewData.nowDuringCurrentRoutine }
    )
    .environmentObject(AppLaunchState.previewCompleted())
}

/// Interactive: tap "완료했어요" on the past incomplete card to verify it
/// promotes to the next routine (past incomplete → next), with no backlog
/// card left behind.
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
    static var nowDuringCurrentRoutine: Date {
        MockRoutineData.date(hour: 7, minute: 35)
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

    @MainActor
    static func partiallyCompletedEntities() -> [RoutineEntity] {
        [
            RoutineEntity(
                routine: Routine(
                    title: "아침 스트레칭",
                    startTime: MockRoutineData.date(hour: 6, minute: 30),
                    endTime: MockRoutineData.date(hour: 6, minute: 45),
                    category: .morning,
                    status: .completed
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

    /// No current routine — only a past incomplete routine and a future
    /// next routine. The next routine should appear as quiet secondary
    /// information beneath the past incomplete card.
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

    /// Two past incomplete routines. Only the earliest should appear as the
    /// primary card — there is no backlog list of the remaining one.
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

    /// A current routine together with an earlier past incomplete routine
    /// and no future routine. Current must win priority — the past
    /// incomplete routine stays a fact in the snapshot but is not rendered.
    @MainActor
    static func currentAndPastIncompleteEntities() -> [RoutineEntity] {
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
