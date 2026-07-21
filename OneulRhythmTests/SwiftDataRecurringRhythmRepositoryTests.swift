//
//  SwiftDataRecurringRhythmRepositoryTests.swift
//  OneulRhythmTests
//

import XCTest
import SwiftData
@testable import OneulRhythm

@MainActor
final class SwiftDataRecurringRhythmRepositoryTests: XCTestCase {
    // MARK: - Helpers

    private func makeContainer() throws -> ModelContainer {
        let schema = Schema([RecurringRhythmEntity.self])
        let configuration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
        return try ModelContainer(for: schema, configurations: [configuration])
    }

    private func makeRepository(container: ModelContainer) -> SwiftDataRecurringRhythmRepository {
        SwiftDataRecurringRhythmRepository(modelContext: ModelContext(container))
    }

    private func makeStartDate() -> Date {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(identifier: "Asia/Seoul")!

        var components = DateComponents()
        components.year = 2026
        components.month = 7
        components.day = 15
        components.hour = 0
        return calendar.date(from: components)!
    }

    private func makeDefinition(
        id: UUID = UUID(),
        title: String = "아침 스트레칭",
        category: RoutineCategory = .morning,
        startMinutes: Int = 7 * 60,
        durationMinutes: Int = 30,
        recurrence: RecurrenceRule = .daily,
        startDate: Date? = nil,
        reminderMinutes: Int? = 10,
        isActive: Bool = true
    ) -> RecurringRhythmEntity {
        RecurringRhythmEntity(
            id: id,
            title: title,
            category: category,
            startMinutes: startMinutes,
            durationMinutes: durationMinutes,
            recurrence: recurrence,
            startDate: startDate ?? makeStartDate(),
            reminderMinutes: reminderMinutes,
            isActive: isActive
        )
    }

    // MARK: - Insert / fetch

    func testInsertPersistsRecurringDefinition() throws {
        let container = try makeContainer()
        let repository = makeRepository(container: container)
        let id = UUID()

        try repository.insert(makeDefinition(id: id, title: "집중 시간", category: .focus))

        let fetched = try repository.fetchActive()
        XCTAssertEqual(fetched.count, 1)
        XCTAssertEqual(fetched.first?.id, id)
        XCTAssertEqual(fetched.first?.title, "집중 시간")
        XCTAssertEqual(fetched.first?.categoryRawValue, RoutineCategory.focus.rawValue)
    }

    func testFetchActiveReturnsInsertedActiveDefinition() throws {
        let container = try makeContainer()
        let repository = makeRepository(container: container)

        try repository.insert(makeDefinition(title: "활성 리듬", isActive: true))

        let fetched = try repository.fetchActive()
        XCTAssertEqual(fetched.count, 1)
        XCTAssertEqual(fetched.first?.title, "활성 리듬")
        XCTAssertTrue(fetched.first?.isActive == true)
    }

    func testFetchActiveExcludesInactiveDefinition() throws {
        let container = try makeContainer()
        let repository = makeRepository(container: container)

        try repository.insert(makeDefinition(title: "비활성", isActive: false))
        try repository.insert(makeDefinition(title: "활성", isActive: true))

        let fetched = try repository.fetchActive()
        XCTAssertEqual(fetched.count, 1)
        XCTAssertEqual(fetched.first?.title, "활성")
    }

    func testFetchActiveReturnsMultipleActiveDefinitions() throws {
        let container = try makeContainer()
        let repository = makeRepository(container: container)

        let firstID = UUID()
        let secondID = UUID()

        try repository.insert(makeDefinition(id: firstID, title: "아침", startMinutes: 7 * 60))
        try repository.insert(makeDefinition(id: secondID, title: "저녁", category: .evening, startMinutes: 20 * 60))
        try repository.insert(makeDefinition(title: "비활성", isActive: false))

        let fetched = try repository.fetchActive()
        let fetchedIDs = Set(fetched.map(\.id))

        XCTAssertEqual(fetched.count, 2)
        XCTAssertEqual(fetchedIDs, Set([firstID, secondID]))
    }

    // MARK: - Deactivate

