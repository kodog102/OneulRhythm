//
//  SwiftDataRoutineRepository.swift
//  OneulRhythm
//

import Foundation
import SwiftData

@MainActor
final class SwiftDataRoutineRepository: RoutineRepository {
    private let modelContext: ModelContext

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    func fetchRoutines() throws -> [RoutineEntity] {
        let descriptor = FetchDescriptor<RoutineEntity>(
            sortBy: [
                SortDescriptor(\RoutineEntity.startTime),
                SortDescriptor(\RoutineEntity.createdAt)
            ]
        )

        return try modelContext.fetch(descriptor)
    }

    func insert(_ routine: RoutineEntity) throws {
        modelContext.insert(routine)
        try modelContext.save()
    }

    func delete(_ routine: RoutineEntity) throws {
        modelContext.delete(routine)
        try modelContext.save()
    }
}
