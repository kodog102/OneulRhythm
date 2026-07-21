//
//  RecurringRhythmRepository.swift
//  OneulRhythm
//

import Foundation

enum RecurringRhythmRepositoryError: Error {
    case recurringRhythmNotFound
}

/// Persistence boundary for recurring rhythm definitions.
///
/// Responsible only for storing, reading active definitions, and soft
/// deactivation. Recurrence applicability, occurrence generation, date
/// projection, and scheduling remain outside this repository.
@MainActor
protocol RecurringRhythmRepository {
    func insert(_ definition: RecurringRhythmEntity) throws
    func fetchActive() throws -> [RecurringRhythmEntity]
    func deactivate(id: UUID) throws
}
