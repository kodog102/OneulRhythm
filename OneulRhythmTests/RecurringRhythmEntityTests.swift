//
//  RecurringRhythmEntityTests.swift
//  OneulRhythmTests
//

import XCTest
@testable import OneulRhythm

final class RecurringRhythmEntityTests: XCTestCase {
    // MARK: - Helpers

    private func makeStartDate() -> Date {
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

    func testEntityInitializesWithAllRequiredValues() {
        let id = UUID()
        let startDate = makeStartDate()

        let entity = RecurringRhythmEntity(
            id: id,
            title: "아침 스트레칭",
            category: .morning,
            startMinutes: 7 * 60,
            durationMinutes: 30,
            recurrence: .daily,
            startDate: startDate,
            reminderMinutes: 10,
            isActive: false
        )

        XCTAssertEqual(entity.id, id)
        XCTAssertEqual(entity.title, "아침 스트레칭")
        XCTAssertEqual(entity.categoryRawValue, RoutineCategory.morning.rawValue)
        XCTAssertEqual(entity.startMinutes, 7 * 60)
        XCTAssertEqual(entity.durationMinutes, 30)
        XCTAssertEqual(entity.recurrenceRawValue, RecurrenceRule.daily.rawValue)
        XCTAssertEqual(entity.startDate, startDate)
        XCTAssertEqual(entity.reminderMinutes, 10)
        XCTAssertFalse(entity.isActive)
    }

    func testDefaultIDIsGeneratedWhenNotSupplied() {
        let entity = RecurringRhythmEntity(
            title: "집중 시간",
            category: .focus,
            startMinutes: 10 * 60,
            durationMinutes: 60,
            recurrence: .weekdays,
            startDate: makeStartDate()
        )

        XCTAssertFalse(entity.id.uuidString.isEmpty)
    }

    func testIsActiveDefaultsToTrue() {
        let entity = RecurringRhythmEntity(
            title: "저녁 산책",
            category: .evening,
            startMinutes: 20 * 60,
            durationMinutes: 40,
            recurrence: .weekends,
            startDate: makeStartDate()
        )

        XCTAssertTrue(entity.isActive)
    }

    // MARK: - Recurrence mapping

    func testEachSupportedRecurrenceRuleSurvivesPersistenceMapping() {
        for rule in RecurrenceRule.allCases {
            let entity = RecurringRhythmEntity(
                title: "리듬",
                category: .rest,
                startMinutes: 12 * 60,
                durationMinutes: 15,
                recurrence: rule,
                startDate: makeStartDate()
            )

            XCTAssertEqual(entity.recurrenceRawValue, rule.rawValue)
            XCTAssertEqual(entity.recurrence, rule)
        }
    }

    // MARK: - Time representation

    func testStartAndDurationMinutesAreStoredWithoutDerivingOrTruncating() {
        let entity = RecurringRhythmEntity(
            title: "운동",
            category: .movement,
            startMinutes: 9 * 60 + 15,
            durationMinutes: 45,
            recurrence: .daily,
            startDate: makeStartDate()
        )

        XCTAssertEqual(entity.startMinutes, 555)
        XCTAssertEqual(entity.durationMinutes, 45)
    }

    func testMidnightCrossingDurationIsRepresentable() {
        let entity = RecurringRhythmEntity(
            title: "야간 휴식",
            category: .rest,
            startMinutes: 23 * 60,
            durationMinutes: 120,
            recurrence: .daily,
            startDate: makeStartDate()
        )

        XCTAssertEqual(entity.startMinutes, 1380)
        XCTAssertEqual(entity.durationMinutes, 120)
    }
}
