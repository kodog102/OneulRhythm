//
//  ManagementVisualQATests.swift
//  OneulRhythmTests
//
//  Renders Management preview states for visual QA artifacts.
//

import SwiftUI
import UIKit
import XCTest
@testable import OneulRhythm

@MainActor
final class ManagementVisualQATests: XCTestCase {
    private let calendar: Calendar = {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(identifier: "Asia/Seoul")!
        return calendar
    }()

    private lazy var now: Date = {
        var components = DateComponents()
        components.year = 2026
        components.month = 7
        components.day = 26
        components.hour = 10
        components.minute = 0
        return calendar.date(from: components)!
    }()

    private lazy var dayPolicy = CalendarDayPolicy(calendar: calendar)

    private var artifactsDirectory: URL {
        URL(fileURLWithPath: #filePath)
            .deletingLastPathComponent()
            .deletingLastPathComponent()
            .appendingPathComponent(".qa-artifacts/management-ux", isDirectory: true)
    }

    func testRenderManagementVisualStates() throws {
        guard ProcessInfo.processInfo.environment["MANAGEMENT_VISUAL_QA"] == "1" else {
            throw XCTSkip("Set MANAGEMENT_VISUAL_QA=1 to generate Management visual QA artifacts.")
        }

        try FileManager.default.createDirectory(
            at: artifactsDirectory,
            withIntermediateDirectories: true
        )

        try snapshot(
            name: "03-empty",
            view: makeView(routines: [], recurring: [])
        )
        try snapshot(
            name: "04-recurring-only",
            view: makeView(
                routines: [],
                recurring: [
                    recurring("아침 독서", startMinutes: 7 * 60 + 30, recurrence: .daily),
                    recurring("저녁 산책", startMinutes: 20 * 60, recurrence: .weekdays)
                ]
            )
        )
        try snapshot(
            name: "05-one-time-only",
            view: makeView(
                routines: [
                    oneTime("병원 방문", startTime: today(hour: 14, minute: 0)),
                    oneTime("친구 약속", startTime: tomorrow(hour: 11, minute: 30))
                ],
                recurring: []
            )
        )
        try snapshot(
            name: "06-mixed",
            view: makeView(
                routines: [
                    oneTime("도서관", startTime: today(hour: 16, minute: 0))
                ],
                recurring: [
                    recurring("아침 스트레칭", startMinutes: 7 * 60, recurrence: .daily),
                    recurring("주말 산책", startMinutes: 10 * 60, recurrence: .weekends)
                ]
            )
        )
        try snapshot(
            name: "07-single-item",
            view: makeView(
                routines: [],
                recurring: [
                    recurring("따뜻한 차 한잔", startMinutes: 7 * 60 + 30, recurrence: .daily)
                ]
            )
        )
        try snapshot(
            name: "08-many-items",
            view: makeView(
                routines: (0..<4).map { index in
                    oneTime("예정 \(index + 1)", startTime: today(hour: 12 + index, minute: 0))
                },
                recurring: (0..<8).map { index in
                    recurring(
                        "반복 리듬 \(index + 1)",
                        startMinutes: (6 + index) * 60,
                        recurrence: index.isMultiple(of: 2) ? .daily : .weekdays
                    )
                }
            )
        )
        try snapshot(
            name: "09-long-title",
            view: makeView(
                routines: [
                    oneTime(
                        "아주 길고 자세한 오늘의 특별 일정 이름인데도 자연스럽게 줄바꿈되어야 해요",
                        startTime: today(hour: 15, minute: 0)
                    )
                ],
                recurring: [
                    recurring(
                        "아침부터 저녁까지 이어지는 아주 긴 반복 리듬 제목도 잘려 보이지 않아야 합니다",
                        startMinutes: 8 * 60,
                        recurrence: .daily
                    )
                ]
            )
        )
        try snapshot(
            name: "10-dynamic-type-xxx",
            view: makeView(
                routines: [
                    oneTime("병원", startTime: today(hour: 14, minute: 0))
                ],
                recurring: [
                    recurring("아침 독서", startMinutes: 7 * 60 + 30, recurrence: .daily)
                ]
            )
            .environment(\.sizeCategory, .accessibilityExtraExtraExtraLarge)
        )
        try snapshot(
            name: "11-dark-mode",
            view: makeView(
                routines: [
                    oneTime("저녁 모임", startTime: today(hour: 19, minute: 0))
                ],
                recurring: [
                    recurring("아침 독서", startMinutes: 7 * 60 + 30, recurrence: .daily)
                ]
            )
            .preferredColorScheme(.dark)
        )
        try snapshot(
            name: "12-small-width",
            view: makeView(
                routines: [
                    oneTime("약속", startTime: tomorrow(hour: 19, minute: 0))
                ],
                recurring: [
                    recurring("아침 스트레칭", startMinutes: 7 * 60, recurrence: .daily),
                    recurring("저녁 정리", startMinutes: 21 * 60, recurrence: .weekdays)
                ]
            ),
            size: CGSize(width: 320, height: 568)
        )
    }

    private func snapshot<V: View>(
        name: String,
        view: V,
        size: CGSize = CGSize(width: 390, height: 844)
    ) throws {
        let root = NavigationStack { view }
            .frame(width: size.width, height: size.height)
            .background(ORColors.background)

        let host = UIHostingController(rootView: root)
        host.view.bounds = CGRect(origin: .zero, size: size)
        host.view.backgroundColor = UIColor(ORColors.background)

        let window = UIWindow(frame: CGRect(origin: .zero, size: size))
        window.rootViewController = host
        window.makeKeyAndVisible()

        host.view.setNeedsLayout()
        host.view.layoutIfNeeded()

        // Allow List / NavigationStack to settle one run-loop turn.
        let settle = expectation(description: "settle-\(name)")
        DispatchQueue.main.async {
            settle.fulfill()
        }
        wait(for: [settle], timeout: 1.0)
        host.view.setNeedsLayout()
        host.view.layoutIfNeeded()

        let format = UIGraphicsImageRendererFormat()
        format.scale = 2
        format.opaque = true
        let renderer = UIGraphicsImageRenderer(size: size, format: format)
        let image = renderer.image { _ in
            host.view.drawHierarchy(in: host.view.bounds, afterScreenUpdates: true)
        }

        window.isHidden = true
        window.rootViewController = nil

        guard let data = image.pngData() else {
            XCTFail("Failed to encode \(name)")
            return
        }

        let url = artifactsDirectory.appendingPathComponent("\(name).png")
        try data.write(to: url)
    }

    private func makeView(
        routines: [RoutineEntity],
        recurring: [RecurringRhythmEntity]
    ) -> RoutineManagementView {
        RoutineManagementView(
            repository: VisualQARoutineRepository(entities: routines),
            recurringRhythmRepository: VisualQARecurringRepository(definitions: recurring),
            onSaveRoutine: { _ in },
            onUpdateRoutine: { _ in },
            onDeleteRoutine: { _ in },
            nowProvider: { self.now },
            dayPolicy: dayPolicy
        )
    }

    private func today(hour: Int, minute: Int) -> Date {
        calendar.date(bySettingHour: hour, minute: minute, second: 0, of: now) ?? now
    }

    private func tomorrow(hour: Int, minute: Int) -> Date {
        let day = calendar.date(byAdding: .day, value: 1, to: now) ?? now
        return calendar.date(bySettingHour: hour, minute: minute, second: 0, of: day) ?? day
    }

    private func recurring(
        _ title: String,
        startMinutes: Int,
        recurrence: RecurrenceRule
    ) -> RecurringRhythmEntity {
        RecurringRhythmEntity(
            title: title,
            category: .morning,
            startMinutes: startMinutes,
            durationMinutes: 30,
            recurrence: recurrence,
            startDate: calendar.startOfDay(for: now),
            isActive: true
        )
    }

    private func oneTime(_ title: String, startTime: Date) -> RoutineEntity {
        RoutineEntity(
            routine: Routine(
                title: title,
                startTime: startTime,
                endTime: startTime.addingTimeInterval(30 * 60),
                category: .focus,
                status: .upcoming
            )
        )
    }
}

@MainActor
private final class VisualQARoutineRepository: RoutineRepository {
    private var entities: [RoutineEntity]

    init(entities: [RoutineEntity]) {
        self.entities = entities
    }

    func fetchRoutines() throws -> [RoutineEntity] { entities }
    func insert(_ input: RoutineCreationInput) throws {}
    func insert(_ routine: RoutineEntity) throws { entities.append(routine) }
    func update(_ input: RoutineCreationInput) throws {}
    func clearRecurrenceMetadata(id: UUID) throws {}
    func updateStatus(id: UUID, status: RoutineStatus) throws {}
    func delete(_ routine: RoutineEntity) throws {
        entities.removeAll { $0.id == routine.id }
    }
    func delete(id: UUID) throws {
        entities.removeAll { $0.id == id }
    }
    func hasOccurrence(
        recurringRhythmID: UUID,
        occurrenceDate: Date
    ) throws -> Bool {
        false
    }
}

@MainActor
private final class VisualQARecurringRepository: RecurringRhythmRepository {
    private let definitions: [RecurringRhythmEntity]

    init(definitions: [RecurringRhythmEntity]) {
        self.definitions = definitions
    }

    func insert(_ definition: RecurringRhythmEntity) throws {}
    func fetchActive() throws -> [RecurringRhythmEntity] {
        definitions.filter(\.isActive)
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
