//
//  SwiftDataRoutineOccurrenceLookupTests.swift
//  OneulRhythmTests
//

import XCTest
import SwiftData
@testable import OneulRhythm

@MainActor
final class SwiftDataRoutineOccurrenceLookupTests: XCTestCase {
    // MARK: - Helpers

    private func makeContainer() throws -> ModelContainer {
        let schema = Schema([RoutineEntity.self])
        let configuration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
        return try ModelContainer(for: schema, configurations: [configuration])
    }

    private func makeRepository(container: ModelContainer) -> SwiftDataRoutineRepository {
        SwiftDataRoutineRepository(modelContext: ModelContext(container))
    }

    private func makeOccurrenceDate(dayOffset: Int = 0) -> Date {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(identifier: "Asia/Seoul")!

        var components = DateComponents()
        components.year = 2026
        components.month = 7
        components.day = 15 + dayOffset
        components.hour = 0
        return calendar.date(from: components)!
    }

    private func makeStartTime(dayOffset: Int = 0, hour: Int = 9) -> Date {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(identifier: "Asia/Seoul")!

        var components = DateComponents()
        components.year = 2026
        components.month = 7
        components.day = 15 + dayOffset
        components.hour = hour
        return calendar.date(from: components)!
    }

    private func makeRoutine(
        id: UUID = UUID(),
        title: String = "아침 스트레칭",
        status: RoutineStatus = .upcoming,
        recurringRhythmID: UUID? = nil,
        occurrenceDate: Date? = nil,
        startTime: Date? = nil
    ) -> RoutineEntity {
        RoutineEntity(
            id: id,
            title: title,
            startTime: startTime ?? makeStartTime(),
            category: .morning,
            status: status,
            recurringRhythmID: recurringRhythmID,
            occurrenceDate: occurrenceDate
        )
    }

    // MARK: - Matching

    func testMatchingRecurringRhythmIDAndOccurrenceDateReturnsTrue() throws {
        let container = try makeContainer()
        let repository = makeRepository(container: container)
        let recurringID = UUID()
        let occurrenceDate = makeOccurrenceDate()

        try repository.insert(
            makeRoutine(recurringRhythmID: recurringID, occurrenceDate: occurrenceDate)
        )

        XCTAssertTrue(
            try repository.hasOccurrence(
                recurringRhythmID: recurringID,
                occurrenceDate: occurrenceDate
            )
        )
    }

    func testUnknownRecurringRhythmIDReturnsFalse() throws {
        let container = try makeContainer()
        let repository = makeRepository(container: container)
        let occurrenceDate = makeOccurrenceDate()

        try repository.insert(
            makeRoutine(recurringRhythmID: UUID(), occurrenceDate: occurrenceDate)
        )

        XCTAssertFalse(
            try repository.hasOccurrence(
                recurringRhythmID: UUID(),
                occurrenceDate: occurrenceDate
            )
        )
    }

    func testDifferentOccurrenceDateReturnsFalse() throws {
        let container = try makeContainer()
        let repository = makeRepository(container: container)
        let recurringID = UUID()

        try repository.insert(
            makeRoutine(
                recurringRhythmID: recurringID,
                occurrenceDate: makeOccurrenceDate()
            )
        )

        XCTAssertFalse(
            try repository.hasOccurrence(
                recurringRhythmID: recurringID,
                occurrenceDate: makeOccurrenceDate(dayOffset: 1)
            )
        )
    }

    func testSameOccurrenceDateWithDifferentRecurringRhythmIDReturnsFalse() throws {
        let container = try makeContainer()
        let repository = makeRepository(container: container)
        let occurrenceDate = makeOccurrenceDate()

        try repository.insert(
            makeRoutine(recurringRhythmID: UUID(), occurrenceDate: occurrenceDate)
        )

        XCTAssertFalse(
            try repository.hasOccurrence(
                recurringRhythmID: UUID(),
                occurrenceDate: occurrenceDate
            )
        )
    }

    func testBothFieldsMustMatchTogether() throws {
        let container = try makeContainer()
        let repository = makeRepository(container: container)
        let recurringID = UUID()
        let occurrenceDate = makeOccurrenceDate()

        try repository.insert(
            makeRoutine(recurringRhythmID: recurringID, occurrenceDate: occurrenceDate)
        )

        XCTAssertTrue(
            try repository.hasOccurrence(
                recurringRhythmID: recurringID,
                occurrenceDate: occurrenceDate
            )
        )
        XCTAssertFalse(
            try repository.hasOccurrence(
                recurringRhythmID: recurringID,
                occurrenceDate: makeOccurrenceDate(dayOffset: 2)
            )
        )
        XCTAssertFalse(
            try repository.hasOccurrence(
                recurringRhythmID: UUID(),
                occurrenceDate: occurrenceDate
            )
        )
    }

    // MARK: - Status independence

    func testCompletedMatchingRoutineStillReturnsTrue() throws {
        let container = try makeContainer()
        let repository = makeRepository(container: container)
        let recurringID = UUID()
        let occurrenceDate = makeOccurrenceDate()

        try repository.insert(
            makeRoutine(
                status: .completed,
                recurringRhythmID: recurringID,
                occurrenceDate: occurrenceDate
            )
        )

        XCTAssertTrue(
            try repository.hasOccurrence(
                recurringRhythmID: recurringID,
                occurrenceDate: occurrenceDate
            )
        )
    }

