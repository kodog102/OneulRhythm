//
//  DailyRhythmProvisionerTests.swift
//  OneulRhythmTests
//

import XCTest
@testable import OneulRhythm

@MainActor
final class DailyRhythmProvisionerTests: XCTestCase {
    // MARK: - Helpers

    private func makeCalendar() -> Calendar {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(identifier: "Asia/Seoul")!
        return calendar
    }

    private func makeDayPolicy() -> CalendarDayPolicy {
        CalendarDayPolicy(calendar: makeCalendar())
    }

    private func makeDate(
        year: Int = 2026,
        month: Int = 7,
        day: Int,
        hour: Int = 0,
        minute: Int = 0
    ) -> Date {
        let calendar = makeCalendar()
        var components = DateComponents()
        components.year = year
        components.month = month
        components.day = day
        components.hour = hour
        components.minute = minute
        return calendar.date(from: components)!
    }

    private func makeDefinition(
        id: UUID = UUID(),
        title: String,
        category: RoutineCategory = .morning,
        startMinutes: Int = 9 * 60,
        durationMinutes: Int = 30,
        recurrence: RecurrenceRule,
        startDate: Date,
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
            startDate: startDate,
            reminderMinutes: reminderMinutes,
            isActive: isActive
        )
    }

    private func makeProvisioner(
        recurring: SpyRecurringRhythmRepository,
        routines: SpyRoutineRepository,
        dayPolicy: CalendarDayPolicy? = nil
    ) -> DailyRhythmProvisioner {
        let policy = dayPolicy ?? makeDayPolicy()
        return DailyRhythmProvisioner(
            recurringRhythmRepository: recurring,
            routineRepository: routines,
            recurrenceEngine: RecurrenceEngine(dayPolicy: policy),
            dateTimeMaterializer: OccurrenceDateTimeMaterializer(dayPolicy: policy)
        )
    }

    // MARK: - Orchestration

    func testNoOccurrenceSkipsInsert() throws {
        let startDate = makeDate(day: 13) // Monday
        let saturday = makeDate(day: 18) // Weekend
        let definition = makeDefinition(
            title: "평일만",
            recurrence: .weekdays,
            startDate: startDate
        )

        let recurring = SpyRecurringRhythmRepository(active: [definition])
        let routines = SpyRoutineRepository()
        let provisioner = makeProvisioner(recurring: recurring, routines: routines)

        try provisioner.provision(for: saturday)

        XCTAssertEqual(recurring.fetchActiveCallCount, 1)
        XCTAssertEqual(routines.hasOccurrenceCalls.count, 0)
        XCTAssertEqual(routines.insertedRoutines.count, 0)
    }

    func testDuplicateSkipsInsert() throws {
        let startDate = makeDate(day: 13)
        let wednesday = makeDate(day: 15, hour: 12)
        let definitionID = UUID()
        let definition = makeDefinition(
            id: definitionID,
            title: "집중",
            recurrence: .weekdays,
            startDate: startDate
        )

        let dayPolicy = makeDayPolicy()
        let occurrenceDate = dayPolicy.day(for: wednesday)

        let recurring = SpyRecurringRhythmRepository(active: [definition])
        let routines = SpyRoutineRepository(
            existingOccurrences: [(definitionID, occurrenceDate)]
        )
        let provisioner = makeProvisioner(
            recurring: recurring,
            routines: routines,
            dayPolicy: dayPolicy
        )

        try provisioner.provision(for: wednesday)

        XCTAssertEqual(recurring.fetchActiveCallCount, 1)
        XCTAssertEqual(routines.hasOccurrenceCalls.count, 1)
        XCTAssertEqual(
            routines.hasOccurrenceCalls.first?.recurringRhythmID,
            definitionID
        )
        XCTAssertEqual(
            routines.hasOccurrenceCalls.first?.occurrenceDate,
            occurrenceDate
        )
        XCTAssertEqual(routines.insertedRoutines.count, 0)
    }

    func testSuccessfulCreationInsertsRoutine() throws {
        let startDate = makeDate(day: 13)
        let wednesday = makeDate(day: 15, hour: 8)
        let definitionID = UUID()
        let definition = makeDefinition(
            id: definitionID,
            title: "아침 스트레칭",
            category: .morning,
            startMinutes: 7 * 60,
            durationMinutes: 30,
            recurrence: .daily,
            startDate: startDate,
            reminderMinutes: 5
        )

        let dayPolicy = makeDayPolicy()
        let recurring = SpyRecurringRhythmRepository(active: [definition])
        let routines = SpyRoutineRepository()
        let provisioner = makeProvisioner(
            recurring: recurring,
            routines: routines,
            dayPolicy: dayPolicy
        )

        try provisioner.provision(for: wednesday)

        XCTAssertEqual(routines.insertedRoutines.count, 1)
        let inserted = try XCTUnwrap(routines.insertedRoutines.first)
        XCTAssertEqual(inserted.title, "아침 스트레칭")
        XCTAssertEqual(inserted.categoryRawValue, RoutineCategory.morning.rawValue)
        XCTAssertEqual(inserted.statusRawValue, RoutineStatus.upcoming.rawValue)
        XCTAssertEqual(inserted.reminderMinutes, 5)
        XCTAssertEqual(inserted.recurringRhythmID, definitionID)
        XCTAssertEqual(inserted.occurrenceDate, dayPolicy.day(for: wednesday))
        XCTAssertEqual(
            inserted.startTime,
            makeDate(day: 15, hour: 7)
        )
        XCTAssertEqual(
            inserted.endTime,
            makeDate(day: 15, hour: 7, minute: 30)
        )
    }

    func testMultipleRecurringRhythmsInsertApplicableOnes() throws {
        let startDate = makeDate(day: 13)
        let saturday = makeDate(day: 18, hour: 10)

        let weekdayOnly = makeDefinition(
            id: UUID(),
            title: "평일",
            recurrence: .weekdays,
            startDate: startDate
        )
        let weekendOnly = makeDefinition(
            id: UUID(),
            title: "주말",
            category: .rest,
            startMinutes: 10 * 60,
            durationMinutes: 45,
            recurrence: .weekends,
            startDate: startDate
        )
        let daily = makeDefinition(
            id: UUID(),
            title: "매일",
            category: .focus,
            startMinutes: 8 * 60,
            durationMinutes: 20,
            recurrence: .daily,
            startDate: startDate
        )

        let recurring = SpyRecurringRhythmRepository(
            active: [weekdayOnly, weekendOnly, daily]
        )
        let routines = SpyRoutineRepository()
        let provisioner = makeProvisioner(recurring: recurring, routines: routines)

        try provisioner.provision(for: saturday)

        let insertedTitles = Set(routines.insertedRoutines.map(\.title))
        XCTAssertEqual(insertedTitles, Set(["주말", "매일"]))
        XCTAssertEqual(routines.hasOccurrenceCalls.count, 2)
        XCTAssertEqual(routines.insertedRoutines.count, 2)
    }

    func testInactiveRhythmsIgnoredBecauseFetchActiveIsUsed() throws {
        // Provisioner only calls fetchActive(); inactive definitions never enter
        // the orchestration loop when the repository honors that contract.
        let startDate = makeDate(day: 13)
        let wednesday = makeDate(day: 15)

        let inactive = makeDefinition(
            title: "비활성",
            recurrence: .daily,
            startDate: startDate,
            isActive: false
        )
        let active = makeDefinition(
            title: "활성",
            recurrence: .daily,
            startDate: startDate,
            isActive: true
        )

        let recurring = SpyRecurringRhythmRepository(
            active: [active],
            allDefinitionsIncludingInactive: [inactive, active]
        )
        let routines = SpyRoutineRepository()
        let provisioner = makeProvisioner(recurring: recurring, routines: routines)

        try provisioner.provision(for: wednesday)

        XCTAssertEqual(recurring.fetchActiveCallCount, 1)
        XCTAssertEqual(routines.insertedRoutines.count, 1)
        XCTAssertEqual(routines.insertedRoutines.first?.title, "활성")
        XCTAssertFalse(routines.insertedRoutines.contains { $0.title == "비활성" })
    }

    func testFetchActiveCalledOnce() throws {
        let startDate = makeDate(day: 13)
        let definitions = [
            makeDefinition(title: "A", recurrence: .daily, startDate: startDate),
            makeDefinition(title: "B", recurrence: .daily, startDate: startDate),
        ]

        let recurring = SpyRecurringRhythmRepository(active: definitions)
        let routines = SpyRoutineRepository()
        let provisioner = makeProvisioner(recurring: recurring, routines: routines)

        try provisioner.provision(for: makeDate(day: 15))

        XCTAssertEqual(recurring.fetchActiveCallCount, 1)
    }

    func testEngineAndMaterializerProduceExpectedOccurrenceMetadata() throws {
        let startDate = makeDate(day: 13)
        let requested = makeDate(day: 15, hour: 22, minute: 45)
        let definitionID = UUID()
        let definition = makeDefinition(
            id: definitionID,
            title: "저녁",
            category: .evening,
            startMinutes: 20 * 60,
            durationMinutes: 40,
            recurrence: .daily,
            startDate: startDate,
            reminderMinutes: 15
        )

        let dayPolicy = makeDayPolicy()
        let recurring = SpyRecurringRhythmRepository(active: [definition])
        let routines = SpyRoutineRepository()
        let provisioner = makeProvisioner(
            recurring: recurring,
            routines: routines,
            dayPolicy: dayPolicy
        )

        try provisioner.provision(for: requested)

        let inserted = try XCTUnwrap(routines.insertedRoutines.first)
        let expectedOccurrenceDate = dayPolicy.day(for: requested)

        // Engine planned for the requested day; materializer projected wall times.
        XCTAssertEqual(inserted.recurringRhythmID, definitionID)
        XCTAssertEqual(inserted.occurrenceDate, expectedOccurrenceDate)
        XCTAssertEqual(inserted.startTime, makeDate(day: 15, hour: 20))
        XCTAssertEqual(inserted.endTime, makeDate(day: 15, hour: 20, minute: 40))
        XCTAssertEqual(
            routines.hasOccurrenceCalls.first?.occurrenceDate,
            expectedOccurrenceDate
        )
    }

    func testInsertCalledOnlyWhenNeeded() throws {
        let startDate = makeDate(day: 13)
        let wednesday = makeDate(day: 15)
        let dayPolicy = makeDayPolicy()
        let occurrenceDate = dayPolicy.day(for: wednesday)

        let existingID = UUID()
        let newID = UUID()

        let existingDefinition = makeDefinition(
            id: existingID,
            title: "이미 있음",
            recurrence: .daily,
            startDate: startDate
        )
        let newDefinition = makeDefinition(
            id: newID,
            title: "새로 생성",
            recurrence: .daily,
            startDate: startDate
        )
        let nonApplicable = makeDefinition(
            title: "주말만",
            recurrence: .weekends,
            startDate: startDate
        )

        let recurring = SpyRecurringRhythmRepository(
            active: [existingDefinition, newDefinition, nonApplicable]
        )
        let routines = SpyRoutineRepository(
            existingOccurrences: [(existingID, occurrenceDate)]
        )
        let provisioner = makeProvisioner(
            recurring: recurring,
            routines: routines,
            dayPolicy: dayPolicy
        )

        try provisioner.provision(for: wednesday)

        // hasOccurrence only for planned daily occurrences (2), insert only for new.
        XCTAssertEqual(routines.hasOccurrenceCalls.count, 2)
        XCTAssertEqual(routines.insertedRoutines.count, 1)
        XCTAssertEqual(routines.insertedRoutines.first?.title, "새로 생성")
        XCTAssertEqual(routines.insertedRoutines.first?.recurringRhythmID, newID)
    }
}

