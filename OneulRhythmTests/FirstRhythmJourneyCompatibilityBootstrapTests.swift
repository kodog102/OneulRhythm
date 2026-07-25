//
//  FirstRhythmJourneyCompatibilityBootstrapTests.swift
//  OneulRhythmTests
//

import XCTest
@testable import OneulRhythm

@MainActor
final class FirstRhythmJourneyCompatibilityBootstrapTests: XCTestCase {
    private var suiteName: String!
    private var defaults: UserDefaults!

    override func setUp() {
        super.setUp()
        suiteName = "oneulRhythm.tests.firstRhythmBootstrap.\(UUID().uuidString)"
        defaults = UserDefaults(suiteName: suiteName)
        defaults.removePersistentDomain(forName: suiteName)
    }

    override func tearDown() {
        defaults.removePersistentDomain(forName: suiteName)
        defaults = nil
        suiteName = nil
        super.tearDown()
    }

    func testIncompleteJourneyWithNoExistingDataRemainsFirstJourney() throws {
        let progress = FirstRhythmJourneyProgress(defaults: defaults)

        try FirstRhythmJourneyCompatibilityBootstrap.applyIfNeeded(
            progress: progress,
            routineRepository: StubRoutineRepository(routines: []),
            recurringRhythmRepository: StubRecurringRhythmRepository(definitions: [])
        )

        XCTAssertFalse(progress.hasCompletedFirstRhythmJourney)
    }

    func testIncompleteJourneyWithExistingOneTimeRoutineBecomesComplete() throws {
        let progress = FirstRhythmJourneyProgress(defaults: defaults)

        try FirstRhythmJourneyCompatibilityBootstrap.applyIfNeeded(
            progress: progress,
            routineRepository: StubRoutineRepository(routines: [makeRoutineEntity()]),
            recurringRhythmRepository: StubRecurringRhythmRepository(definitions: [])
        )

        XCTAssertTrue(progress.hasCompletedFirstRhythmJourney)
    }

    func testIncompleteJourneyWithExistingRecurringDefinitionBecomesComplete() throws {
        let progress = FirstRhythmJourneyProgress(defaults: defaults)

        try FirstRhythmJourneyCompatibilityBootstrap.applyIfNeeded(
            progress: progress,
            routineRepository: StubRoutineRepository(routines: []),
            recurringRhythmRepository: StubRecurringRhythmRepository(
                definitions: [makeRecurringDefinition()]
            )
        )

        XCTAssertTrue(progress.hasCompletedFirstRhythmJourney)
    }

    func testAlreadyCompleteJourneyWithNoDataRemainsComplete() throws {
        let progress = FirstRhythmJourneyProgress(defaults: defaults)
        progress.markFirstRhythmCreated()

        try FirstRhythmJourneyCompatibilityBootstrap.applyIfNeeded(
            progress: progress,
            routineRepository: StubRoutineRepository(routines: []),
            recurringRhythmRepository: StubRecurringRhythmRepository(definitions: [])
        )

        XCTAssertTrue(progress.hasCompletedFirstRhythmJourney)
    }

    func testBootstrapCalledRepeatedlyRemainsIdempotent() throws {
        let progress = FirstRhythmJourneyProgress(defaults: defaults)
        let routines = StubRoutineRepository(routines: [makeRoutineEntity()])
        let recurring = StubRecurringRhythmRepository(definitions: [])

        try FirstRhythmJourneyCompatibilityBootstrap.applyIfNeeded(
            progress: progress,
            routineRepository: routines,
            recurringRhythmRepository: recurring
        )
        try FirstRhythmJourneyCompatibilityBootstrap.applyIfNeeded(
            progress: progress,
            routineRepository: routines,
            recurringRhythmRepository: recurring
        )

        XCTAssertTrue(progress.hasCompletedFirstRhythmJourney)
        XCTAssertTrue(defaults.bool(forKey: FirstRhythmJourneyProgress.storageKey))
    }

