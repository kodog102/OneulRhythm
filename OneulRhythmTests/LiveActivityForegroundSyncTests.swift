//
//  LiveActivityForegroundSyncTests.swift
//  OneulRhythmTests
//
//  Sprint 21-11 — foreground-sync policy (Option A). No ActivityKit timing.
//

import XCTest
@testable import OneulRhythm

@MainActor
final class LiveActivityForegroundSyncTests: XCTestCase {
    private var calendar: Calendar = {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(identifier: "Asia/Seoul")!
        return calendar
    }()

    private let dayStart: Date = {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(identifier: "Asia/Seoul")!
        return calendar.date(
            from: DateComponents(year: 2026, month: 7, day: 28, hour: 0, minute: 0)
        )!
    }()

    // MARK: - ViewModel → sync (launch / active catch-up)

    func testLoadRoutinesInvokesLiveActivitySync() throws {
        let focusID = UUID()
        let start = date(hour: 12, minute: 0)
        let end = date(hour: 12, minute: 30)
        let entity = RoutineEntity(
            id: focusID,
            title: "아침 스트레칭",
            startTime: start,
            endTime: end,
            category: .morning,
            status: .upcoming
        )
        let repo = SyncTestRoutineRepository(routines: [entity])
        let recorder = RecordingLiveActivityCoordinator()
        var now = date(hour: 12, minute: 10)
        let viewModel = TodayViewModel(
            repository: repo,
            liveActivityCoordinator: recorder,
            nowProvider: { now },
            calendar: calendar
        )

        viewModel.loadRoutines()
        XCTAssertEqual(recorder.syncCount, 1)
        XCTAssertEqual(recorder.lastSnapshot?.phase, .active)
        XCTAssertEqual(recorder.lastSnapshot?.primaryRhythm?.id, focusID)

        // Scene-active style catch-up after a missed end.
        now = date(hour: 12, minute: 45)
        viewModel.loadRoutines()
        XCTAssertEqual(recorder.syncCount, 2)
        XCTAssertEqual(recorder.lastSnapshot?.phase, .overdue)
        XCTAssertEqual(recorder.lastSnapshot?.primaryRole, .pastIncomplete)
        XCTAssertEqual(recorder.lastSnapshot?.primaryRhythm?.id, focusID)
    }

    func testForegroundAfterMissedNextStartSelectsNextRhythm() throws {
        let pastID = UUID()
        let nextID = UUID()
        let past = RoutineEntity(
            id: pastID,
            title: "지난",
            startTime: date(hour: 10, minute: 0),
            endTime: date(hour: 10, minute: 30),
            category: .morning,
            status: .upcoming
        )
        let next = RoutineEntity(
            id: nextID,
            title: "다음",
            startTime: date(hour: 14, minute: 0),
            endTime: date(hour: 14, minute: 30),
            category: .movement,
            status: .upcoming
        )
        let repo = SyncTestRoutineRepository(routines: [past, next])
        let recorder = RecordingLiveActivityCoordinator()
        // Between past end and next start — then after next start.
        var now = date(hour: 12, minute: 0)
        let viewModel = TodayViewModel(
            repository: repo,
            liveActivityCoordinator: recorder,
            nowProvider: { now },
            calendar: calendar
        )
        viewModel.loadRoutines()
        XCTAssertEqual(recorder.lastSnapshot?.phase, .overdue)

        now = date(hour: 14, minute: 10)
        viewModel.loadRoutines()
        XCTAssertEqual(recorder.lastSnapshot?.phase, .active)
        XCTAssertEqual(recorder.lastSnapshot?.primaryRhythm?.id, nextID)
        XCTAssertEqual(recorder.lastSnapshot?.primaryRole, .current)
    }

    // MARK: - Mapper catch-up ContentState

    func testMapperAfterMissedFocusEndProducesOverdue() {
        let start = date(hour: 12, minute: 0)
        let end = date(hour: 12, minute: 30)
        let routine = makeRoutine(id: UUID(), title: "포커스", start: start, end: end)
        let now = date(hour: 12, minute: 45)
        let schedule = RoutineScheduleEngine().resolve(
            routines: [routine],
            now: now,
            calendar: calendar
        )
        let snapshot = TodayRhythmSnapshot(schedule: schedule, date: now)
        let payload = TodayRhythmActivityMapper.map(
            snapshot: snapshot,
            calendar: calendar,
            updatedAt: now
        )

        XCTAssertEqual(payload?.contentState.phase, .overdue)
        XCTAssertEqual(payload?.contentState.focusRoutineID, routine.id.uuidString)
    }

