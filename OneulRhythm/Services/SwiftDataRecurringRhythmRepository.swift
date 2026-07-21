//
//  SwiftDataRecurringRhythmRepository.swift
//  OneulRhythm
//

import Foundation
import SwiftData

@MainActor
final class SwiftDataRecurringRhythmRepository: RecurringRhythmRepository {
    private let modelContext: ModelContext

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    func insert(_ definition: RecurringRhythmEntity) throws {
        modelContext.insert(definition)
        try modelContext.save()
    }

    func fetchActive() throws -> [RecurringRhythmEntity] {
        let descriptor = FetchDescriptor<RecurringRhythmEntity>(
            predicate: #Predicate { $0.isActive == true }
        )

        return try modelContext.fetch(descriptor)
    }

    func deactivate(id: UUID) throws {
        let descriptor = FetchDescriptor<RecurringRhythmEntity>(
            predicate: #Predicate { $0.id == id }
        )

        guard let definition = try modelContext.fetch(descriptor).first else {
            throw RecurringRhythmRepositoryError.recurringRhythmNotFound
        }

        definition.isActive = false
        try modelContext.save()
    }
}
