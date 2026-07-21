//
//  OccurrenceDateTimeMaterializerTests.swift
//  OneulRhythmTests
//

import XCTest
@testable import OneulRhythm

final class OccurrenceDateTimeMaterializerTests: XCTestCase {
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

    private func makeMaterializer(
        timeZoneIdentifier: String = "Asia/Seoul"
    ) -> (OccurrenceDateTimeMaterializer, Calendar, CalendarDayPolicy) {
        let calendar = makeCalendar(timeZoneIdentifier: timeZoneIdentifier)
        let dayPolicy = CalendarDayPolicy(calendar: calendar)
        return (OccurrenceDateTimeMaterializer(dayPolicy: dayPolicy), calendar, dayPolicy)
    }

    private func makePlanned(
        calendar: Calendar,
        dayPolicy: CalendarDayPolicy,
        recurringRhythmID: UUID = UUID(),
        year: Int,
        month: Int,
        day: Int,
        startMinutes: Int,
        durationMinutes: Int,
        title: String = "아침 스트레칭",
        category: RoutineCategory = .morning,
        reminderMinutes: Int? = 10
    ) -> PlannedOccurrence {
        let rawDay = makeDate(calendar, year: year, month: month, day: day)
        return PlannedOccurrence(
            recurringRhythmID: recurringRhythmID,
            occurrenceDate: dayPolicy.day(for: rawDay),
            title: title,
            category: category,
            startMinutes: startMinutes,
            durationMinutes: durationMinutes,
            reminderMinutes: reminderMinutes
        )
    }

    // MARK: - Basic calculations

    func testNineAMPlusThirtyMinutes() {
        let (materializer, calendar, dayPolicy) = makeMaterializer()
        let planned = makePlanned(
            calendar: calendar,
            dayPolicy: dayPolicy,
            year: 2026,
            month: 7,
            day: 21,
            startMinutes: 9 * 60,
            durationMinutes: 30
        )

        let result = materializer.materialize(planned)

        XCTAssertEqual(
            result.startDate,
            makeDate(calendar, year: 2026, month: 7, day: 21, hour: 9)
        )
        XCTAssertEqual(
            result.endDate,
            makeDate(calendar, year: 2026, month: 7, day: 21, hour: 9, minute: 30)
        )
    }

    func testMidnightStart() {
        let (materializer, calendar, dayPolicy) = makeMaterializer()
        let planned = makePlanned(
            calendar: calendar,
            dayPolicy: dayPolicy,
            year: 2026,
            month: 7,
            day: 21,
            startMinutes: 0,
            durationMinutes: 45
        )

        let result = materializer.materialize(planned)

        XCTAssertEqual(
            result.startDate,
            makeDate(calendar, year: 2026, month: 7, day: 21)
        )
        XCTAssertEqual(
            result.endDate,
            makeDate(calendar, year: 2026, month: 7, day: 21, hour: 0, minute: 45)
        )
    }

    func testTwentyThreeThirtyPlusNinetyMinutesCrossesMidnight() {
        let (materializer, calendar, dayPolicy) = makeMaterializer()
        let planned = makePlanned(
            calendar: calendar,
            dayPolicy: dayPolicy,
            year: 2026,
            month: 7,
            day: 21,
            startMinutes: 23 * 60 + 30,
            durationMinutes: 90
        )

        let result = materializer.materialize(planned)

        XCTAssertEqual(
            result.startDate,
            makeDate(calendar, year: 2026, month: 7, day: 21, hour: 23, minute: 30)
        )
        XCTAssertEqual(
            result.endDate,
            makeDate(calendar, year: 2026, month: 7, day: 22, hour: 1)
        )
    }

    // MARK: - Reminder

    func testNilReminderPreserved() {
        let (materializer, calendar, dayPolicy) = makeMaterializer()
        let planned = makePlanned(
            calendar: calendar,
            dayPolicy: dayPolicy,
            year: 2026,
            month: 7,
            day: 21,
            startMinutes: 10 * 60,
            durationMinutes: 30,
            reminderMinutes: nil
        )

        XCTAssertNil(materializer.materialize(planned).reminderMinutes)
    }

