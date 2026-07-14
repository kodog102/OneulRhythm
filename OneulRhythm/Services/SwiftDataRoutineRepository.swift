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

    func insert(_ input: RoutineCreationInput) throws {
        let now = Date()
        let routine = RoutineEntity(
            id: UUID(),
            title: input.title,
            startTime: input.startTime,
            endTime: input.endTime,
            category: input.category,
            status: .upcoming,
            reminderMinutes: input.reminderMinutes,
            createdAt: now,
            updatedAt: now
        )

        try insert(routine)
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
