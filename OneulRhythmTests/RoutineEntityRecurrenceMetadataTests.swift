//
//  RoutineEntityRecurrenceMetadataTests.swift
//  OneulRhythmTests
//

import XCTest
@testable import OneulRhythm

final class RoutineEntityRecurrenceMetadataTests: XCTestCase {
    // MARK: - Helpers

    private func makeOccurrenceDate() -> Date {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(identifier: "Asia/Seoul")!

        var components = DateComponents()
        components.year = 2026
        components.month = 7
        components.day = 15
        components.hour = 0
        return calendar.date(from: components)!
    }

    private func makeStartTime() -> Date {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(identifier: "Asia/Seoul")!

        var components = DateComponents()
        components.year = 2026
        components.month = 7
        components.day = 15
        components.hour = 9
        components.minute = 0
        return calendar.date(from: components)!
    }

    // MARK: - One-time defaults

    func testOneTimeRoutineEntityDefaultsRecurringRhythmIDToNil() {
        let entity = RoutineEntity(
            title: "아침 루틴",
            startTime: makeStartTime(),
            category: .morning,
            status: .upcoming
        )

        XCTAssertNil(entity.recurringRhythmID)
    }

    func testOneTimeRoutineEntityDefaultsOccurrenceDateToNil() {
        let entity = RoutineEntity(
            title: "아침 루틴",
            startTime: makeStartTime(),
            category: .morning,
            status: .upcoming
        )

        XCTAssertNil(entity.occurrenceDate)
    }

    // MARK: - Explicit recurrence origin

    func testRoutineEntityAcceptsExplicitRecurringRhythmID() {
        let recurringID = UUID()
        let entity = RoutineEntity(
            title: "집중 시간",
            startTime: makeStartTime(),
            category: .focus,
            status: .upcoming,
            recurringRhythmID: recurringID
        )

        XCTAssertEqual(entity.recurringRhythmID, recurringID)
    }

    func testRoutineEntityAcceptsExplicitOccurrenceDate() {
        let occurrenceDate = makeOccurrenceDate()
        let entity = RoutineEntity(
            title: "집중 시간",
            startTime: makeStartTime(),
            category: .focus,
            status: .upcoming,
            occurrenceDate: occurrenceDate
        )

        XCTAssertEqual(entity.occurrenceDate, occurrenceDate)
    }

    // MARK: - Mapping round trip

    func testRecurrenceOriginFieldsSurviveEntityDomainMappingRoundTrip() {
        let recurringID = UUID()
        let occurrenceDate = makeOccurrenceDate()
        let startTime = makeStartTime()

        let original = RoutineEntity(
            title: "저녁 산책",
            startTime: startTime,
            endTime: startTime.addingTimeInterval(40 * 60),
            category: .evening,
            status: .upcoming,
            reminderMinutes: 10,
            recurringRhythmID: recurringID,
            occurrenceDate: occurrenceDate
        )

        let domain = original.toDomain()
        let rematerialized = RoutineEntity(routine: domain, reminderMinutes: original.reminderMinutes)

        XCTAssertEqual(domain.recurringRhythmID, recurringID)
        XCTAssertEqual(domain.occurrenceDate, occurrenceDate)
        XCTAssertEqual(rematerialized.recurringRhythmID, recurringID)
        XCTAssertEqual(rematerialized.occurrenceDate, occurrenceDate)
    }

    func testUpdatingStatusPreservesRecurrenceOriginMetadata() {
        let recurringID = UUID()
        let occurrenceDate = makeOccurrenceDate()

        let routine = Routine(
            title: "야간 휴식",
            startTime: makeStartTime(),
            endTime: nil,
            category: .rest,
            status: .upcoming,
            recurringRhythmID: recurringID,
            occurrenceDate: occurrenceDate
        )

        let completed = routine.updatingStatus(.completed)

        XCTAssertEqual(completed.recurringRhythmID, recurringID)
        XCTAssertEqual(completed.occurrenceDate, occurrenceDate)
        XCTAssertEqual(completed.status, .completed)
    }

    /// Mirrors `SwiftDataRoutineRepository.updateStatus`: completion updates
    /// mutate status in place and must not clear recurrence-origin fields.
    func testInPlaceStatusUpdateDoesNotEraseRecurrenceOriginMetadata() {
        let recurringID = UUID()
        let occurrenceDate = makeOccurrenceDate()

        let entity = RoutineEntity(
            title: "집중 시간",
            startTime: makeStartTime(),
            category: .focus,
            status: .upcoming,
            recurringRhythmID: recurringID,
            occurrenceDate: occurrenceDate
        )

        entity.statusRawValue = RoutineStatus.completed.rawValue
        entity.updatedAt = Date()

        XCTAssertEqual(entity.recurringRhythmID, recurringID)
        XCTAssertEqual(entity.occurrenceDate, occurrenceDate)
        XCTAssertEqual(entity.statusRawValue, RoutineStatus.completed.rawValue)
    }

    // MARK: - Existing initialization compatibility

    func testExistingOneTimeInitializationBehaviorRemainsUnchanged() {
        let id = UUID()
        let startTime = makeStartTime()
        let createdAt = Date(timeIntervalSince1970: 1_700_000_000)
        let updatedAt = Date(timeIntervalSince1970: 1_700_000_100)

        let entity = RoutineEntity(
            id: id,
            title: "운동",
            startTime: startTime,
            endTime: startTime.addingTimeInterval(30 * 60),
            category: .movement,
            status: .upcoming,
            reminderMinutes: 5,
            createdAt: createdAt,
            updatedAt: updatedAt
        )

        XCTAssertEqual(entity.id, id)
        XCTAssertEqual(entity.title, "운동")
        XCTAssertEqual(entity.startTime, startTime)
        XCTAssertEqual(entity.endTime, startTime.addingTimeInterval(30 * 60))
        XCTAssertEqual(entity.categoryRawValue, RoutineCategory.movement.rawValue)
        XCTAssertEqual(entity.statusRawValue, RoutineStatus.upcoming.rawValue)
        XCTAssertEqual(entity.reminderMinutes, 5)
        XCTAssertEqual(entity.createdAt, createdAt)
        XCTAssertEqual(entity.updatedAt, updatedAt)
        XCTAssertNil(entity.recurringRhythmID)
        XCTAssertNil(entity.occurrenceDate)
    }
}