    func testUpcomingMatchingRoutineReturnsTrue() throws {
        let container = try makeContainer()
        let repository = makeRepository(container: container)
        let recurringID = UUID()
        let occurrenceDate = makeOccurrenceDate()

        try repository.insert(
            makeRoutine(
                status: .upcoming,
                recurringRhythmID: recurringID,
                occurrenceDate: occurrenceDate
            )
        )

        XCTAssertTrue(
            try repository.hasOccurrence(
                recurringRhythmID: recurringID,
                occurrenceDate: occurrenceDate
            )
        )
    }

    // MARK: - Optional metadata

    func testOneTimeRoutineWithNilRecurrenceMetadataDoesNotMatch() throws {
        let container = try makeContainer()
        let repository = makeRepository(container: container)
        let recurringID = UUID()
        let occurrenceDate = makeOccurrenceDate()

        try repository.insert(
            makeRoutine(recurringRhythmID: nil, occurrenceDate: nil)
        )

        XCTAssertFalse(
            try repository.hasOccurrence(
                recurringRhythmID: recurringID,
                occurrenceDate: occurrenceDate
            )
        )
    }

    func testMatchingRecurringRhythmIDWithNilOccurrenceDateDoesNotMatch() throws {
        let container = try makeContainer()
        let repository = makeRepository(container: container)
        let recurringID = UUID()
        let occurrenceDate = makeOccurrenceDate()

        try repository.insert(
            makeRoutine(recurringRhythmID: recurringID, occurrenceDate: nil)
        )

        XCTAssertFalse(
            try repository.hasOccurrence(
                recurringRhythmID: recurringID,
                occurrenceDate: occurrenceDate
            )
        )
    }

    func testNilRecurringRhythmIDWithMatchingOccurrenceDateDoesNotMatch() throws {
        let container = try makeContainer()
        let repository = makeRepository(container: container)
        let occurrenceDate = makeOccurrenceDate()

        try repository.insert(
            makeRoutine(recurringRhythmID: nil, occurrenceDate: occurrenceDate)
        )

        XCTAssertFalse(
            try repository.hasOccurrence(
                recurringRhythmID: UUID(),
                occurrenceDate: occurrenceDate
            )
        )
    }

    // MARK: - Cross-record matching

    func testSplitMatchesAcrossRowsReturnFalse() throws {
        let container = try makeContainer()
        let repository = makeRepository(container: container)
        let targetID = UUID()
        let targetDate = makeOccurrenceDate()
        let otherID = UUID()
        let otherDate = makeOccurrenceDate(dayOffset: 1)

        // One row matches the id only; another matches the date only.
        try repository.insert(
            makeRoutine(
                title: "id only",
                recurringRhythmID: targetID,
                occurrenceDate: otherDate
            )
        )
        try repository.insert(
            makeRoutine(
                title: "date only",
                recurringRhythmID: otherID,
                occurrenceDate: targetDate
            )
        )

        XCTAssertFalse(
            try repository.hasOccurrence(
                recurringRhythmID: targetID,
                occurrenceDate: targetDate
            )
        )
    }

    // MARK: - Non-mutation / persistence

    func testLookupDoesNotMutateMatchingRoutine() throws {
        let container = try makeContainer()
        let repository = makeRepository(container: container)
        let routineID = UUID()
        let recurringID = UUID()
        let occurrenceDate = makeOccurrenceDate()
        let startTime = makeStartTime()

        try repository.insert(
            makeRoutine(
                id: routineID,
                title: "집중 시간",
                status: .upcoming,
                recurringRhythmID: recurringID,
                occurrenceDate: occurrenceDate,
                startTime: startTime
            )
        )

        XCTAssertTrue(
            try repository.hasOccurrence(
                recurringRhythmID: recurringID,
                occurrenceDate: occurrenceDate
            )
        )

        let stored = try repository.fetchRoutines().first { $0.id == routineID }
        XCTAssertEqual(stored?.title, "집중 시간")
        XCTAssertEqual(stored?.statusRawValue, RoutineStatus.upcoming.rawValue)
        XCTAssertEqual(stored?.recurringRhythmID, recurringID)
        XCTAssertEqual(stored?.occurrenceDate, occurrenceDate)
        XCTAssertEqual(stored?.startTime, startTime)
    }

    func testLookupPersistsAcrossFreshModelContextFromSameContainer() throws {
        let container = try makeContainer()
        let writer = makeRepository(container: container)
        let recurringID = UUID()
        let occurrenceDate = makeOccurrenceDate()

        try writer.insert(
            makeRoutine(recurringRhythmID: recurringID, occurrenceDate: occurrenceDate)
        )

        let reader = makeRepository(container: container)
        XCTAssertTrue(
            try reader.hasOccurrence(
                recurringRhythmID: recurringID,
                occurrenceDate: occurrenceDate
            )
        )
    }
}
