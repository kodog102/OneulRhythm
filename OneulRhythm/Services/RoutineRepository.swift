//
//  RoutineRepository.swift
//  OneulRhythm
//

@MainActor
protocol RoutineRepository {
    func fetchRoutines() throws -> [RoutineEntity]
    func insert(_ input: RoutineCreationInput) throws
    func insert(_ routine: RoutineEntity) throws
    func delete(_ routine: RoutineEntity) throws
}
