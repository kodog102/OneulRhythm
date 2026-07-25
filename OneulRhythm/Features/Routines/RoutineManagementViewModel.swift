//
//  RoutineManagementViewModel.swift
//  OneulRhythm
//

import Combine
import Foundation

@MainActor
final class RoutineManagementViewModel: ObservableObject {
    @Published private(set) var items: [ManagementRhythmItem] = []
    @Published private(set) var isLoading = false
    @Published var loadErrorMessage: String?
    @Published var mutationErrorMessage: String?

    private let repository: RoutineRepository
    private let recurringRhythmRepository: RecurringRhythmRepository
    private let dayPolicy: CalendarDayPolicy
    private let nowProvider: () -> Date
    private let onDeleteRoutine: (UUID) throws -> Void

    init(
        repository: RoutineRepository,
        recurringRhythmRepository: RecurringRhythmRepository,
        dayPolicy: CalendarDayPolicy = CalendarDayPolicy(),
        nowProvider: @escaping () -> Date = Date.init,
        onDeleteRoutine: @escaping (UUID) throws -> Void
    ) {
        self.repository = repository
        self.recurringRhythmRepository = recurringRhythmRepository
        self.dayPolicy = dayPolicy
        self.nowProvider = nowProvider
        self.onDeleteRoutine = onDeleteRoutine
    }

    func loadItems() {
        isLoading = true
        loadErrorMessage = nil
        defer { isLoading = false }

        do {
            let recurring = try recurringRhythmRepository
                .fetchActive()
                .map(RecurringManagementRhythm.init)
            let routines = try repository.fetchRoutines().map { $0.toDomain() }
            items = ManagementRhythmComposer.compose(
                recurring: recurring,
                routines: routines,
                now: nowProvider(),
                dayPolicy: dayPolicy
            )
        } catch {
            loadErrorMessage = "리듬을 불러오지 못했어요.\n잠시 후 다시 시도해주세요."
        }
    }

    func deleteItem(_ item: ManagementRhythmItem) {
        mutationErrorMessage = nil

        do {
            try onDeleteRoutine(item.id)
            loadItems()
        } catch {
            mutationErrorMessage = "리듬을 삭제하지 못했어요.\n잠시 후 다시 시도해주세요."
        }
    }
}