    func testSameFocusIDWithChangedPhaseStillMapsDistinctContent() {
        let id = UUID()
        let start = date(hour: 12, minute: 0)
        let end = date(hour: 12, minute: 30)
        let routine = makeRoutine(id: id, title: "포커스", start: start, end: end)

        let during = date(hour: 12, minute: 10)
        let after = date(hour: 12, minute: 45)
        let activePayload = map(routines: [routine], now: during)
        let overduePayload = map(routines: [routine], now: after)

        XCTAssertEqual(activePayload?.contentState.focusRoutineID, id.uuidString)
        XCTAssertEqual(overduePayload?.contentState.focusRoutineID, id.uuidString)
        XCTAssertEqual(activePayload?.contentState.phase, .active)
        XCTAssertEqual(overduePayload?.contentState.phase, .overdue)
        XCTAssertNotEqual(activePayload?.contentState, overduePayload?.contentState)
    }

    // MARK: - Reconcile planner (no ActivityKit)

    func testDayCompleteEndsActivityWithoutRequest() {
        let payload = dayCompletePayload(updatedAt: date(hour: 18, minute: 0))
        let session = LiveActivitySessionDescriptor(
            id: "a1",
            dayID: payload.attributes.dayID,
            phase: .active,
            updatedAt: date(hour: 12, minute: 0),
            isEligible: true
        )
        let commands = LiveActivityReconcilePlanner.plan(
            desiredPayload: payload,
            sessions: [session]
        )
        XCTAssertTrue(commands.contains { command in
            if case .endDayComplete(let ids, _) = command {
                return ids == ["a1"]
            }
            return false
        })
        XCTAssertFalse(commands.contains { if case .request = $0 { return true }; return false })
        XCTAssertFalse(commands.contains { if case .update = $0 { return true }; return false })
    }

    func testLaterIncompleteRhythmRequestsNewActivity() {
        let start = date(hour: 19, minute: 0)
        let end = date(hour: 19, minute: 30)
        let routine = makeRoutine(id: UUID(), title: "저녁", start: start, end: end)
        let now = date(hour: 19, minute: 10)
        let payload = map(routines: [routine], now: now)
        XCTAssertNotNil(payload)
        XCTAssertEqual(payload?.contentState.phase, .active)

        let commands = LiveActivityReconcilePlanner.plan(
            desiredPayload: payload,
            sessions: []
        )
        XCTAssertTrue(commands.contains { if case .request = $0 { return true }; return false })
    }

    func testSameRhythmChangedPhaseStillPlansUpdate() {
        let start = date(hour: 12, minute: 0)
        let end = date(hour: 12, minute: 30)
        let routine = makeRoutine(id: UUID(), title: "포커스", start: start, end: end)
        let overduePayload = map(routines: [routine], now: date(hour: 12, minute: 45))!
        let session = LiveActivitySessionDescriptor(
            id: "canon",
            dayID: overduePayload.attributes.dayID,
            phase: .active,
            updatedAt: date(hour: 12, minute: 10),
            isEligible: true
        )
        let commands = LiveActivityReconcilePlanner.plan(
            desiredPayload: overduePayload,
            sessions: [session]
        )
        guard case let .update(id, content) = commands.last else {
            return XCTFail("Expected update command")
        }
        XCTAssertEqual(id, "canon")
        XCTAssertEqual(content.phase, .overdue)
        XCTAssertEqual(content.focusRoutineID, routine.id.uuidString)
    }

    func testEmptySnapshotEndsAllEligible() {
        let commands = LiveActivityReconcilePlanner.plan(
            desiredPayload: nil,
            sessions: [
                LiveActivitySessionDescriptor(
                    id: "a1",
                    dayID: "2026-07-28",
                    phase: .active,
                    updatedAt: date(hour: 12, minute: 0),
                    isEligible: true
                )
            ]
        )
        XCTAssertEqual(commands, [.endAllEligible])
    }

    // MARK: - Presentation bridge

