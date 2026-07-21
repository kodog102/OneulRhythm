//
//  RecurrenceEngineTests.swift
//  OneulRhythmTests
//

import XCTest
@testable import OneulRhythm

final class RecurrenceEngineTests: XCTestCase {
    // MARK: - Helpers

    private func makeCalendar(timeZoneIdentifier: String) -> Calendar {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(identifier: timeZoneIdentifier)!
        return calendar
    }

    private func makeDate(
        _ calendar: Calendar,
        year: Int,
        month: Int,
        day: Int,
        hour: Int = 0,
        minute: Int = 0
    ) -> Date {
        var components = DateComponents()
        components.year = year
        components.month = month
        components.day = day
        components.hour = hour
        components.minute = minute
        return calendar.date(from: components)!
    }

    private func makeEngine(timeZoneIdentifier: String = "Asia/Seoul") -> (RecurrenceEngine, Calendar, CalendarDayPolicy) {
        let calendar = makeCalendar(timeZoneIdentifier: timeZoneIdentifier)
        let dayPolicy = CalendarDayPolicy(calendar: calendar)
        return (RecurrenceEngine(dayPolicy: dayPolicy), calendar, dayPolicy)
    }

    private func makeDefinition(
        id: UUID = UUID(),
        title: String = "아침 스트레칭",
        category: RoutineCategory = .morning,
        startMinutes: Int = 7 * 60,
        durationMinutes: Int = 30,
        recurrence: RecurrenceRule,
        startDate: Date,
        reminderMinutes: Int? = 10,
        isActive: Bool = true
    ) -> RecurringRhythmEntity {
        RecurringRhythmEntity(
            id: id,
            title: title,
            category: category,
            startMinutes: startMinutes,
            durationMinutes: durationMinutes,
            recurrence: recurrence,
            startDate: startDate,
            reminderMinutes: reminderMinutes,
            isActive: isActive
        )
    }

    // MARK: - Daily

    func testActiveDailyProducesOccurrenceOnStartDay() {
        let (engine, calendar, dayPolicy) = makeEngine()
        let startDate = makeDate(calendar, year: 2026, month: 7, day: 15, hour: 9)
        let definition = makeDefinition(recurrence: .daily, startDate: startDate)

        let planned = engine.planOccurrence(for: definition, on: startDate)

        XCTAssertEqual(planned?.occurrenceDate, dayPolicy.day(for: startDate))
        XCTAssertEqual(planned?.recurringRhythmID, definition.id)
    }

    func testActiveDailyProducesOccurrenceAfterStartDay() {
        let (engine, calendar, _) = makeEngine()
        let startDate = makeDate(calendar, year: 2026, month: 7, day: 15, hour: 9)
        let laterDate = makeDate(calendar, year: 2026, month: 7, day: 20, hour: 12)
        let definition = makeDefinition(recurrence: .daily, startDate: startDate)

        XCTAssertNotNil(engine.planOccurrence(for: definition, on: laterDate))
    }

    func testProducesNilBeforeStartDay() {
        let (engine, calendar, _) = makeEngine()
        let startDate = makeDate(calendar, year: 2026, month: 7, day: 15, hour: 9)
        let earlierDate = makeDate(calendar, year: 2026, month: 7, day: 14, hour: 9)
        let definition = makeDefinition(recurrence: .daily, startDate: startDate)

        XCTAssertNil(engine.planOccurrence(for: definition, on: earlierDate))
    }

    func testInactiveDefinitionProducesNil() {
        let (engine, calendar, _) = makeEngine()
        let startDate = makeDate(calendar, year: 2026, month: 7, day: 15, hour: 9)
        let definition = makeDefinition(
            recurrence: .daily,
            startDate: startDate,
            isActive: false
        )

        XCTAssertNil(engine.planOccurrence(for: definition, on: startDate))
    }

    // MARK: - Weekdays / Weekends

    func testWeekdaysProducesOccurrenceOnWeekday() {
        let (engine, calendar, _) = makeEngine()
        // 2026-07-13 Monday, 2026-07-15 Wednesday
        let startDate = makeDate(calendar, year: 2026, month: 7, day: 13, hour: 9)
        let wednesday = makeDate(calendar, year: 2026, month: 7, day: 15, hour: 9)
        let definition = makeDefinition(recurrence: .weekdays, startDate: startDate)

        XCTAssertNotNil(engine.planOccurrence(for: definition, on: wednesday))
    }

    func testWeekdaysProducesNilOnWeekend() {
        let (engine, calendar, _) = makeEngine()
        let startDate = makeDate(calendar, year: 2026, month: 7, day: 13, hour: 9)
        let saturday = makeDate(calendar, year: 2026, month: 7, day: 18, hour: 9)
        let definition = makeDefinition(recurrence: .weekdays, startDate: startDate)

        XCTAssertNil(engine.planOccurrence(for: definition, on: saturday))
    }

    func testWeekendsProducesOccurrenceOnWeekend() {
        let (engine, calendar, _) = makeEngine()
        let startDate = makeDate(calendar, year: 2026, month: 7, day: 13, hour: 9)
        let saturday = makeDate(calendar, year: 2026, month: 7, day: 18, hour: 9)
        let definition = makeDefinition(recurrence: .weekends, startDate: startDate)

        XCTAssertNotNil(engine.planOccurrence(for: definition, on: saturday))
    }