// MARK: - Spies

@MainActor
private final class SpyRecurringRhythmRepository: RecurringRhythmRepository {
    private let active: [RecurringRhythmEntity]
    private(set) var fetchActiveCallCount = 0

    /// Available for documentation/assertions; provisioner never receives these
    /// unless included in `active`.
    let allDefinitionsIncludingInactive: [RecurringRhythmEntity]

    init(
        active: [RecurringRhythmEntity],
        allDefinitionsIncludingInactive: [RecurringRhythmEntity] = []
    ) {
        self.active = active
        self.allDefinitionsIncludingInactive = allDefinitionsIncludingInactive.isEmpty
            ? active
            : allDefinitionsIncludingInactive
    }

    func insert(_ definition: RecurringRhythmEntity) throws {}

    func fetchActive() throws -> [RecurringRhythmEntity] {
        fetchActiveCallCount += 1
        return active
    }

    func deactivate(id: UUID) throws {}
}

@MainActor
private final class SpyRoutineRepository: RoutineRepository {
    private var existingOccurrences: Set<OccurrenceKey>
    private(set) var hasOccurrenceCalls: [(recurringRhythmID: UUID, occurrenceDate: Date)] = []
    private(set) var insertedRoutines: [RoutineEntity] = []

    init(existingOccurrences: [(UUID, Date)] = []) {
        self.existingOccurrences = Set(
            existingOccurrences.map { OccurrenceKey(id: $0.0, date: $0.1) }
        )
    }

    func fetchRoutines() throws -> [RoutineEntity] { insertedRoutines }

    func insert(_ input: RoutineCreationInput) throws {}

    func insert(_ routine: RoutineEntity) throws {
        insertedRoutines.append(routine)
        if let recurringRhythmID = routine.recurringRhythmID,
           let occurrenceDate = routine.occurrenceDate {
            existingOccurrences.insert(
                OccurrenceKey(id: recurringRhythmID, date: occurrenceDate)
            )
        }
    }

    func updateStatus(id: UUID, status: RoutineStatus) throws {}
    func delete(_ routine: RoutineEntity) throws {}

    func hasOccurrence(
        recurringRhythmID: UUID,
        occurrenceDate: Date
    ) throws -> Bool {
        hasOccurrenceCalls.append((recurringRhythmID, occurrenceDate))
        return existingOccurrences.contains(
            OccurrenceKey(id: recurringRhythmID, date: occurrenceDate)
        )
    }
}

private struct OccurrenceKey: Hashable {
    let id: UUID
    let date: Date
}