    func testExistingDataDeletedAfterBootstrapRemainsComplete() throws {
        let progress = FirstRhythmJourneyProgress(defaults: defaults)

        try FirstRhythmJourneyCompatibilityBootstrap.applyIfNeeded(
            progress: progress,
            routineRepository: StubRoutineRepository(routines: [makeRoutineEntity()]),
            recurringRhythmRepository: StubRecurringRhythmRepository(definitions: [])
        )

        // Simulate delete-all after bootstrap — preference must stay complete.
        try FirstRhythmJourneyCompatibilityBootstrap.applyIfNeeded(
            progress: progress,
            routineRepository: StubRoutineRepository(routines: []),
            recurringRhythmRepository: StubRecurringRhythmRepository(definitions: [])
        )

        let relaunched = FirstRhythmJourneyProgress(defaults: defaults)
        XCTAssertTrue(relaunched.hasCompletedFirstRhythmJourney)
    }

    func testReadFailureDoesNotMarkCompletion() {
        let progress = FirstRhythmJourneyProgress(defaults: defaults)

        XCTAssertThrowsError(
            try FirstRhythmJourneyCompatibilityBootstrap.applyIfNeeded(
                progress: progress,
                routineRepository: StubRoutineRepository(error: StubBootstrapError.readFailed),
                recurringRhythmRepository: StubRecurringRhythmRepository(definitions: [])
            )
        )

        XCTAssertFalse(progress.hasCompletedFirstRhythmJourney)
    }

    // MARK: - Fixtures

    private func makeRoutineEntity() -> RoutineEntity {
        RoutineEntity(
            title: "물 마시기",
            startTime: Date(timeIntervalSince1970: 1_700_000_000),
            category: .morning,
            status: .upcoming
        )
    }

    private func makeRecurringDefinition() -> RecurringRhythmEntity {
        RecurringRhythmEntity(
            title: "아침 스트레칭",
            category: .morning,
            startMinutes: 7 * 60,
            durationMinutes: 15,
            recurrence: .daily,
            startDate: Date(timeIntervalSince1970: 1_700_000_000),
            isActive: true
        )
    }
}

// MARK: - Stubs

private enum StubBootstrapError: Error {
    case readFailed
}

@MainActor
private final class StubRoutineRepository: RoutineRepository {
    private let routines: [RoutineEntity]
    private let error: Error?

    init(routines: [RoutineEntity] = [], error: Error? = nil) {
        self.routines = routines
        self.error = error
    }

    func fetchRoutines() throws -> [RoutineEntity] {
        if let error { throw error }
        return routines
    }

    func insert(_ input: RoutineCreationInput) throws {}
    func insert(_ routine: RoutineEntity) throws {}
    func update(_ input: RoutineCreationInput) throws {}
    func clearRecurrenceMetadata(id: UUID) throws {}
    func updateStatus(id: UUID, status: RoutineStatus) throws {}
    func delete(_ routine: RoutineEntity) throws {}
    func delete(id: UUID) throws {}
    func hasOccurrence(recurringRhythmID: UUID, occurrenceDate: Date) throws -> Bool {
        false
    }
}

@MainActor
private final class StubRecurringRhythmRepository: RecurringRhythmRepository {
    private let definitions: [RecurringRhythmEntity]
    private let error: Error?

    init(definitions: [RecurringRhythmEntity] = [], error: Error? = nil) {
        self.definitions = definitions
        self.error = error
    }

    func insert(_ definition: RecurringRhythmEntity) throws {}

    func fetchActive() throws -> [RecurringRhythmEntity] {
        if let error { throw error }
        return definitions
    }

    func update(
        id: UUID,
        title: String,
        category: RoutineCategory,
        startMinutes: Int,
        durationMinutes: Int,
        recurrence: RecurrenceRule,
        reminderMinutes: Int?
    ) throws {}

    func deactivate(id: UUID) throws {}
}
