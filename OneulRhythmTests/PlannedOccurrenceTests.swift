//
//  PlannedOccurrenceTests.swift
//  OneulRhythmTests
//

import XCTest
@testable import OneulRhythm

final class PlannedOccurrenceTests: XCTestCase {
    // MARK: - Helpers

    private func makeOccurrenceDate() -> Date {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(identifier: "Asia/Seoul")!

        var components = DateComponents()
        components.year = 2026
        components.month = 7
        components.day = 15
        components.hour = 0
        return calendar.date(from: components)!
    }

    // MARK: - Initialization

    func testInitializerStoresAllValues() {
        let recurringID = UUID()
        let occurrenceDate = makeOccurrenceDate()

        let occurrence = PlannedOccurrence(
            recurringRhythmID: recurringID,
            occurrenceDate: occurrenceDate,
            title: "아침 스트레칭",
            category: .morning,
            startMinutes: 7 * 60,
            durationMinutes: 30,
            reminderMinutes: 10
        )

        XCTAssertEqual(occurrence.recurringRhythmID, recurringID)
        XCTAssertEqual(occurrence.occurrenceDate, occurrenceDate)
        XCTAssertEqual(occurrence.title, "아침 스트레칭")
        XCTAssertEqual(occurrence.category, .morning)
        XCTAssertEqual(occurrence.startMinutes, 7 * 60)
        XCTAssertEqual(occurrence.durationMinutes, 30)
        XCTAssertEqual(occurrence.reminderMinutes, 10)
    }

    func testReminderMinutesSupportsNil() {
        let occurrence = PlannedOccurrence(
            recurringRhythmID: UUID(),
            occurrenceDate: makeOccurrenceDate(),
            title: "집중 시간",
            category: .focus,
            startMinutes: 10 * 60,
            durationMinutes: 60,
            reminderMinutes: nil
        )

        XCTAssertNil(occurrence.reminderMinutes)
    }

    func testReminderMinutesSupportsNonNilValues() {
        let occurrence = PlannedOccurrence(
            recurringRhythmID: UUID(),
            occurrenceDate: makeOccurrenceDate(),
            title: "저녁 산책",
            category: .evening,
            startMinutes: 20 * 60,
            durationMinutes: 40,
            reminderMinutes: 15
        )

        XCTAssertEqual(occurrence.reminderMinutes, 15)
    }

    // MARK: - Equatable

    func testEqualPlannedOccurrencesCompareEqual() {
        let recurringID = UUID()
        let occurrenceDate = makeOccurrenceDate()

        let lhs = PlannedOccurrence(
            recurringRhythmID: recurringID,
            occurrenceDate: occurrenceDate,
            title: "운동",
            category: .movement,
            startMinutes: 9 * 60,
            durationMinutes: 45,
            reminderMinutes: 5
        )
        let rhs = PlannedOccurrence(
            recurringRhythmID: recurringID,
            occurrenceDate: occurrenceDate,
            title: "운동",
            category: .movement,
            startMinutes: 9 * 60,
            durationMinutes: 45,
            reminderMinutes: 5
        )

        XCTAssertEqual(lhs, rhs)
    }

    func testDifferentPlannedOccurrencesCompareUnequal() {
        let occurrenceDate = makeOccurrenceDate()

        let lhs = PlannedOccurrence(
            recurringRhythmID: UUID(),
            occurrenceDate: occurrenceDate,
            title: "휴식",
            category: .rest,
            startMinutes: 14 * 60,
            durationMinutes: 20,
            reminderMinutes: nil
        )
        let rhs = PlannedOccurrence(
            recurringRhythmID: UUID(),
            occurrenceDate: occurrenceDate,
            title: "휴식",
            category: .rest,
            startMinutes: 14 * 60,
            durationMinutes: 20,
            reminderMinutes: nil
        )

        XCTAssertNotEqual(lhs, rhs)
    }
}
