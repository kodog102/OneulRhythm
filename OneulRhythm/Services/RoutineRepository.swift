//
//  RoutineRepository.swift
//  OneulRhythm
//

import Foundation

enum RoutineRepositoryError: Error {
    case routineNotFound
}

@MainActor
protocol RoutineRepository {
    func fetchRoutines() throws -> [RoutineEntity]
    func insert(_ input: RoutineCreationInput) throws
    func insert(_ routine: RoutineEntity) throws
    func updateStatus(id: UUID, status: RoutineStatus) throws
    func delete(_ routine: RoutineEntity) throws

    /// Returns whether a materialized recurring occurrence already exists for
    /// the given definition id and normalized local calendar day.
    ///
    /// Both fields must match. A completed occurrence still counts as existing.
    /// Date normalization is the caller's responsibility.
    func hasOccurrence(
        recurringRhythmID: UUID,
        occurrenceDate: Date
    ) throws -> Bool
}
