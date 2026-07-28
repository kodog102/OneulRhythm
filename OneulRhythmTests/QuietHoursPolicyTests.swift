//
//  QuietHoursPolicyTests.swift
//  OneulRhythmTests
//

import XCTest
@testable import OneulRhythm

final class QuietHoursPolicyTests: XCTestCase {
    private var calendar: Calendar {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(identifier: "Asia/Seoul")!
        return calendar
    }

    private func date(hour: Int, minute: Int) -> Date {
        calendar.date(
            from: DateComponents(year: 2026, month: 7, day: 28, hour: hour, minute: minute)
        )!
    }

    func testDisabledNeverContains() {
        let configuration = QuietHoursConfiguration(
            isEnabled: false,
            startMinutes: 22 * 60,
            endMinutes: 7 * 60
        )
        XCTAssertFalse(
            QuietHoursPolicy.contains(date(hour: 23, minute: 0), configuration: configuration, calendar: calendar)
        )
    }

    func testOvernightWindow() {
        let configuration = QuietHoursConfiguration(
            isEnabled: true,
            startMinutes: 22 * 60,
            endMinutes: 7 * 60
        )
        XCTAssertTrue(
            QuietHoursPolicy.contains(date(hour: 22, minute: 0), configuration: configuration, calendar: calendar)
        )
        XCTAssertTrue(
            QuietHoursPolicy.contains(date(hour: 23, minute: 30), configuration: configuration, calendar: calendar)
        )
        XCTAssertTrue(
            QuietHoursPolicy.contains(date(hour: 6, minute: 59), configuration: configuration, calendar: calendar)
        )
        XCTAssertFalse(
            QuietHoursPolicy.contains(date(hour: 7, minute: 0), configuration: configuration, calendar: calendar)
        )
        XCTAssertFalse(
            QuietHoursPolicy.contains(date(hour: 12, minute: 0), configuration: configuration, calendar: calendar)
        )
    }

    func testSameDayWindow() {
        let configuration = QuietHoursConfiguration(
            isEnabled: true,
            startMinutes: 13 * 60,
            endMinutes: 14 * 60
        )
        XCTAssertTrue(
            QuietHoursPolicy.contains(date(hour: 13, minute: 0), configuration: configuration, calendar: calendar)
        )
        XCTAssertTrue(
            QuietHoursPolicy.contains(date(hour: 13, minute: 30), configuration: configuration, calendar: calendar)
        )
        XCTAssertFalse(
            QuietHoursPolicy.contains(date(hour: 14, minute: 0), configuration: configuration, calendar: calendar)
        )
        XCTAssertFalse(
            QuietHoursPolicy.contains(date(hour: 12, minute: 59), configuration: configuration, calendar: calendar)
        )
    }

    func testDegenerateWindowInactive() {
        let configuration = QuietHoursConfiguration(
            isEnabled: true,
            startMinutes: 10 * 60,
            endMinutes: 10 * 60
        )
        XCTAssertFalse(
            QuietHoursPolicy.contains(date(hour: 10, minute: 0), configuration: configuration, calendar: calendar)
        )
    }

    func testReminderGateRespectsQuietHoursAndMasterToggle() {
        let quiet = QuietHoursConfiguration(
            isEnabled: true,
            startMinutes: 22 * 60,
            endMinutes: 7 * 60
        )
        let triggerInside = date(hour: 23, minute: 0)
        let triggerOutside = date(hour: 10, minute: 0)

        XCTAssertFalse(
            ReminderNotificationGate.shouldDeliver(
                triggerDate: triggerInside,
                remindersEnabled: true,
                quietHours: quiet,
                calendar: calendar
            )
        )
        XCTAssertTrue(
            ReminderNotificationGate.shouldDeliver(
                triggerDate: triggerOutside,
                remindersEnabled: true,
                quietHours: quiet,
                calendar: calendar
            )
        )
        XCTAssertFalse(
            ReminderNotificationGate.shouldDeliver(
                triggerDate: triggerOutside,
                remindersEnabled: false,
                quietHours: quiet,
                calendar: calendar
            )
        )
    }
}
