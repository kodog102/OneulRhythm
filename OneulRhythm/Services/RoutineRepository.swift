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
}
