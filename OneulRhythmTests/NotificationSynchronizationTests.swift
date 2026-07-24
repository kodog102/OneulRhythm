//
//  NotificationSynchronizationTests.swift
//  OneulRhythmTests
//

import XCTest
@testable import OneulRhythm

final class NotificationSynchronizationTests: XCTestCase {
    private let title = "리듬 시작"

    // MARK: - Helpers

    private func item(
        id: String,
        title: String? = nil,
        body: String? = nil,
        trigger: Date
    ) -> NotificationPlanItem {
        NotificationPlanItem(
            identifier: id,
            title: title ?? self.title,
            body: body ?? "\"리듬\" 리듬을 시작할 시간이에요.",
            triggerDate: trigger
        )
    }

    private func pending(
        id: String,
        title: String? = nil,
        body: String? = nil,
        trigger: Date?
    ) -> PendingNotificationRequest {
        PendingNotificationRequest(
            identifier: id,
            title: title ?? self.title,
            body: body ?? "\"리듬\" 리듬을 시작할 시간이에요.",
            triggerDate: trigger
        )
    }

    // MARK: - Empty pending

    func testEmptyPendingSchedulesAllDesiredItems() {
        let earlier = Date(timeIntervalSince1970: 1_753_315_200)
        let later = Date(timeIntervalSince1970: 1_753_318_800)
        let plan = NotificationPlan(
            items: [
                item(id: "b", trigger: later),
                item(id: "a", trigger: earlier)
            ]
        )

        let changes = NotificationSynchronization.changes(
            desired: plan,
            pending: []
        )

        XCTAssertEqual(
            changes,
            [
                .schedule(item(id: "a", trigger: earlier)),
                .schedule(item(id: "b", trigger: later))
            ]
        )
    }

    // MARK: - Already synchronized

    func testAlreadySynchronizedProducesNoChanges() {
        let trigger = Date(timeIntervalSince1970: 1_753_315_200)
        let desired = item(id: "a", trigger: trigger)
        let plan = NotificationPlan(items: [desired])
        let pending = [
            pending(id: "a", trigger: trigger)
        ]

        let changes = NotificationSynchronization.changes(
            desired: plan,
            pending: pending
        )

        XCTAssertTrue(changes.isEmpty)
    }

    // MARK: - Trigger update

    func testTriggerUpdateRemovesThenSchedules() {
        let oldTrigger = Date(timeIntervalSince1970: 1_753_315_200)
        let newTrigger = Date(timeIntervalSince1970: 1_753_318_800)
        let desired = item(id: "a", trigger: newTrigger)
        let plan = NotificationPlan(items: [desired])
        let pending = [
            pending(id: "a", trigger: oldTrigger)
        ]

        let changes = NotificationSynchronization.changes(
            desired: plan,
            pending: pending
        )

        XCTAssertEqual(
            changes,
            [
                .remove(identifier: "a"),
                .schedule(desired)
            ]
        )
    }

    // MARK: - Notification removal

    func testNotificationRemovedFromPlanCancelsPending() {
        let trigger = Date(timeIntervalSince1970: 1_753_315_200)
        let plan = NotificationPlan(items: [])
        let pending = [
            pending(id: "a", trigger: trigger)
        ]

        let changes = NotificationSynchronization.changes(
            desired: plan,
            pending: pending
        )

        XCTAssertEqual(changes, [.remove(identifier: "a")])
    }

    // MARK: - Notification addition

    func testNotificationAddedSchedulesOnlyNewItem() {
        let existingTrigger = Date(timeIntervalSince1970: 1_753_315_200)
        let newTrigger = Date(timeIntervalSince1970: 1_753_318_800)
        let existing = item(id: "a", trigger: existingTrigger)
        let added = item(id: "b", trigger: newTrigger)
        let plan = NotificationPlan(items: [existing, added])
        let pending = [
            pending(id: "a", trigger: existingTrigger)
        ]

        let changes = NotificationSynchronization.changes(
            desired: plan,
            pending: pending
        )

        XCTAssertEqual(changes, [.schedule(added)])
    }

    // MARK: - Mixed synchronization

    func testMixedSynchronizationPerformsMinimalOperations() {
        let keepTrigger = Date(timeIntervalSince1970: 1_753_315_200)
        let oldTrigger = Date(timeIntervalSince1970: 1_753_316_000)
        let updatedTrigger = Date(timeIntervalSince1970: 1_753_317_000)
        let addTrigger = Date(timeIntervalSince1970: 1_753_318_800)

        let keep = item(id: "keep", trigger: keepTrigger)
        let updated = item(id: "update", trigger: updatedTrigger)
        let added = item(id: "add", trigger: addTrigger)

        let plan = NotificationPlan(items: [keep, updated, added])
        let pending = [
            pending(id: "keep", trigger: keepTrigger),
            pending(id: "update", trigger: oldTrigger),
            pending(id: "remove", trigger: keepTrigger)
        ]

        let changes = NotificationSynchronization.changes(
            desired: plan,
            pending: pending
        )

        XCTAssertEqual(
            changes,
            [
                .remove(identifier: "remove"),
                .remove(identifier: "update"),
                .schedule(updated),
                .schedule(added)
            ]
        )
    }

    // MARK: - Content mismatch

    func testTitleOrBodyMismatchTreatedAsUpdate() {
        let trigger = Date(timeIntervalSince1970: 1_753_315_200)
        let desired = item(
            id: "a",
            body: "\"새 제목\" 리듬을 시작할 시간이에요.",
            trigger: trigger
        )
        let plan = NotificationPlan(items: [desired])
        let pending = [
            pending(
                id: "a",
                body: "\"옛 제목\" 리듬을 시작할 시간이에요.",
                trigger: trigger
            )
        ]

        let changes = NotificationSynchronization.changes(
            desired: plan,
            pending: pending
        )

        XCTAssertEqual(
            changes,
            [
                .remove(identifier: "a"),
                .schedule(desired)
            ]
        )
    }

    // MARK: - Empty both

    func testEmptyDesiredAndEmptyPendingProducesNoChanges() {
        let changes = NotificationSynchronization.changes(
            desired: NotificationPlan(),
            pending: []
        )

        XCTAssertTrue(changes.isEmpty)
    }
}