    func testWeekendsProducesNilOnWeekday() {
        let (engine, calendar, _) = makeEngine()
        let startDate = makeDate(calendar, year: 2026, month: 7, day: 13, hour: 9)
        let wednesday = makeDate(calendar, year: 2026, month: 7, day: 15, hour: 9)
        let definition = makeDefinition(recurrence: .weekends, startDate: startDate)

        XCTAssertNil(engine.planOccurrence(for: definition, on: wednesday))
    }

    // MARK: - Normalization and mapping

    func testOccurrenceDateIsNormalizedThroughCalendarDayPolicy() {
        let (engine, calendar, dayPolicy) = makeEngine()
        let startDate = makeDate(calendar, year: 2026, month: 7, day: 15, hour: 0)
        let requested = makeDate(calendar, year: 2026, month: 7, day: 15, hour: 22, minute: 45)
        let definition = makeDefinition(recurrence: .daily, startDate: startDate)

        let planned = engine.planOccurrence(for: definition, on: requested)

        XCTAssertEqual(planned?.occurrenceDate, dayPolicy.day(for: requested))
        XCTAssertNotEqual(planned?.occurrenceDate, requested)
    }

    func testDefinitionFieldsMapCorrectlyIntoPlannedOccurrence() {
        let (engine, calendar, dayPolicy) = makeEngine()
        let id = UUID()
        let startDate = makeDate(calendar, year: 2026, month: 7, day: 15, hour: 8)
        let requested = makeDate(calendar, year: 2026, month: 7, day: 16, hour: 11)
        let definition = makeDefinition(
            id: id,
            title: "집중 시간",
            category: .focus,
            startMinutes: 10 * 60 + 15,
            durationMinutes: 45,
            recurrence: .daily,
            startDate: startDate,
            reminderMinutes: 20
        )

        let planned = engine.planOccurrence(for: definition, on: requested)

        XCTAssertEqual(
            planned,
            PlannedOccurrence(
                recurringRhythmID: id,
                occurrenceDate: dayPolicy.day(for: requested),
                title: "집중 시간",
                category: .focus,
                startMinutes: 615,
                durationMinutes: 45,
                reminderMinutes: 20
            )
        )
    }

    func testReminderMinutesNilIsPreserved() {
        let (engine, calendar, _) = makeEngine()
        let startDate = makeDate(calendar, year: 2026, month: 7, day: 15, hour: 9)
        let definition = makeDefinition(
            recurrence: .daily,
            startDate: startDate,
            reminderMinutes: nil
        )

        let planned = engine.planOccurrence(for: definition, on: startDate)

        XCTAssertNotNil(planned)
        XCTAssertNil(planned?.reminderMinutes)
    }

    func testReminderMinutesNonNilIsPreserved() {
        let (engine, calendar, _) = makeEngine()
        let startDate = makeDate(calendar, year: 2026, month: 7, day: 15, hour: 9)
        let definition = makeDefinition(
            recurrence: .daily,
            startDate: startDate,
            reminderMinutes: 15
        )

        let planned = engine.planOccurrence(for: definition, on: startDate)

        XCTAssertEqual(planned?.reminderMinutes, 15)
    }

    // MARK: - Time zones and DST

    func testExplicitNonUTCTimeZoneBehaviorIsDeterministic() {
        let (engine, calendar, dayPolicy) = makeEngine(timeZoneIdentifier: "America/Los_Angeles")
        // 2026-01-14 Wednesday, 2026-01-17 Saturday
        let startDate = makeDate(calendar, year: 2026, month: 1, day: 14, hour: 8)
        let saturday = makeDate(calendar, year: 2026, month: 1, day: 17, hour: 20, minute: 30)
        let definition = makeDefinition(
            recurrence: .weekends,
            startDate: startDate
        )

        let planned = engine.planOccurrence(for: definition, on: saturday)

        XCTAssertEqual(planned?.occurrenceDate, dayPolicy.day(for: saturday))
        XCTAssertNil(
            engine.planOccurrence(
                for: makeDefinition(recurrence: .weekdays, startDate: startDate),
                on: saturday
            )
        )
    }

    func testDSTTransitionDayProducesCorrectNormalizedOccurrenceDate() {
        let (engine, calendar, dayPolicy) = makeEngine(timeZoneIdentifier: "America/New_York")
        // US spring-forward: 2026-03-08 is a 23-hour local day.
        let startDate = makeDate(calendar, year: 2026, month: 3, day: 1, hour: 9)
        let dstDayAfternoon = makeDate(calendar, year: 2026, month: 3, day: 8, hour: 15, minute: 30)
        let definition = makeDefinition(recurrence: .daily, startDate: startDate)

        let planned = engine.planOccurrence(for: definition, on: dstDayAfternoon)

        XCTAssertEqual(planned?.occurrenceDate, dayPolicy.day(for: dstDayAfternoon))
        XCTAssertEqual(
            planned?.occurrenceDate,
            makeDate(calendar, year: 2026, month: 3, day: 8)
        )
    }

    func testMidnightCrossingDurationValuesArePreservedUnchanged() {
        let (engine, calendar, _) = makeEngine()
        let startDate = makeDate(calendar, year: 2026, month: 7, day: 15, hour: 0)
        let definition = makeDefinition(
            title: "야간 휴식",
            category: .rest,
            startMinutes: 23 * 60,
            durationMinutes: 120,
            recurrence: .daily,
            startDate: startDate
        )

        let planned = engine.planOccurrence(for: definition, on: startDate)

        XCTAssertEqual(planned?.startMinutes, 1380)
        XCTAssertEqual(planned?.durationMinutes, 120)
    }
}
