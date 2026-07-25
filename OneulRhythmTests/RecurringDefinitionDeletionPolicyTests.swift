//
//  RecurringDefinitionDeletionPolicyTests.swift
//  OneulRhythmTests
//

import XCTest
@testable import OneulRhythm

final class RecurringDefinitionDeletionPolicyTests: XCTestCase {
    private let calendar: Calendar = {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(identifier: "Asia/Seoul")!
        return calendar
    }()

    private lazy var dayPolicy = CalendarDayPolicy(calendar: calendar)
    private lazy var now = makeDate(year: 2026, month: 7, day: 25, hour: 15, minute: 0)
    private lazy var today = dayPolicy.day(for: now)
    private lazy var yesterday = makeDate(year: 2026, month: 7, day: 24, hour: 8, minute: 0)
    private lazy var tomorrow = makeDate(year: 2026, month: 7, day: 26, hour: 8, minute: 0)

    private let definitionID = UUID()
    private let otherDefinitionID = UUID()

    // MARK: - Helpers

    private func makeDate(
        year: Int,
        month: Int,
        day: Int,
        hour: Int,
        minute: Int
    ) -> Date {
        var components = DateComponents()
        components.year = year
        components.month = month
        components.day = day
        components.hour = hour
        components.minute = minute
        return calendar.date(from: components)!
    }

    private func makeOccurrence(
        id: UUID = UUID(),
        startTime: Date,
        status: RoutineStatus,
        recurringRhythmID: UUID? = nil
    ) -> Routine {
        let definition = recurringRhythmID ?? definitionID
        return Routine(
            id: id,
            title: "Exercise",
            startTime: startTime,
            endTime: startTime.addingTimeInterval(30 * 60),
            category: .movement,
            status: status,
            recurringRhythmID: definition,
            occurrenceDate: dayPolicy.day(for: startTime)
        )
    }

    private func idsToDelete(for occurrences: [Routine]) -> Set<UUID> {
        RecurringDefinitionDeletionPolicy.occurrenceIDsToDelete(
            linkedOccurrences: occurrences,
            now: now,
            dayPolicy: dayPolicy
        )
    }

    // MARK: - Preservation

    func testPreservesPastCompletedOccurrence() {
        let pastCompleted = makeOccurrence(
            startTime: yesterday,
            status: .completed
        )

        let deleted = idsToDelete(for: [pastCompleted])

        XCTAssertTrue(deleted.isEmpty)
    }

    func testPreservesPastIncompleteOccurrence() {
        let pastIncomplete = makeOccurrence(
            startTime: yesterday,
            status: .upcoming
        )

        let deleted = idsToDelete(for: [pastIncomplete])

        XCTAssertTrue(deleted.isEmpty)
    }

    func testPreservesTodayCompletedOccurrence() {
        let todayCompleted = makeOccurrence(
            startTime: makeDate(year: 2026, month: 7, day: 25, hour: 7, minute: 0),
            status: .completed
        )

        let deleted = idsToDelete(for: [todayCompleted])

        XCTAssertTrue(deleted.isEmpty)
    }

    // MARK: - Removal

    func testRemovesTodayIncompleteOccurrence() {
        let todayUpcoming = makeOccurrence(
            id: UUID(),
            startTime: makeDate(year: 2026, month: 7, day: 25, hour: 18, minute: 0),
            status: .upcoming
        )
        let todayCurrent = makeOccurrence(
            id: UUID(),
            startTime: makeDate(year: 2026, month: 7, day: 25, hour: 14, minute: 0),
            status: .current
        )

        let deleted = idsToDelete(for: [todayUpcoming, todayCurrent])

        XCTAssertEqual(deleted, [todayUpcoming.id, todayCurrent.id])
    }

    func testRemovesFutureOccurrence() {
        let future = makeOccurrence(
            startTime: tomorrow,
            status: .upcoming
        )

        let deleted = idsToDelete(for: [future])

        XCTAssertEqual(deleted, [future.id])
    }

    // MARK: - Matrix together

    func testDeletionMatrixAcrossMixedLinkedOccurrences() {
        let pastCompleted = makeOccurrence(
            id: UUID(),
            startTime: yesterday,
            status: .completed
        )
        let pastIncomplete = makeOccurrence(
            id: UUID(),
            startTime: makeDate(year: 2026, month: 7, day: 23, hour: 9, minute: 0),
            status: .upcoming
        )
        let todayCompleted = makeOccurrence(
            id: UUID(),
            startTime: makeDate(year: 2026, month: 7, day: 25, hour: 7, minute: 0),
            status: .completed
        )
        let todayIncomplete = makeOccurrence(
            id: UUID(),
            startTime: makeDate(year: 2026, month: 7, day: 25, hour: 19, minute: 0),
            status: .upcoming
        )
        let future = makeOccurrence(
            id: UUID(),
            startTime: tomorrow,
            status: .upcoming
        )

        let deleted = idsToDelete(for: [
            pastCompleted,
            pastIncomplete,
            todayCompleted,
            todayIncomplete,
            future
        ])

        XCTAssertEqual(deleted, [todayIncomplete.id, future.id])
        XCTAssertFalse(deleted.contains(pastCompleted.id))
        XCTAssertFalse(deleted.contains(pastIncomplete.id))
        XCTAssertFalse(deleted.contains(todayCompleted.id))
    }

    func testUsesNormalizedOccurrenceDateNotRawTimestamp() {
        // Late evening timestamp still belongs to today via occurrenceDate/day policy.
        let lateTodayIncomplete = makeOccurrence(
            id: UUID(),
            startTime: makeDate(year: 2026, month: 7, day: 25, hour: 23, minute: 50),
            status: .current
        )

        let deleted = idsToDelete(for: [lateTodayIncomplete])

        XCTAssertEqual(deleted, [lateTodayIncomplete.id])
        XCTAssertEqual(dayPolicy.day(for: lateTodayIncomplete.startTime), today)
    }

    func testUnrelatedDefinitionOccurrencesAreNotEvaluatedWhenNotPassed() {
        // Caller is responsible for passing only linked rows; policy does not
        // filter by definition id. Verify unrelated rows are untouched when omitted.
        let linkedFuture = makeOccurrence(
            id: UUID(),
            startTime: tomorrow,
            status: .upcoming,
            recurringRhythmID: definitionID
        )
        let unrelatedPast = makeOccurrence(
            id: UUID(),
            startTime: yesterday,
            status: .completed,
            recurringRhythmID: otherDefinitionID
        )

        let deleted = idsToDelete(for: [linkedFuture])

        XCTAssertEqual(deleted, [linkedFuture.id])
        XCTAssertFalse(deleted.contains(unrelatedPast.id))
    }
}
