//
//  ManagementRhythmComposerTests.swift
//  OneulRhythmTests
//

import XCTest
@testable import OneulRhythm

final class ManagementRhythmComposerTests: XCTestCase {
    private let calendar: Calendar = {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(identifier: "Asia/Seoul")!
        return calendar
    }()

    private lazy var dayPolicy = CalendarDayPolicy(calendar: calendar)

    private lazy var today = makeDate(year: 2026, month: 7, day: 25, hour: 10, minute: 0)
    private lazy var yesterday = makeDate(year: 2026, month: 7, day: 24, hour: 15, minute: 0)
    private lazy var tomorrow = makeDate(year: 2026, month: 7, day: 26, hour: 9, minute: 0)

    // MARK: - Helpers

    private func makeDate(
        year: Int,
        month: Int,
        day: Int,
        hour: Int,
        minute: Int
    ) -> Date {
        var components = DateComponents()
        components.year = year
        components.month = month
        components.day = day
        components.hour = hour
        components.minute = minute
        return calendar.date(from: components)!
    }

    private func makeRecurring(
        id: UUID = UUID(),
        title: String,
        startMinutes: Int,
        recurrence: RecurrenceRule = .daily
    ) -> RecurringManagementRhythm {
        RecurringManagementRhythm(
            id: id,
            title: title,
            category: .movement,
            startMinutes: startMinutes,
            durationMinutes: 30,
            recurrence: recurrence,
            reminderMinutes: nil,
            startDate: dayPolicy.day(for: today)
        )
    }

    private func makeOneTime(
        id: UUID = UUID(),
        title: String,
        startTime: Date,
        recurringRhythmID: UUID? = nil
    ) -> Routine {
        Routine(
            id: id,
            title: title,
            startTime: startTime,
            endTime: nil,
            category: .focus,
            status: .upcoming,
            recurringRhythmID: recurringRhythmID,
            occurrenceDate: recurringRhythmID == nil ? nil : dayPolicy.day(for: startTime)
        )
    }

    // MARK: - Recurring definitions

    func testIncludesEachActiveRecurringDefinitionOnce() {
        let morningID = UUID()
        let eveningID = UUID()
        let recurring = [
            makeRecurring(id: morningID, title: "Daily Exercise", startMinutes: 7 * 60),
            makeRecurring(id: eveningID, title: "Weekday Reading", startMinutes: 21 * 60, recurrence: .weekdays)
        ]

        let catalog = ManagementRhythmComposer.compose(
            recurring: recurring,
            routines: [],
            now: today,
            dayPolicy: dayPolicy
        )

        XCTAssertEqual(catalog.recurring.count, 2)
        XCTAssertTrue(catalog.oneTime.isEmpty)
        XCTAssertEqual(catalog.recurring.map(\.id), [morningID, eveningID])
        XCTAssertTrue(catalog.recurring.allSatisfy(\.isRecurring))
    }

    func testExcludesHistoricalRecurringOccurrences() {
        let definitionID = UUID()
        let recurring = [
            makeRecurring(id: definitionID, title: "Daily Exercise", startMinutes: 7 * 60)
        ]
        let routines = [
            makeOneTime(
                title: "July 20 Exercise",
                startTime: makeDate(year: 2026, month: 7, day: 20, hour: 7, minute: 0),
                recurringRhythmID: definitionID
            ),
            makeOneTime(
                title: "July 21 Exercise",
                startTime: makeDate(year: 2026, month: 7, day: 21, hour: 7, minute: 0),
                recurringRhythmID: definitionID
            ),
            makeOneTime(
                title: "Today Exercise Occurrence",
                startTime: makeDate(year: 2026, month: 7, day: 25, hour: 7, minute: 0),
                recurringRhythmID: definitionID
            )
        ]

        let catalog = ManagementRhythmComposer.compose(
            recurring: recurring,
            routines: routines,
            now: today,
            dayPolicy: dayPolicy
        )

        XCTAssertEqual(catalog.recurring.count, 1)
        XCTAssertTrue(catalog.oneTime.isEmpty)
        XCTAssertEqual(catalog.recurring.first?.id, definitionID)
        XCTAssertEqual(catalog.recurring.first?.title, "Daily Exercise")
    }

    // MARK: - One-time visibility

    func testIncludesTodayAndFutureOneTimeRoutines() {
        let todayID = UUID()
        let tomorrowID = UUID()
        let routines = [
            makeOneTime(id: todayID, title: "Today Hospital", startTime: today),
            makeOneTime(id: tomorrowID, title: "Tomorrow Meeting", startTime: tomorrow)
        ]

        let catalog = ManagementRhythmComposer.compose(
            recurring: [],
            routines: routines,
            now: today,
            dayPolicy: dayPolicy
        )

        // Sorted by date then time: today 10:00 before tomorrow 09:00.
        XCTAssertTrue(catalog.recurring.isEmpty)
        XCTAssertEqual(catalog.oneTime.map(\.id), [todayID, tomorrowID])
        XCTAssertTrue(catalog.oneTime.allSatisfy { !$0.isRecurring })
    }

    func testHidesPastOneTimeRoutines() {
        let pastID = UUID()
        let futureID = UUID()
        let routines = [
            makeOneTime(id: pastID, title: "Yesterday Hospital", startTime: yesterday),
            makeOneTime(id: futureID, title: "Tomorrow Meeting", startTime: tomorrow)
        ]

        let catalog = ManagementRhythmComposer.compose(
            recurring: [],
            routines: routines,
            now: today,
            dayPolicy: dayPolicy
        )

        XCTAssertEqual(catalog.oneTime.count, 1)
        XCTAssertEqual(catalog.oneTime.first?.id, futureID)
    }

