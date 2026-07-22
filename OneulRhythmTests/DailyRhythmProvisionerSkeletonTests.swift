//
//  DailyRhythmProvisionerSkeletonTests.swift
//  OneulRhythmTests
//

import XCTest
@testable import OneulRhythm

@MainActor
final class DailyRhythmProvisionerSkeletonTests: XCTestCase {
    func testProvisionerCanBeInitializedWithDependencies() {
        let dayPolicy = CalendarDayPolicy(
            calendar: {
                var calendar = Calendar(identifier: .gregorian)
                calendar.timeZone = TimeZone(identifier: "Asia/Seoul")!
                return calendar
            }()
        )

        let provisioner = DailyRhythmProvisioner(
            recurringRhythmRepository: SkeletonRecurringRhythmRepository(),
            routineRepository: SkeletonRoutineRepository(),
            recurrenceEngine: RecurrenceEngine(dayPolicy: dayPolicy),
            dateTimeMaterializer: OccurrenceDateTimeMaterializer(dayPolicy: dayPolicy)
        )

        XCTAssertNotNil(provisioner)
    }

    func testProvisionAPIExists() {
        let dayPolicy = CalendarDayPolicy(
            calendar: {
                var calendar = Calendar(identifier: .gregorian)
                calendar.timeZone = TimeZone(identifier: "Asia/Seoul")!
                return calendar
            }()
        )

        let provisioner = DailyRhythmProvisioner(
            recurringRhythmRepository: SkeletonRecurringRhythmRepository(),
            routineRepository: SkeletonRoutineRepository(),
            recurrenceEngine: RecurrenceEngine(dayPolicy: dayPolicy),
            dateTimeMaterializer: OccurrenceDateTimeMaterializer(dayPolicy: dayPolicy)
        )

        // Confirms the entry API is present and callable at compile time.
        // Behavior remains unimplemented in Task 8B-1.
        let api: (Date) throws -> Void = provisioner.provision(for:)
        _ = api
        XCTAssertTrue(true)
    }
}

// MARK: - Minimal test doubles

@MainActor
private final class SkeletonRecurringRhythmRepository: RecurringRhythmRepository {
    func insert(_ definition: RecurringRhythmEntity) throws {}
    func fetchActive() throws -> [RecurringRhythmEntity] { [] }
    func deactivate(id: UUID) throws {}
}

@MainActor
private final class SkeletonRoutineRepository: RoutineRepository {
    func fetchRoutines() throws -> [RoutineEntity] { [] }
    func insert(_ input: RoutineCreationInput) throws {}
    func insert(_ routine: RoutineEntity) throws {}
    func updateStatus(id: UUID, status: RoutineStatus) throws {}
    func delete(_ routine: RoutineEntity) throws {}
    func hasOccurrence(recurringRhythmID: UUID, occurrenceDate: Date) throws -> Bool { false }
}