    func testDeactivateSetsIsActiveToFalse() throws {
        let container = try makeContainer()
        let repository = makeRepository(container: container)
        let id = UUID()

        try repository.insert(makeDefinition(id: id))
        try repository.deactivate(id: id)

        let active = try repository.fetchActive()
        XCTAssertTrue(active.isEmpty)

        let descriptor = FetchDescriptor<RecurringRhythmEntity>(
            predicate: #Predicate { $0.id == id }
        )
        let stored = try ModelContext(container).fetch(descriptor).first
        XCTAssertEqual(stored?.isActive, false)
    }

    func testDeactivatePreservesAllOtherStoredFields() throws {
        let container = try makeContainer()
        let repository = makeRepository(container: container)
        let id = UUID()
        let startDate = makeStartDate()

        try repository.insert(
            makeDefinition(
                id: id,
                title: "야간 휴식",
                category: .rest,
                startMinutes: 23 * 60,
                durationMinutes: 120,
                recurrence: .weekends,
                startDate: startDate,
                reminderMinutes: 15,
                isActive: true
            )
        )

        try repository.deactivate(id: id)

        let descriptor = FetchDescriptor<RecurringRhythmEntity>(
            predicate: #Predicate { $0.id == id }
        )
        let stored = try ModelContext(container).fetch(descriptor).first

        XCTAssertEqual(stored?.id, id)
        XCTAssertEqual(stored?.title, "야간 휴식")
        XCTAssertEqual(stored?.categoryRawValue, RoutineCategory.rest.rawValue)
        XCTAssertEqual(stored?.startMinutes, 23 * 60)
        XCTAssertEqual(stored?.durationMinutes, 120)
        XCTAssertEqual(stored?.recurrenceRawValue, RecurrenceRule.weekends.rawValue)
        XCTAssertEqual(stored?.startDate, startDate)
        XCTAssertEqual(stored?.reminderMinutes, 15)
        XCTAssertEqual(stored?.isActive, false)
    }

    func testDeactivateThrowsForUnknownID() throws {
        let container = try makeContainer()
        let repository = makeRepository(container: container)

        XCTAssertThrowsError(try repository.deactivate(id: UUID())) { error in
            guard case .recurringRhythmNotFound? = error as? RecurringRhythmRepositoryError else {
                XCTFail("Expected RecurringRhythmRepositoryError.recurringRhythmNotFound, got \(error)")
                return
            }
        }
    }

    func testDeactivateAlreadyInactiveDefinitionSucceedsAndRemainsInactive() throws {
        let container = try makeContainer()
        let repository = makeRepository(container: container)
        let id = UUID()

        try repository.insert(makeDefinition(id: id, isActive: false))
        try repository.deactivate(id: id)

        let descriptor = FetchDescriptor<RecurringRhythmEntity>(
            predicate: #Predicate { $0.id == id }
        )
        let stored = try ModelContext(container).fetch(descriptor).first
        XCTAssertEqual(stored?.isActive, false)
    }

    // MARK: - Mapping integrity

    func testInsertedRecurrenceRawValuesAndComputedMappingRemainIntact() throws {
        let container = try makeContainer()
        let repository = makeRepository(container: container)

        for rule in RecurrenceRule.allCases {
            try repository.insert(
                makeDefinition(
                    title: rule.rawValue,
                    recurrence: rule
                )
            )
        }

        let fetched = try repository.fetchActive()
        XCTAssertEqual(fetched.count, RecurrenceRule.allCases.count)

        for rule in RecurrenceRule.allCases {
            let match = fetched.first { $0.recurrenceRawValue == rule.rawValue }
            XCTAssertNotNil(match)
            XCTAssertEqual(match?.recurrence, rule)
        }
    }

    // MARK: - Persistence across contexts

    func testOperationsPersistAcrossFreshModelContextFromSameContainer() throws {
        let container = try makeContainer()
        let writer = makeRepository(container: container)
        let id = UUID()

        try writer.insert(
            makeDefinition(
                id: id,
                title: "컨텍스트 공유",
                recurrence: .weekdays
            )
        )

        let reader = makeRepository(container: container)
        let fetched = try reader.fetchActive()

        XCTAssertEqual(fetched.count, 1)
        XCTAssertEqual(fetched.first?.id, id)
        XCTAssertEqual(fetched.first?.title, "컨텍스트 공유")
        XCTAssertEqual(fetched.first?.recurrence, .weekdays)

        try reader.deactivate(id: id)

        let afterDeactivate = try makeRepository(container: container).fetchActive()
        XCTAssertTrue(afterDeactivate.isEmpty)
    }
}