    func testDayBoundaryKeepsTodayOneTimeVisible() {
        let earlyToday = makeDate(year: 2026, month: 7, day: 25, hour: 0, minute: 5)
        let lateNow = makeDate(year: 2026, month: 7, day: 25, hour: 23, minute: 50)
        let routineID = UUID()

        let catalog = ManagementRhythmComposer.compose(
            recurring: [],
            routines: [
                makeOneTime(id: routineID, title: "Late Night", startTime: earlyToday)
            ],
            now: lateNow,
            dayPolicy: dayPolicy
        )

        XCTAssertEqual(catalog.oneTime.map(\.id), [routineID])
    }

    // MARK: - Mixed composition

    func testMixedListUsesDefinitionAndOneTimeIdentities() {
        let definitionID = UUID()
        let oneTimeID = UUID()

        let catalog = ManagementRhythmComposer.compose(
            recurring: [
                makeRecurring(id: definitionID, title: "Weekend Walk", startMinutes: 8 * 60, recurrence: .weekends)
            ],
            routines: [
                makeOneTime(
                    title: "Past Occurrence",
                    startTime: yesterday,
                    recurringRhythmID: definitionID
                ),
                makeOneTime(id: oneTimeID, title: "Tomorrow Meeting", startTime: tomorrow),
                makeOneTime(title: "Yesterday Shopping", startTime: yesterday)
            ],
            now: today,
            dayPolicy: dayPolicy
        )

        XCTAssertEqual(catalog.recurring.map(\.id), [definitionID])
        XCTAssertEqual(catalog.oneTime.map(\.id), [oneTimeID])
    }

    func testSortsRecurringByConfiguredTimeThenTitle() {
        let catalog = ManagementRhythmComposer.compose(
            recurring: [
                makeRecurring(title: "B Recurring", startMinutes: 9 * 60),
                makeRecurring(title: "A Recurring", startMinutes: 9 * 60),
                makeRecurring(title: "Evening", startMinutes: 18 * 60)
            ],
            routines: [],
            now: today,
            dayPolicy: dayPolicy
        )

        XCTAssertEqual(catalog.recurring.map(\.title), [
            "A Recurring",
            "B Recurring",
            "Evening"
        ])
    }

    func testSortsOneTimeByDateThenTimeThenTitle() {
        let laterTodayID = UUID()
        let earlierTomorrowID = UUID()
        let laterTomorrowID = UUID()

        let catalog = ManagementRhythmComposer.compose(
            recurring: [],
            routines: [
                makeOneTime(
                    id: earlierTomorrowID,
                    title: "Tomorrow Morning",
                    startTime: tomorrow
                ),
                makeOneTime(
                    id: laterTodayID,
                    title: "Today Afternoon",
                    startTime: makeDate(year: 2026, month: 7, day: 25, hour: 14, minute: 0)
                ),
                makeOneTime(
                    id: laterTomorrowID,
                    title: "Tomorrow Afternoon",
                    startTime: makeDate(year: 2026, month: 7, day: 26, hour: 15, minute: 0)
                )
            ],
            now: today,
            dayPolicy: dayPolicy
        )

        XCTAssertEqual(catalog.oneTime.map(\.id), [
            laterTodayID,
            earlierTomorrowID,
            laterTomorrowID
        ])
    }

    func testKeepsSectionsSeparateWhenWallClockOverlaps() {
        let definitionID = UUID()
        let oneTimeID = UUID()

        let catalog = ManagementRhythmComposer.compose(
            recurring: [
                makeRecurring(id: definitionID, title: "Morning Recurring", startMinutes: 9 * 60)
            ],
            routines: [
                makeOneTime(
                    id: oneTimeID,
                    title: "Afternoon Visit",
                    startTime: makeDate(year: 2026, month: 7, day: 25, hour: 14, minute: 0)
                )
            ],
            now: today,
            dayPolicy: dayPolicy
        )

        XCTAssertEqual(catalog.recurring.map(\.id), [definitionID])
        XCTAssertEqual(catalog.oneTime.map(\.id), [oneTimeID])
        XCTAssertFalse(catalog.isEmpty)
    }

    func testScheduleSummaryUsesEstablishedRecurrenceLanguage() {
        let item = ManagementRhythmItem.recurring(
            makeRecurring(title: "아침 독서", startMinutes: 7 * 60 + 30, recurrence: .daily)
        )

        let summary = item.formattedScheduleSummary(
            referenceDay: today,
            now: today,
            dayPolicy: dayPolicy
        )
        let accessibilityFragments = item.accessibilityScheduleFragments(
            referenceDay: today,
            now: today,
            dayPolicy: dayPolicy
        )

        XCTAssertTrue(summary.contains("매일"))
        XCTAssertFalse(summary.contains("반복"))
        XCTAssertFalse(summary.contains("daily"))
        XCTAssertTrue(accessibilityFragments.contains("매일 반복"))
    }

    func testOneTimeScheduleSummaryUsesTodayLabel() {
        let item = ManagementRhythmItem.oneTime(
            makeOneTime(
                title: "병원",
                startTime: makeDate(year: 2026, month: 7, day: 25, hour: 14, minute: 0)
            )
        )

        let summary = item.formattedScheduleSummary(
            referenceDay: today,
            now: today,
            dayPolicy: dayPolicy
        )

        XCTAssertTrue(summary.hasPrefix("오늘 · "))
    }
}
