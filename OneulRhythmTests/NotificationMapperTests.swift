//
//  NotificationMapperTests.swift
//  OneulRhythmTests
//

import XCTest
@testable import OneulRhythm

final class NotificationMapperTests: XCTestCase {
    private let calendar: Calendar = {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(identifier: "Asia/Seoul")!
        return calendar
    }()

    // MARK: - Helpers

    private func makeDate(
        year: Int,
        month: Int,
        day: Int,
        hour: Int,
        minute: Int,
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

    private func makeRoutine(
        id: UUID = UUID(),
        title: String = "산책",
        startTime: Date,
        reminderMinutes: Int?
    ) -> Routine {
        Routine(
            id: id,
            title: title,
            startTime: startTime,
            endTime: nil,
            category: .movement,
            status: .upcoming,
            reminderMinutes: reminderMinutes
        )
    }

    // MARK: - Nil reminder

    func testNilReminderProducesEmptyPlan() {
        let startTime = makeDate(year: 2026, month: 7, day: 24, hour: 14, minute: 0)
        let now = makeDate(year: 2026, month: 7, day: 24, hour: 10, minute: 0)
        let routine = makeRoutine(startTime: startTime, reminderMinutes: nil)

        let plan = NotificationMapper.makePlan(
            routines: [routine],
            now: now,
            calendar: calendar
        )

        XCTAssertTrue(plan.items.isEmpty)
    }

    // MARK: - Future reminder

    func testFutureReminderProducesSingleItem() throws {
        let reminderMinutes = 10
        let startTime = makeDate(year: 2026, month: 7, day: 24, hour: 14, minute: 0)
        let now = makeDate(year: 2026, month: 7, day: 24, hour: 10, minute: 0)
        let expectedTrigger = calendar.date(
            byAdding: .minute,
            value: -reminderMinutes,
            to: startTime
        )!
        let routine = makeRoutine(
            title: "집중",
            startTime: startTime,
            reminderMinutes: reminderMinutes
        )

        let plan = NotificationMapper.makePlan(
            routines: [routine],
            now: now,
            calendar: calendar
        )

        XCTAssertEqual(plan.items.count, 1)
        let item = try XCTUnwrap(plan.items.first)
        XCTAssertEqual(item.identifier, routine.id.uuidString)
        XCTAssertEqual(item.title, "리듬 시작")
        XCTAssertEqual(item.body, "\"집중\" 리듬을 시작할 시간이에요.")
        XCTAssertEqual(item.triggerDate, expectedTrigger)
    }

    // MARK: - Past reminder

    func testPastReminderProducesEmptyPlan() {
        let startTime = makeDate(year: 2026, month: 7, day: 24, hour: 14, minute: 0)
        // Trigger would be 10 minutes before start; now is only 5 minutes before.
        let now = makeDate(year: 2026, month: 7, day: 24, hour: 13, minute: 55)
        let routine = makeRoutine(startTime: startTime, reminderMinutes: 10)

        let plan = NotificationMapper.makePlan(
            routines: [routine],
            now: now,
            calendar: calendar
        )

        XCTAssertTrue(plan.items.isEmpty)
    }

    // MARK: - Exact-now reminder

    func testExactNowReminderProducesEmptyPlan() {
        let reminderMinutes = 15
        let startTime = makeDate(year: 2026, month: 7, day: 24, hour: 14, minute: 0)
        let triggerInstant = calendar.date(
            byAdding: .minute,
            value: -reminderMinutes,
            to: startTime
        )!
        let routine = makeRoutine(
            startTime: startTime,
            reminderMinutes: reminderMinutes
        )

        let plan = NotificationMapper.makePlan(
            routines: [routine],
            now: triggerInstant,
            calendar: calendar
        )

        XCTAssertTrue(plan.items.isEmpty)
    }

    // MARK: - Deterministic ordering

    func testDeterministicOrderingByTriggerDateThenIdentifier() {
        let now = makeDate(year: 2026, month: 7, day: 24, hour: 8, minute: 0)
        let earlierStart = makeDate(year: 2026, month: 7, day: 24, hour: 12, minute: 0)
        let laterStart = makeDate(year: 2026, month: 7, day: 24, hour: 16, minute: 0)

        let earlierID = UUID(uuidString: "00000000-0000-0000-0000-000000000002")!
        let laterID = UUID(uuidString: "00000000-0000-0000-0000-000000000001")!

        // Same trigger time for two routines — identifier tie-break.
        let sameStart = makeDate(year: 2026, month: 7, day: 24, hour: 14, minute: 0)
        let lowID = UUID(uuidString: "00000000-0000-0000-0000-00000000000A")!
        let highID = UUID(uuidString: "00000000-0000-0000-0000-00000000000B")!

        let routines = [
            makeRoutine(id: laterID, title: "저녁", startTime: laterStart, reminderMinutes: 10),
            makeRoutine(id: highID, title: "집중B", startTime: sameStart, reminderMinutes: 10),
            makeRoutine(id: earlierID, title: "아침", startTime: earlierStart, reminderMinutes: 10),
            makeRoutine(id: lowID, title: "집중A", startTime: sameStart, reminderMinutes: 10)
        ]

        let plan = NotificationMapper.makePlan(
            routines: routines,
            now: now,
            calendar: calendar
        )

        XCTAssertEqual(plan.items.count, 4)
        XCTAssertEqual(plan.items.map(\.identifier), [
            earlierID.uuidString,
            lowID.uuidString,
            highID.uuidString,
            laterID.uuidString
        ])
    }

    // MARK: - Identifier / title / body correctness

    func testIdentifierMatchesRoutineUUIDString() throws {
        let id = UUID(uuidString: "AAAAAAAA-BBBB-CCCC-DDDD-EEEEEEEEEEEE")!
        let startTime = makeDate(year: 2026, month: 7, day: 24, hour: 14, minute: 0)
        let now = makeDate(year: 2026, month: 7, day: 24, hour: 10, minute: 0)
        let routine = makeRoutine(
            id: id,
            title: "휴식",
            startTime: startTime,
            reminderMinutes: 5
        )

        let plan = NotificationMapper.makePlan(
            routines: [routine],
            now: now,
            calendar: calendar
        )

        let item = try XCTUnwrap(plan.items.first)
        XCTAssertEqual(item.identifier, id.uuidString)
        XCTAssertEqual(item.title, "리듬 시작")
        XCTAssertEqual(item.body, "\"휴식\" 리듬을 시작할 시간이에요.")
    }

    func testMixedNilAndValidRemindersOmitsNilOnly() {
        let startTime = makeDate(year: 2026, month: 7, day: 24, hour: 14, minute: 0)
        let now = makeDate(year: 2026, month: 7, day: 24, hour: 10, minute: 0)
        let withReminder = makeRoutine(
            title: "운동",
            startTime: startTime,
            reminderMinutes: 10
        )
        let withoutReminder = makeRoutine(
            title: "휴식",
            startTime: startTime,
            reminderMinutes: nil
        )

        let plan = NotificationMapper.makePlan(
            routines: [withoutReminder, withReminder],
            now: now,
            calendar: calendar
        )

        XCTAssertEqual(plan.items.count, 1)
        XCTAssertEqual(plan.items.first?.identifier, withReminder.id.uuidString)
        XCTAssertEqual(plan.items.first?.body, "\"운동\" 리듬을 시작할 시간이에요.")
    }
}