    func testActivePastFocusEndRendersCompletedWithoutSelectingNext() {
        let start = date(hour: 12, minute: 0)
        let end = date(hour: 12, minute: 30)
        let nextStart = date(hour: 14, minute: 0)
        let state = TodayRhythmActivityAttributes.ContentState(
            phase: .active,
            focusRoutineID: "focus",
            focusTitle: "포커스",
            focusCategoryRawValue: "focus",
            focusStart: start,
            focusEnd: end,
            nextRoutineID: "next",
            nextTitle: "다음 리듬",
            nextCategoryRawValue: "movement",
            nextStart: nextStart,
            updatedAt: start
        )
        let now = date(hour: 12, minute: 45)
        let decision = TodayRhythmLivePresentationPolicy.evaluate(
            contentState: state,
            now: now
        )
        let visual = LiveActivityStateAccent.resolve(
            state: state,
            decision: decision,
            now: now
        )

        XCTAssertEqual(visual, .completed)
        XCTAssertEqual(decision.primaryFocus, .focusRhythm)
        XCTAssertNotEqual(decision.primaryFocus, .nextRhythm)
        XCTAssertEqual(
            TodayRhythmLiveActivityCopy.primaryTitle(state: state, decision: decision),
            "포커스"
        )
    }

    // MARK: - Platform policy invariants

    func testProductionCoordinatorSourceKeepsLocalPushTypeNil() throws {
        let sourceURL = URL(fileURLWithPath: #filePath)
            .deletingLastPathComponent()
            .deletingLastPathComponent()
            .appendingPathComponent("OneulRhythm/Services/LiveActivityCoordinator.swift")
        let source = try String(contentsOf: sourceURL, encoding: .utf8)
        XCTAssertTrue(source.contains("pushType: nil"))
        XCTAssertFalse(source.contains("BGTaskScheduler"))
        XCTAssertFalse(source.contains("BGAppRefreshTask"))
        XCTAssertFalse(source.contains("beginBackgroundTask"))
    }

    func testRequestFailurePathIsBestEffort() {
        // Coordinator catches Activity.request errors; planner still emits `.request`
        // without trapping. This documents the no-crash contract for the plan layer.
        let start = date(hour: 12, minute: 0)
        let end = date(hour: 12, minute: 30)
        let routine = makeRoutine(id: UUID(), title: "포커스", start: start, end: end)
        let payload = map(routines: [routine], now: date(hour: 12, minute: 10))
        let commands = LiveActivityReconcilePlanner.plan(
            desiredPayload: payload,
            sessions: []
        )
        XCTAssertEqual(commands.filter { if case .request = $0 { return true }; return false }.count, 1)
    }

    // MARK: - Helpers

    private func map(routines: [Routine], now: Date) -> TodayRhythmActivityPayload? {
        let schedule = RoutineScheduleEngine().resolve(
            routines: routines,
            now: now,
            calendar: calendar
        )
        let snapshot = TodayRhythmSnapshot(schedule: schedule, date: now)
        return TodayRhythmActivityMapper.map(
            snapshot: snapshot,
            calendar: calendar,
            updatedAt: now
        )
    }

    private func dayCompletePayload(updatedAt: Date) -> TodayRhythmActivityPayload {
        let attributes = TodayRhythmActivityAttributes(
            dayID: "2026-07-28",
            calendarDayStart: dayStart
        )
        let content = TodayRhythmActivityAttributes.ContentState(
            phase: .dayComplete,
            focusRoutineID: nil,
            focusTitle: nil,
            focusCategoryRawValue: nil,
            focusStart: nil,
            focusEnd: nil,
            nextRoutineID: nil,
            nextTitle: nil,
            nextCategoryRawValue: nil,
            nextStart: nil,
            updatedAt: updatedAt
        )
        return TodayRhythmActivityPayload(attributes: attributes, contentState: content)
    }

    private func makeRoutine(
        id: UUID,
        title: String,
        start: Date,
        end: Date
    ) -> Routine {
        Routine(
            id: id,
            title: title,
            startTime: start,
            endTime: end,
            category: .morning,
            status: .upcoming,
            reminderMinutes: nil
        )
    }

    private func date(hour: Int, minute: Int) -> Date {
        calendar.date(
            bySettingHour: hour,
            minute: minute,
            second: 0,
            of: dayStart
        )!
    }
}

@MainActor
private final class RecordingLiveActivityCoordinator: LiveActivityCoordinating {
    private(set) var syncCount = 0
    private(set) var lastSnapshot: TodayRhythmSnapshot?

    func sync(snapshot: TodayRhythmSnapshot) {
        syncCount += 1
        lastSnapshot = snapshot
    }

    func end() {}
}

@MainActor
private final class SyncTestRoutineRepository: RoutineRepository {
    private let routines: [RoutineEntity]

    init(routines: [RoutineEntity]) {
        self.routines = routines
    }

    func fetchRoutines() throws -> [RoutineEntity] { routines }
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
