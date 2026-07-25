//
//  RecurringDefinitionDeletionTests.swift
//  OneulRhythmTests
//

import XCTest
import SwiftData
@testable import OneulRhythm

@MainActor
final class RecurringDefinitionDeletionTests: XCTestCase {
    private let calendar: Calendar = {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(identifier: "Asia/Seoul")!
        return calendar
    }()

    private lazy var dayPolicy = CalendarDayPolicy(calendar: calendar)
    private lazy var now = makeDate(year: 2026, month: 7, day: 25, hour: 15, minute: 0)

    // MARK: - Helpers

    private func makeContainer() throws -> ModelContainer {
        let schema = Schema([RoutineEntity.self, RecurringRhythmEntity.self])
        let configuration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
        return try ModelContainer(for: schema, configurations: [configuration])
    }

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

    private func makeOccurrenceEntity(
        id: UUID = UUID(),
        title: String = "Exercise",
        startTime: Date,
        status: RoutineStatus,
        recurringRhythmID: UUID
    ) -> RoutineEntity {
        RoutineEntity(
            id: id,
            title: title,
            startTime: startTime,
            endTime: startTime.addingTimeInterval(30 * 60),
            category: .movement,
            status: status,
            recurringRhythmID: recurringRhythmID,
            occurrenceDate: dayPolicy.day(for: startTime)
        )
    }

    private func makeDefinition(
        id: UUID,
        title: String = "Daily Exercise"
    ) -> RecurringRhythmEntity {
        RecurringRhythmEntity(
            id: id,
            title: title,
            category: .movement,
            startMinutes: 7 * 60,
            durationMinutes: 30,
            recurrence: .daily,
            startDate: dayPolicy.day(for: now),
            isActive: true
        )
    }

    // MARK: - Recurring deletion

    func testApplyPreservesHistoryRemovesIncompleteTodayAndFutureAndDeactivatesDefinition() throws {
        let container = try makeContainer()
        let context = ModelContext(container)
        let routineRepository = SwiftDataRoutineRepository(modelContext: context)
        let recurringRepository = SwiftDataRecurringRhythmRepository(modelContext: context)

        let definitionID = UUID()
        let otherDefinitionID = UUID()

        let pastCompletedID = UUID()
        let pastIncompleteID = UUID()
        let todayCompletedID = UUID()
        let todayIncompleteID = UUID()
        let futureID = UUID()
        let unrelatedID = UUID()

        try recurringRepository.insert(makeDefinition(id: definitionID))
        try recurringRepository.insert(makeDefinition(id: otherDefinitionID, title: "Other"))

        let entities = [
            makeOccurrenceEntity(
                id: pastCompletedID,
                startTime: makeDate(year: 2026, month: 7, day: 24, hour: 7, minute: 0),
                status: .completed,
                recurringRhythmID: definitionID
            ),
            makeOccurrenceEntity(
                id: pastIncompleteID,
                startTime: makeDate(year: 2026, month: 7, day: 23, hour: 7, minute: 0),
                status: .upcoming,
                recurringRhythmID: definitionID
            ),
            makeOccurrenceEntity(
                id: todayCompletedID,
                startTime: makeDate(year: 2026, month: 7, day: 25, hour: 7, minute: 0),
                status: .completed,
                recurringRhythmID: definitionID
            ),
            makeOccurrenceEntity(
                id: todayIncompleteID,
                startTime: makeDate(year: 2026, month: 7, day: 25, hour: 18, minute: 0),
                status: .upcoming,
                recurringRhythmID: definitionID
            ),
            makeOccurrenceEntity(
                id: futureID,
                startTime: makeDate(year: 2026, month: 7, day: 26, hour: 7, minute: 0),
                status: .upcoming,
                recurringRhythmID: definitionID
            ),
            makeOccurrenceEntity(
                id: unrelatedID,
                title: "Other Walk",
                startTime: makeDate(year: 2026, month: 7, day: 24, hour: 8, minute: 0),
                status: .completed,
                recurringRhythmID: otherDefinitionID
            )
        ]

        for entity in entities {
            try routineRepository.insert(entity)
        }

        try RecurringDefinitionDeletion.apply(
            definitionID: definitionID,
            entities: try routineRepository.fetchRoutines(),
            now: now,
            dayPolicy: dayPolicy,
            repository: routineRepository,
            recurringRepository: recurringRepository
        )

        let remainingIDs = Set(try routineRepository.fetchRoutines().map(\.id))
        XCTAssertEqual(
            remainingIDs,
            [pastCompletedID, pastIncompleteID, todayCompletedID, unrelatedID]
        )
        XCTAssertFalse(remainingIDs.contains(todayIncompleteID))
        XCTAssertFalse(remainingIDs.contains(futureID))

        let activeDefinitions = try recurringRepository.fetchActive()
        XCTAssertFalse(activeDefinitions.contains { $0.id == definitionID })
        XCTAssertTrue(activeDefinitions.contains { $0.id == otherDefinitionID })
    }

    func testOneTimeDeletionRemainsSingleRowOnly() throws {
        let container = try makeContainer()
        let context = ModelContext(container)
        let routineRepository = SwiftDataRoutineRepository(modelContext: context)

        let oneTimeID = UUID()
        let otherOneTimeID = UUID()

        try routineRepository.insert(
            RoutineEntity(
                id: oneTimeID,
                title: "Hospital",
                startTime: makeDate(year: 2026, month: 7, day: 25, hour: 10, minute: 0),
                endTime: nil,
                category: .focus,
                status: .upcoming
            )
        )
        try routineRepository.insert(
            RoutineEntity(
                id: otherOneTimeID,
                title: "Meeting",
                startTime: makeDate(year: 2026, month: 7, day: 26, hour: 11, minute: 0),
                endTime: nil,
                category: .focus,
                status: .upcoming
            )
        )

        try routineRepository.delete(id: oneTimeID)

        let remaining = try routineRepository.fetchRoutines()
        XCTAssertEqual(remaining.map(\.id), [otherOneTimeID])
    }
}
