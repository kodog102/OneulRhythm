//
//  TodayView.swift
//  OneulRhythm
//

import SwiftUI

struct TodayView: View {
    @Environment(\.scenePhase) private var scenePhase
    @StateObject private var viewModel: TodayViewModel
    @State private var isAddRoutinePresented = false

    private let onSaveRoutine: (RoutineCreationInput) throws -> Void

    init(
        repository: RoutineRepository,
        onSaveRoutine: @escaping (RoutineCreationInput) throws -> Void = { _ in },
        nowProvider: @escaping () -> Date = Date.init
    ) {
        _viewModel = StateObject(
            wrappedValue: TodayViewModel(
                repository: repository,
                nowProvider: nowProvider
            )
        )
        self.onSaveRoutine = onSaveRoutine
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
                AddRoutineView { input in
                    try onSaveRoutine(input)
                    viewModel.loadRoutines()
                }
            }
        }
        .onAppear(perform: viewModel.loadRoutines)
        .onChange(of: scenePhase) { _, phase in
            if phase == .active {
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
        Text("오늘 당신의 리듬은\n어떤가요")
            .orTypography(.largeTitle)
            .foregroundStyle(ORColors.textPrimary)
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
        if let currentRoutine = viewModel.currentRoutine {
            RoutineCardView(
                routine: currentRoutine,
                scheduleRole: .current,
                isCompleting: viewModel.isCompleting(currentRoutine),
                onComplete: { viewModel.completeRoutine(currentRoutine) }
            )
        }

        if !viewModel.overdueRoutines.isEmpty {
            overdueSection
        }

        if let nextRoutine = viewModel.nextRoutine {
            RoutineCardView(
                routine: nextRoutine,
                scheduleRole: .next
            )
        }

        TodayProgressView(
            title: "오늘의 흐름",
            description: "오늘의 흐름이 차분하게 이어지고 있어요",
            progress: viewModel.progress
        )
    }

    private var overdueSection: some View {
        VStack(alignment: .leading, spacing: ORSpacing.md) {
            ForEach(Array(viewModel.overdueRoutines.enumerated()), id: \.element.id) { index, routine in
                RoutineCardView(
                    routine: routine,
                    scheduleRole: .overdue,
                    showsSectionLabel: index == 0,
                    isCompleting: viewModel.isCompleting(routine),
                    onComplete: { viewModel.completeRoutine(routine) }
                )
            }
        }
    }
}

#Preview("Current + Overdue + Next") {
    TodayView(
        repository: PreviewRoutineRepository(
            entities: TodayPreviewData.currentOverdueNextEntities()
        ),
        nowProvider: { TodayPreviewData.nowDuringCurrentRoutine }
    )
}

#Preview("Multiple Overdue") {
    TodayView(
        repository: PreviewRoutineRepository(
            entities: TodayPreviewData.multipleOverdueEntities()
        ),
        nowProvider: { TodayPreviewData.nowAfterMorningRoutines }
    )
}

#Preview("Overdue Only") {
    TodayView(
        repository: PreviewRoutineRepository(
            entities: TodayPreviewData.overdueOnlyEntities()
        ),
        nowProvider: { TodayPreviewData.nowAfterMorningRoutines }
    )
}

#Preview("All Completed") {
    TodayView(
        repository: PreviewRoutineRepository(
            entities: TodayPreviewData.completedEntities()
        ),
        nowProvider: { TodayPreviewData.nowDuringCurrentRoutine }
    )
}

#Preview("Empty") {
    TodayView(
        repository: PreviewRoutineRepository(),
        nowProvider: { TodayPreviewData.nowDuringCurrentRoutine }
    )
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
}

private enum TodayPreviewData {
    static var nowDuringCurrentRoutine: Date {
        MockRoutineData.date(hour: 7, minute: 35)
    }

    static var nowAfterMorningRoutines: Date {
        MockRoutineData.date(hour: 9, minute: 30)
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
    static func multipleOverdueEntities() -> [RoutineEntity] {
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
                routine: Routine(
                    title: "물 한 잔 마시기",
                    startTime: MockRoutineData.date(hour: 8, minute: 0),
                    endTime: MockRoutineData.date(hour: 8, minute: 10),
                    category: .morning,
                    status: .upcoming
                )
            )
        ]
    }

    @MainActor
    static func overdueOnlyEntities() -> [RoutineEntity] {
        [
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
