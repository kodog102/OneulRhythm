//
//  TodayPrimaryRingPresentationTests.swift
//  OneulRhythmTests
//

import XCTest
@testable import OneulRhythm

final class TodayPrimaryRingPresentationTests: XCTestCase {
    private var calendar: Calendar = {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(identifier: "Asia/Seoul")!
        return calendar
    }()

    func testPastIncompleteDoesNotShowUpcomingBadge() {
        let routine = makeRoutine(
            start: date(hour: 8, minute: 0),
            end: date(hour: 8, minute: 1)
        )
        let now = date(hour: 8, minute: 2)

        let label = TodayPrimaryRingPresentation.label(
            role: .pastIncomplete,
            routine: routine,
            now: now
        )

        XCTAssertNotEqual(label, "곧")
        XCTAssertEqual(label, routine.formattedTime)
        XCTAssertEqual(
            TodayPrimaryRingPresentation.trim(
                role: .pastIncomplete,
                routine: routine,
                now: now
            ),
            0
        )
    }

    func testUpcomingShowsSoonBadge() {
        let routine = makeRoutine(
            start: date(hour: 9, minute: 0),
            end: date(hour: 9, minute: 30)
        )
        let now = date(hour: 8, minute: 30)

        let label = TodayPrimaryRingPresentation.label(
            role: .next,
            routine: routine,
            now: now
        )

        XCTAssertEqual(label, "곧")
    }

    func testCurrentShowsRemainingMinutes() {
        let routine = makeRoutine(
            start: date(hour: 8, minute: 0),
            end: date(hour: 8, minute: 30)
        )
        let now = date(hour: 8, minute: 10)

        let label = TodayPrimaryRingPresentation.label(
            role: .current,
            routine: routine,
            now: now
        )

        XCTAssertEqual(label, "20분\n남음")
    }

    func testCurrentAtExactEndDoesNotShowUpcomingBadge() {
        let end = date(hour: 8, minute: 30)
        let routine = makeRoutine(start: date(hour: 8, minute: 0), end: end)

        let label = TodayPrimaryRingPresentation.label(
            role: .current,
            routine: routine,
            now: end
        )

        XCTAssertNotEqual(label, "곧")
        XCTAssertEqual(label, routine.formattedTime)
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

    private func makeRoutine(start: Date, end: Date) -> Routine {
        Routine(
            id: UUID(),
            title: "테스트",
            startTime: start,
            endTime: end,
            category: .morning,
            status: .upcoming
        )
    }
}
