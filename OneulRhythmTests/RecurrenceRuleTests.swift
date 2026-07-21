//
//  RecurrenceRuleTests.swift
//  OneulRhythmTests
//

import XCTest
@testable import OneulRhythm

final class RecurrenceRuleTests: XCTestCase {
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

    // MARK: - Daily

    func testDailyAppliesOnStartDate() {
        let calendar = makeCalendar(timeZoneIdentifier: "Asia/Seoul")
        let dayPolicy = CalendarDayPolicy(calendar: calendar)
        // 2026-07-15 is a Wednesday.
        let startDate = makeDate(calendar, year: 2026, month: 7, day: 15, hour: 9)

        XCTAssertTrue(RecurrenceRule.daily.occurs(on: startDate, startingAt: startDate, using: dayPolicy))
    }

    func testDailyAppliesAfterStartDate() {
        let calendar = makeCalendar(timeZoneIdentifier: "Asia/Seoul")
        let dayPolicy = CalendarDayPolicy(calendar: calendar)
        let startDate = makeDate(calendar, year: 2026, month: 7, day: 15, hour: 9)
        let laterDate = makeDate(calendar, year: 2026, month: 7, day: 20, hour: 9)

        XCTAssertTrue(RecurrenceRule.daily.occurs(on: laterDate, startingAt: startDate, using: dayPolicy))
    }

    func testDailyDoesNotApplyBeforeStartDate() {
        let calendar = makeCalendar(timeZoneIdentifier: "Asia/Seoul")
        let dayPolicy = CalendarDayPolicy(calendar: calendar)
        let startDate = makeDate(calendar, year: 2026, month: 7, day: 15, hour: 9)
        let earlierDate = makeDate(calendar, year: 2026, month: 7, day: 14, hour: 9)

        XCTAssertFalse(RecurrenceRule.daily.occurs(on: earlierDate, startingAt: startDate, using: dayPolicy))
    }

    // MARK: - Weekdays

    func testWeekdaysAppliesOnWeekday() {
        let calendar = makeCalendar(timeZoneIdentifier: "Asia/Seoul")
        let dayPolicy = CalendarDayPolicy(calendar: calendar)
        // 2026-07-13 is a Monday, 2026-07-15 is a Wednesday.
        let startDate = makeDate(calendar, year: 2026, month: 7, day: 13, hour: 9)
        let wednesday = makeDate(calendar, year: 2026, month: 7, day: 15, hour: 9)

        XCTAssertTrue(RecurrenceRule.weekdays.occurs(on: wednesday, startingAt: startDate, using: dayPolicy))
    }

    func testWeekdaysDoesNotApplyOnWeekend() {
        let calendar = makeCalendar(timeZoneIdentifier: "Asia/Seoul")
        let dayPolicy = CalendarDayPolicy(calendar: calendar)
        let startDate = makeDate(calendar, year: 2026, month: 7, day: 13, hour: 9)
        // 2026-07-18 is a Saturday.
        let saturday = makeDate(calendar, year: 2026, month: 7, day: 18, hour: 9)

        XCTAssertFalse(RecurrenceRule.weekdays.occurs(on: saturday, startingAt: startDate, using: dayPolicy))
    }

    // MARK: - Weekends

    func testWeekendsAppliesOnWeekend() {
        let calendar = makeCalendar(timeZoneIdentifier: "Asia/Seoul")
        let dayPolicy = CalendarDayPolicy(calendar: calendar)
        let startDate = makeDate(calendar, year: 2026, month: 7, day: 13, hour: 9)
        let saturday = makeDate(calendar, year: 2026, month: 7, day: 18, hour: 9)

        XCTAssertTrue(RecurrenceRule.weekends.occurs(on: saturday, startingAt: startDate, using: dayPolicy))
    }

    func testWeekendsDoesNotApplyOnWeekday() {
        let calendar = makeCalendar(timeZoneIdentifier: "Asia/Seoul")
        let dayPolicy = CalendarDayPolicy(calendar: calendar)
        let startDate = makeDate(calendar, year: 2026, month: 7, day: 13, hour: 9)
        let wednesday = makeDate(calendar, year: 2026, month: 7, day: 15, hour: 9)

        XCTAssertFalse(RecurrenceRule.weekends.occurs(on: wednesday, startingAt: startDate, using: dayPolicy))
    }

    // MARK: - Normalized day comparison

    func testStartDateComparisonUsesNormalizedCalendarDayNotRawTimestamp() {
        let calendar = makeCalendar(timeZoneIdentifier: "Asia/Seoul")
        let dayPolicy = CalendarDayPolicy(calendar: calendar)
        // The requested timestamp is earlier in the day than the start
        // timestamp, so a raw timestamp comparison would incorrectly treat
        // the requested date as "before" the start date. Normalizing
        // through CalendarDayPolicy shows they fall on the same day.
        let startDate = makeDate(calendar, year: 2026, month: 7, day: 15, hour: 23, minute: 59)
        let requestedDate = makeDate(calendar, year: 2026, month: 7, day: 15, hour: 0, minute: 1)

        XCTAssertTrue(RecurrenceRule.daily.occurs(on: requestedDate, startingAt: startDate, using: dayPolicy))
    }

    // MARK: - Explicit non-UTC time zone

    func testAppliesCorrectlyWithExplicitNonUTCTimeZone() {
        let calendar = makeCalendar(timeZoneIdentifier: "America/Los_Angeles")
        let dayPolicy = CalendarDayPolicy(calendar: calendar)
        // 2026-01-14 is a Wednesday; 2026-01-17 is a Saturday.
        let startDate = makeDate(calendar, year: 2026, month: 1, day: 14, hour: 8)
        let saturday = makeDate(calendar, year: 2026, month: 1, day: 17, hour: 8)

        XCTAssertTrue(RecurrenceRule.weekends.occurs(on: saturday, startingAt: startDate, using: dayPolicy))
        XCTAssertFalse(RecurrenceRule.weekdays.occurs(on: saturday, startingAt: startDate, using: dayPolicy))
    }

    // MARK: - Same local day, different timestamps

    func testRequestedAndStartTimestampsOnSameLocalDayStillMatch() {
        let calendar = makeCalendar(timeZoneIdentifier: "Asia/Seoul")
        let dayPolicy = CalendarDayPolicy(calendar: calendar)
        // 2026-07-13 is a Monday (a weekday), started early morning and
        // requested late evening of the same local day.
        let startDate = makeDate(calendar, year: 2026, month: 7, day: 13, hour: 6)
        let requestedDate = makeDate(calendar, year: 2026, month: 7, day: 13, hour: 22)

        XCTAssertTrue(RecurrenceRule.weekdays.occurs(on: requestedDate, startingAt: startDate, using: dayPolicy))
    }
}
