//
//  NotificationTriggerPolicyTests.swift
//  OneulRhythmTests
//

import XCTest
@testable import OneulRhythm

final class NotificationTriggerPolicyTests: XCTestCase {
    private let calendar: Calendar = {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(identifier: "Asia/Seoul")!
        return calendar
    }()

    private lazy var startTime: Date = makeDate(
        year: 2026,
        month: 7,
        day: 23,
        hour: 14,
        minute: 0
    )

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

    // MARK: - Missing offset

    func testNilReminderReturnsNil() {
        let now = startTime.addingTimeInterval(-60 * 60)

        let trigger = NotificationTriggerPolicy.triggerDate(
            startTime: startTime,
            reminderMinutes: nil,
            now: now,
            calendar: calendar
        )

        XCTAssertNil(trigger)
    }

    // MARK: - Future trigger

    func testFutureTriggerReturnsComputedDate() {
        let reminderMinutes = 10
        let now = startTime.addingTimeInterval(-60 * 60)
        let expected = calendar.date(
            byAdding: .minute,
            value: -reminderMinutes,
            to: startTime
        )

        let trigger = NotificationTriggerPolicy.triggerDate(
            startTime: startTime,
            reminderMinutes: reminderMinutes,
            now: now,
            calendar: calendar
        )

        XCTAssertEqual(trigger, expected)
    }

    // MARK: - Boundary: exactly now

    func testTriggerExactlyNowReturnsNil() {
        let reminderMinutes = 15
        let triggerInstant = calendar.date(
            byAdding: .minute,
            value: -reminderMinutes,
            to: startTime
        )!

        let trigger = NotificationTriggerPolicy.triggerDate(
            startTime: startTime,
            reminderMinutes: reminderMinutes,
            now: triggerInstant,
            calendar: calendar
        )

        XCTAssertNil(trigger)
    }

    // MARK: - Past trigger

    func testTriggerInThePastReturnsNil() {
        let reminderMinutes = 10
        // Trigger would be 10 minutes before start; now is only 5 minutes before.
        let now = startTime.addingTimeInterval(-5 * 60)

        let trigger = NotificationTriggerPolicy.triggerDate(
            startTime: startTime,
            reminderMinutes: reminderMinutes,
            now: now,
            calendar: calendar
        )

        XCTAssertNil(trigger)
    }

    // MARK: - Boundary: one second after now

    func testTriggerOneSecondAfterNowReturnsDate() {
        let reminderMinutes = 10
        let expected = calendar.date(
            byAdding: .minute,
            value: -reminderMinutes,
            to: startTime
        )!
        let now = expected.addingTimeInterval(-1)

        let trigger = NotificationTriggerPolicy.triggerDate(
            startTime: startTime,
            reminderMinutes: reminderMinutes,
            now: now,
            calendar: calendar
        )

        XCTAssertEqual(trigger, expected)
    }
}
