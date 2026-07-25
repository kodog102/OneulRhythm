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

    func testProvisionAPIExists() throws {
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

        // Empty active set — orchestration runs without inserting.
        try provisioner.provision(for: Date(timeIntervalSince1970: 0))
    }
}

// MARK: - Minimal test doubles

@MainActor
private final class SkeletonRecurringRhythmRepository: RecurringRhythmRepository {
    func insert(_ definition: RecurringRhythmEntity) throws {}
    func fetchActive() throws -> [RecurringRhythmEntity] { [] }
    func update(
        id: UUID,
        title: String,
        category: RoutineCategory,
        startMinutes: Int,
        durationMinutes: Int,
        recurrence: RecurrenceRule,
        reminderMinutes: Int?
    ) throws {}
    func deactivate(id: UUID) throws {}
}

@MainActor
private final class SkeletonRoutineRepository: RoutineRepository {
    func fetchRoutines() throws -> [RoutineEntity] { [] }
    func insert(_ input: RoutineCreationInput) throws {}
    func insert(_ routine: RoutineEntity) throws {}
    func update(_ input: RoutineCreationInput) throws {}
    func clearRecurrenceMetadata(id: UUID) throws {}
    func updateStatus(id: UUID, status: RoutineStatus) throws {}
    func delete(_ routine: RoutineEntity) throws {}
    func delete(id: UUID) throws {}
    func hasOccurrence(recurringRhythmID: UUID, occurrenceDate: Date) throws -> Bool { false }
}