    func testReminderPreserved() {
        let (materializer, calendar, dayPolicy) = makeMaterializer()
        let planned = makePlanned(
            calendar: calendar,
            dayPolicy: dayPolicy,
            year: 2026,
            month: 7,
            day: 21,
            startMinutes: 10 * 60,
            durationMinutes: 30,
            reminderMinutes: 15
        )

        XCTAssertEqual(materializer.materialize(planned).reminderMinutes, 15)
    }

    // MARK: - DST

    func testDSTSpringForwardDay() {
        let (materializer, calendar, dayPolicy) = makeMaterializer(
            timeZoneIdentifier: "America/New_York"
        )
        // 2026-03-08 springs forward at 02:00 local (23-hour day).
        let planned = makePlanned(
            calendar: calendar,
            dayPolicy: dayPolicy,
            year: 2026,
            month: 3,
            day: 8,
            startMinutes: 1 * 60,
            durationMinutes: 120
        )

        let result = materializer.materialize(planned)

        XCTAssertEqual(
            result.startDate,
            makeDate(calendar, year: 2026, month: 3, day: 8, hour: 1)
        )
        // 01:00 + 120 minutes crosses the spring-forward gap and lands at 04:00.
        XCTAssertEqual(
            result.endDate,
            makeDate(calendar, year: 2026, month: 3, day: 8, hour: 4)
        )
    }

    func testDSTFallBackDay() {
        let (materializer, calendar, dayPolicy) = makeMaterializer(
            timeZoneIdentifier: "America/New_York"
        )
        // 2026-11-01 falls back at 02:00 local (25-hour day).
        let planned = makePlanned(
            calendar: calendar,
            dayPolicy: dayPolicy,
            year: 2026,
            month: 11,
            day: 1,
            startMinutes: 0,
            durationMinutes: 90
        )

        let result = materializer.materialize(planned)

        XCTAssertEqual(
            result.startDate,
            makeDate(calendar, year: 2026, month: 11, day: 1)
        )
        XCTAssertEqual(
            result.endDate,
            makeDate(calendar, year: 2026, month: 11, day: 1, hour: 1, minute: 30)
        )
    }

    // MARK: - Non-UTC timezone and field preservation

    func testNonUTCTimezone() {
        let (materializer, calendar, dayPolicy) = makeMaterializer(
            timeZoneIdentifier: "America/Los_Angeles"
        )
        let planned = makePlanned(
            calendar: calendar,
            dayPolicy: dayPolicy,
            year: 2026,
            month: 1,
            day: 15,
            startMinutes: 16 * 60 + 2,
            durationMinutes: 40
        )

        let result = materializer.materialize(planned)

        XCTAssertEqual(
            result.startDate,
            makeDate(calendar, year: 2026, month: 1, day: 15, hour: 16, minute: 2)
        )
        XCTAssertEqual(
            result.endDate,
            makeDate(calendar, year: 2026, month: 1, day: 15, hour: 16, minute: 42)
        )
    }

    func testTitleAndCategoryPreserved() {
        let (materializer, calendar, dayPolicy) = makeMaterializer()
        let planned = makePlanned(
            calendar: calendar,
            dayPolicy: dayPolicy,
            year: 2026,
            month: 7,
            day: 21,
            startMinutes: 20 * 60,
            durationMinutes: 30,
            title: "저녁 산책",
            category: .evening
        )

        let result = materializer.materialize(planned)

        XCTAssertEqual(result.title, "저녁 산책")
        XCTAssertEqual(result.category, .evening)
    }

    func testRecurringRhythmIDPreserved() {
        let (materializer, calendar, dayPolicy) = makeMaterializer()
        let recurringID = UUID()
        let planned = makePlanned(
            calendar: calendar,
            dayPolicy: dayPolicy,
            recurringRhythmID: recurringID,
            year: 2026,
            month: 7,
            day: 21,
            startMinutes: 8 * 60,
            durationMinutes: 20
        )

        let result = materializer.materialize(planned)

        XCTAssertEqual(result.recurringRhythmID, recurringID)
        XCTAssertEqual(result.occurrenceDate, planned.occurrenceDate)
    }
}
