//
//  TodayViewModel.swift
//  OneulRhythm
//

import Combine
import Foundation

@MainActor
final class TodayViewModel: ObservableObject {
    @Published private(set) var routines: [Routine] = []
    @Published private(set) var isLoading = false
    @Published private(set) var loadErrorMessage: String?

    private let repository: RoutineRepository

    init(repository: RoutineRepository) {
        self.repository = repository
    }

    var currentRoutine: Routine? {
        routines.first { $0.status == .current }
    }

    var nextRoutine: Routine? {
        routines.first { $0.status == .upcoming }
    }

    var completedRoutineCount: Int {
        routines.filter(\.isCompleted).count
    }

    var progress: Double {
        guard !routines.isEmpty else { return 0 }
        return Double(completedRoutineCount) / Double(routines.count)
    }

    func loadRoutines() {
        isLoading = true
        loadErrorMessage = nil
        defer { isLoading = false }

        do {
            routines = try repository.fetchRoutines().map { $0.toDomain() }
        } catch {
            loadErrorMessage = "리듬을 불러오지 못했어요.\n잠시 후 다시 시도해주세요."
        }
    }
}
