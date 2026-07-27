import XCTest
@testable import OneulRhythm

final class AddRoutineViewPastTimeDefaultTests: XCTestCase {
    private func makeCalendar(timeZoneIdentifier: String = "Asia/Seoul") -> Calendar {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(identifier: timeZoneIdentifier)!
        return calendar
    }

    private func makeDate(
        _ calendar: Calendar,
        year: Int,
        month: Int,
        day: Int,
        hour: Int,
        minute: Int,
        second: Int = 0,
        nanosecond: Int = 0
    ) -> Date {
        var components = DateComponents()
        components.year = year
        components.month = month
        components.day = day
        components.hour = hour
        components.minute = minute
        components.second = second
        components.nanosecond = nanosecond
        return calendar.date(from: components)!
    }

    func testDefaultStartTimeDoesNotBecomePastWithinSameMinute() {
        let calendar = makeCalendar()

        let open = makeDate(calendar, year: 2026, month: 7, day: 25, hour: 10, minute: 0, second: 30)
        let now = makeDate(calendar, year: 2026, month: 7, day: 25, hour: 10, minute: 0, second: 45)

        let snappedStart = AddRoutineView.snapToNextMinute(open, calendar: calendar)

        XCTAssertFalse(
            AddRoutineView.isStartTimeInPastOnTargetDay(
                startTime: snappedStart,
                now: now,
                mode: .create,
                calendar: calendar
            )
        )
    }

    func testDefaultStartTimeDoesNotBecomePastAcrossNextMinuteBoundary() {
        let calendar = makeCalendar()

        let open = makeDate(calendar, year: 2026, month: 7, day: 25, hour: 10, minute: 0, second: 59)
        let now = makeDate(calendar, year: 2026, month: 7, day: 25, hour: 10, minute: 1, second: 5)

        let snappedStart = AddRoutineView.snapToNextMinute(open, calendar: calendar)

        XCTAssertFalse(
            AddRoutineView.isStartTimeInPastOnTargetDay(
                startTime: snappedStart,
                now: now,
                mode: .create,
                calendar: calendar
            )
        )
    }

    func testExplicitPastMinuteSelectionStillShowsPast() {
        let calendar = makeCalendar()

        let selectedStart = makeDate(calendar, year: 2026, month: 7, day: 25, hour: 10, minute: 0, second: 0)
        let now = makeDate(calendar, year: 2026, month: 7, day: 25, hour: 10, minute: 1, second: 10)

        XCTAssertTrue(
            AddRoutineView.isStartTimeInPastOnTargetDay(
                startTime: selectedStart,
                now: now,
                mode: .create,
                calendar: calendar
            )
        )
    }

    func testExplicitFutureMinuteSelectionIsNotPast() {
        let calendar = makeCalendar()

        let selectedStart = makeDate(calendar, year: 2026, month: 7, day: 25, hour: 10, minute: 2, second: 0)
        let now = makeDate(calendar, year: 2026, month: 7, day: 25, hour: 10, minute: 1, second: 10)

        XCTAssertFalse(
            AddRoutineView.isStartTimeInPastOnTargetDay(
                startTime: selectedStart,
                now: now,
                mode: .create,
                calendar: calendar
            )
        )
    }

    func testMinuteSnapHandlesHourRollover() {
        let calendar = makeCalendar()

        let open = makeDate(calendar, year: 2026, month: 7, day: 25, hour: 23, minute: 59, second: 30)
        let now = makeDate(calendar, year: 2026, month: 7, day: 26, hour: 0, minute: 0, second: 5)

        let snappedStart = AddRoutineView.snapToNextMinute(open, calendar: calendar)

        XCTAssertFalse(
            AddRoutineView.isStartTimeInPastOnTargetDay(
                startTime: snappedStart,
                now: now,
                mode: .create,
                calendar: calendar
            )
        )
    }
}

