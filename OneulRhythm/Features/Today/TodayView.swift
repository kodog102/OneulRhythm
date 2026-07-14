//
//  TodayView.swift
//  OneulRhythm
//

import SwiftUI

struct TodayView: View {
    @StateObject private var viewModel: TodayViewModel
    @State private var isAddRoutinePresented = false

    private let onSaveRoutine: (RoutineCreationInput) throws -> Void

    init(
        repository: RoutineRepository,
        onSaveRoutine: @escaping (RoutineCreationInput) throws -> Void = { _ in }
    ) {
        _viewModel = StateObject(
            wrappedValue: TodayViewModel(repository: repository)
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
            RoutineCardView(routine: currentRoutine)
        }

        if let nextRoutine = viewModel.nextRoutine {
            RoutineCardView(routine: nextRoutine)
        }

        TodayProgressView(
            title: "오늘의 흐름",
            description: "오늘의 흐름이 차분하게 이어지고 있어요",
            progress: viewModel.progress
        )
    }
}

#Preview("Content") {
    TodayView(
        repository: PreviewRoutineRepository(
            entities: TodayPreviewData.routineEntities()
        )
    )
}

#Preview("Empty") {
    TodayView(
        repository: PreviewRoutineRepository()
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

    func delete(_ routine: RoutineEntity) throws {
        entities.removeAll { $0.id == routine.id }
    }
}

private enum TodayPreviewData {
    @MainActor
    static func routineEntities() -> [RoutineEntity] {
        let calendar = Calendar.current
        let today = Date()
        let currentStart = calendar.date(
            bySettingHour: 7,
            minute: 30,
            second: 0,
            of: today
        ) ?? today
        let nextStart = calendar.date(
            bySettingHour: 8,
            minute: 0,
            second: 0,
            of: today
        ) ?? today

        return [
            RoutineEntity(
                routine: MockRoutineData.currentRoutine,
                startTime: currentStart,
                endTime: currentStart.addingTimeInterval(15 * 60)
            ),
            RoutineEntity(
                routine: MockRoutineData.nextRoutine,
                startTime: nextStart,
                endTime: nil
            )
        ]
    }
}
