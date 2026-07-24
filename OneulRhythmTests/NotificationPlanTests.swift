//
//  NotificationPlanTests.swift
//  OneulRhythmTests
//

import XCTest
@testable import OneulRhythm

final class NotificationPlanTests: XCTestCase {
    // MARK: - Empty plan

    func testEmptyPlanHasNoItems() {
        let plan = NotificationPlan()

        XCTAssertTrue(plan.items.isEmpty)
        XCTAssertEqual(plan, NotificationPlan(items: []))
    }

    // MARK: - Equality

    func testPlansWithIdenticalItemsAreEqual() {
        let date = Date(timeIntervalSince1970: 1_753_315_200)
        let item = NotificationPlanItem(
            identifier: "id-1",
            title: "리듬 시작",
            body: "\"산책\" 리듬을 시작할 시간이에요.",
            triggerDate: date
        )

        let lhs = NotificationPlan(items: [item])
        let rhs = NotificationPlan(items: [item])

        XCTAssertEqual(lhs, rhs)
        XCTAssertEqual(lhs.items.first, rhs.items.first)
    }

    func testPlansWithDifferentItemsAreNotEqual() {
        let date = Date(timeIntervalSince1970: 1_753_315_200)
        let lhs = NotificationPlan(
            items: [
                NotificationPlanItem(
                    identifier: "id-1",
                    title: "리듬 시작",
                    body: "\"산책\" 리듬을 시작할 시간이에요.",
                    triggerDate: date
                )
            ]
        )
        let rhs = NotificationPlan(
            items: [
                NotificationPlanItem(
                    identifier: "id-2",
                    title: "리듬 시작",
                    body: "\"산책\" 리듬을 시작할 시간이에요.",
                    triggerDate: date
                )
            ]
        )

        XCTAssertNotEqual(lhs, rhs)
    }

    // MARK: - Item integrity

    func testItemPreservesAllFields() {
        let date = Date(timeIntervalSince1970: 1_753_315_200)
        let item = NotificationPlanItem(
            identifier: "ABC-123",
            title: "리듬 시작",
            body: "\"집중\" 리듬을 시작할 시간이에요.",
            triggerDate: date
        )

        XCTAssertEqual(item.identifier, "ABC-123")
        XCTAssertEqual(item.title, "리듬 시작")
        XCTAssertEqual(item.body, "\"집중\" 리듬을 시작할 시간이에요.")
        XCTAssertEqual(item.triggerDate, date)
    }
}
