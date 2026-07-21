//
//  CalendarDayPolicyTests.swift
//  OneulRhythmTests
//

import XCTest
@testable import OneulRhythm

final class CalendarDayPolicyTests: XCTestCase {
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
        minute: Int = 0,
        second: Int = 0
    ) -> Date {
        var components = DateComponents()
        components.year = year
        components.month = month
        components.day = day
        components.hour = hour
        components.minute = minute
        components.second = second
        return calendar.date(from: components)!
    }

    // MARK: - day(for:)

    func testDayForReturnsLocalStartOfDay() {
        let calendar = makeCalendar(timeZoneIdentifier: "Asia/Seoul")
        let policy = CalendarDayPolicy(calendar: calendar)

        let date = makeDate(calendar, year: 2026, month: 7, day: 15, hour: 15, minute: 30)
        let expectedStartOfDay = makeDate(calendar, year: 2026, month: 7, day: 15)

        XCTAssertEqual(policy.day(for: date), expectedStartOfDay)
    }

    // MARK: - isSameDay(_:_:)

    func testDatesOnSameLocalDayAreRecognizedAsSameDay() {
        let calendar = makeCalendar(timeZoneIdentifier: "Asia/Seoul")
        let policy = CalendarDayPolicy(calendar: calendar)

        let morning = makeDate(calendar, year: 2026, month: 7, day: 15, hour: 0, minute: 5)
        let night = makeDate(calendar, year: 2026, month: 7, day: 15, hour: 23, minute: 55)

        XCTAssertTrue(policy.isSameDay(morning, night))
    }

    func testDatesOnAdjacentLocalDaysAreNotSameDay() {
        let calendar = makeCalendar(timeZoneIdentifier: "Asia/Seoul")
        let policy = CalendarDayPolicy(calendar: calendar)

        let lastMinuteOfDay = makeDate(calendar, year: 2026, month: 7, day: 15, hour: 23, minute: 59)
        let firstMinuteOfNextDay = makeDate(calendar, year: 2026, month: 7, day: 16, hour: 0, minute: 1)

        XCTAssertFalse(policy.isSameDay(lastMinuteOfDay, firstMinuteOfNextDay))
    }

    // MARK: - isWeekend(_:)

    func testWeekdayIsNotClassifiedAsWeekend() {
        let calendar = makeCalendar(timeZoneIdentifier: "Asia/Seoul")
        let policy = CalendarDayPolicy(calendar: calendar)

        // 2026-07-15 is a Wednesday.
        let wednesday = makeDate(calendar, year: 2026, month: 7, day: 15, hour: 12)

        XCTAssertFalse(policy.isWeekend(wednesday))
    }

    func testWeekendDayIsClassifiedAsWeekend() {
        let calendar = makeCalendar(timeZoneIdentifier: "Asia/Seoul")
        let policy = CalendarDayPolicy(calendar: calendar)

        // 2026-07-18 is a Saturday.
        let saturday = makeDate(calendar, year: 2026, month: 7, day: 18, hour: 12)

        XCTAssertTrue(policy.isWeekend(saturday))
    }

    // MARK: - Explicit non-UTC time zone

    func testNormalizationWithExplicitNonUTCTimeZone() {
        // Winter date, before the US switches to daylight saving time, so
        // the offset is a stable, unambiguous UTC-8.
        let calendar = makeCalendar(timeZoneIdentifier: "America/Los_Angeles")
        let policy = CalendarDayPolicy(calendar: calendar)

        let lateEvening = makeDate(calendar, year: 2026, month: 1, day: 15, hour: 23, minute: 45)
        let expectedStartOfDay = makeDate(calendar, year: 2026, month: 1, day: 15)

        XCTAssertEqual(policy.day(for: lateEvening), expectedStartOfDay)
        XCTAssertFalse(
            policy.isSameDay(lateEvening, makeDate(calendar, year: 2026, month: 1, day: 16, hour: 0, minute: 15))
        )
    }

    // MARK: - Daylight saving time transition

    func testDayBoundaryIsCorrectAcrossDaylightSavingTimeTransition() {
        // In the US, DST begins 2026-03-08 at 02:00 local time, so this
        // calendar day is only 23 hours long in America/New_York.
        let calendar = makeCalendar(timeZoneIdentifier: "America/New_York")
        let policy = CalendarDayPolicy(calendar: calendar)

        let beforeMidnight = makeDate(calendar, year: 2026, month: 3, day: 8, hour: 23, minute: 30)
        let afterMidnight = makeDate(calendar, year: 2026, month: 3, day: 9, hour: 0, minute: 30)

        XCTAssertFalse(policy.isSameDay(beforeMidnight, afterMidnight))
        XCTAssertEqual(policy.day(for: beforeMidnight), makeDate(calendar, year: 2026, month: 3, day: 8))
        XCTAssertEqual(policy.day(for: afterMidnight), makeDate(calendar, year: 2026, month: 3, day: 9))
    }
}
