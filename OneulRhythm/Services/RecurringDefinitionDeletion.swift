//
//  RecurringDefinitionDeletion.swift
//  OneulRhythm
//

import Foundation

/// Applies approved recurring-definition deletion semantics.
///
/// Deactivates the definition and removes only linked occurrences selected by
/// `RecurringDefinitionDeletionPolicy`. Persistence details remain in repositories.
enum RecurringDefinitionDeletion {
    @MainActor
    static func apply(
        definitionID: UUID,
        entities: [RoutineEntity],
        now: Date,
        dayPolicy: CalendarDayPolicy,
        repository: RoutineRepository,
        recurringRepository: RecurringRhythmRepository
    ) throws {
        let related = entities.filter { $0.recurringRhythmID == definitionID }
        let idsToDelete = RecurringDefinitionDeletionPolicy.occurrenceIDsToDelete(
            linkedOccurrences: related.map { $0.toDomain() },
            now: now,
            dayPolicy: dayPolicy
        )

        for entity in related where idsToDelete.contains(entity.id) {
            try repository.delete(entity)
        }

        try recurringRepository.deactivate(id: definitionID)
    }
}
