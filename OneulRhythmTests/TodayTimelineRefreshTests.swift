//
//  TodayTimelineRefreshTests.swift
//  OneulRhythmTests
//

import XCTest
@testable import OneulRhythm

final class TodayTimelineRefreshTests: XCTestCase {
    private var calendar: Calendar = {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(identifier: "Asia/Seoul")!
        return calendar
    }()

    func testNextTransitionIsCurrentEndWhenInActiveWindow() {
        let start = date(hour: 8, minute: 0)
        let end = date(hour: 8, minute: 30)
        let now = date(hour: 8, minute: 10)
        let routine = makeRoutine(id: UUID(), title: "아침", start: start, end: end)
        let snapshot = snapshot(
            routines: [routine],
            current: routine,
            overdue: [],
            next: nil,
            date: now
        )

        let next = TodayTimelineRefresh.nextTransitionDate(
            snapshot: snapshot,
            now: now,
            calendar: calendar
        )

        XCTAssertEqual(next, end)
    }

    func testNextTransitionIsNextStartWhenWaiting() {
        let breakfast = makeRoutine(
            id: UUID(),
            title: "아침",
            start: date(hour: 8, minute: 0),
            end: date(hour: 8, minute: 30)
        )
        let focus = makeRoutine(
            id: UUID(),
            title: "집중",
            start: date(hour: 9, minute: 0),
            end: date(hour: 9, minute: 30)
        )
        let now = date(hour: 8, minute: 45)
        let snapshot = snapshot(
            routines: [breakfast, focus],
            current: nil,
            overdue: [breakfast],
            next: focus,
            date: now
        )

        let next = TodayTimelineRefresh.nextTransitionDate(
            snapshot: snapshot,
            now: now,
            calendar: calendar
        )

        XCTAssertEqual(next, focus.startTime)
    }

    func testNextTransitionFallsBackToTomorrowWhenDayComplete() {
        let start = date(hour: 8, minute: 0)
        let end = date(hour: 8, minute: 30)
        var routine = makeRoutine(id: UUID(), title: "아침", start: start, end: end)
        routine = Routine(
            id: routine.id,
            title: routine.title,
            startTime: routine.startTime,
            endTime: routine.endTime,
            category: routine.category,
            status: .completed,
            reminderMinutes: nil
        )
        let now = date(hour: 10, minute: 0)
        let snapshot = snapshot(
            routines: [routine],
            current: nil,
            overdue: [],
            next: nil,
            date: now
        )

        let next = TodayTimelineRefresh.nextTransitionDate(
            snapshot: snapshot,
            now: now,
            calendar: calendar
        )
        let tomorrow = calendar.date(
            byAdding: .day,
            value: 1,
            to: calendar.startOfDay(for: now)
        )

        XCTAssertEqual(next, tomorrow)
    }

    func testIgnoresPastBoundaries() {
        let start = date(hour: 7, minute: 0)
        let end = date(hour: 7, minute: 30)
        let now = date(hour: 8, minute: 0)
        let past = makeRoutine(id: UUID(), title: "지난", start: start, end: end)
        let upcoming = makeRoutine(
            id: UUID(),
            title: "다음",
            start: date(hour: 9, minute: 0),
            end: date(hour: 9, minute: 30)
        )
        let snapshot = snapshot(
            routines: [past, upcoming],
            current: nil,
            overdue: [past],
            next: upcoming,
            date: now
        )

        let next = TodayTimelineRefresh.nextTransitionDate(
            snapshot: snapshot,
            now: now,
            calendar: calendar
        )

        XCTAssertEqual(next, upcoming.startTime)
    }

    // MARK: - Helpers

    private func date(hour: Int, minute: Int) -> Date {
        var components = DateComponents()
        components.year = 2026
        components.month = 7
        components.day = 28
        components.hour = hour
        components.minute = minute
        return calendar.date(from: components)!
    }

    private func makeRoutine(
        id: UUID,
        title: String,
        start: Date,
        end: Date
    ) -> Routine {
        Routine(
            id: id,
            title: title,
            startTime: start,
            endTime: end,
            category: .morning,
            status: .upcoming,
            reminderMinutes: nil
        )
    }

    private func snapshot(
        routines: [Routine],
        current: Routine?,
        overdue: [Routine],
        next: Routine?,
        date: Date
    ) -> TodayRhythmSnapshot {
        TodayRhythmSnapshot(
            schedule: RoutineSchedule(
                routines: routines,
                currentRoutine: current,
                overdueRoutines: overdue,
                nextRoutine: next
            ),
            date: date
        )
    }
}
