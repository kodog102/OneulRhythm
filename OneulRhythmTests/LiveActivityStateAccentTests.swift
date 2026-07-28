//
//  LiveActivityStateAccentTests.swift
//  OneulRhythmTests
//
//  Sprint 21-9 — unified visual-state policy.
//

import XCTest
@testable import OneulRhythm

final class LiveActivityStateAccentTests: XCTestCase {
    private let base: Date = {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(identifier: "Asia/Seoul")!
        return calendar.date(
            from: DateComponents(year: 2026, month: 7, day: 28, hour: 12, minute: 0)
        )!
    }()

    private func resolve(
        _ state: TodayRhythmActivityAttributes.ContentState,
        now: Date
    ) -> LiveActivityStateAccent {
        LiveActivityStateAccent.resolve(state: state, now: now)
    }

    // MARK: - Scheduled

    func testUpcomingNextRhythmIsScheduledNotPaused() {
        let state = TodayRhythmActivityAttributes.ContentState(
            phase: .upcoming,
            focusRoutineID: nil,
            focusTitle: nil,
            focusCategoryRawValue: nil,
            focusStart: nil,
            focusEnd: nil,
            nextRoutineID: "next",
            nextTitle: "가벼운 산책",
            nextCategoryRawValue: "movement",
            nextStart: base.addingTimeInterval(30 * 60),
            updatedAt: base
        )
        let visual = resolve(state, now: base)
        XCTAssertEqual(visual, .scheduled)
        XCTAssertEqual(visual.statusLabel, "시작 전")
        XCTAssertNotEqual(visual.statusLabel, "일시정지")
    }

    func testBetweenRhythmsNextIsScheduled() {
        let state = TodayRhythmActivityAttributes.ContentState(
            phase: .betweenRhythms,
            focusRoutineID: nil,
            focusTitle: nil,
            focusCategoryRawValue: nil,
            focusStart: nil,
            focusEnd: nil,
            nextRoutineID: "next",
            nextTitle: "가벼운 산책",
            nextCategoryRawValue: "movement",
            nextStart: base.addingTimeInterval(10 * 60),
            updatedAt: base
        )
        XCTAssertEqual(resolve(state, now: base), .scheduled)
    }

    // MARK: - Running / near / completed

    func testExactStartIsRunningForLongRhythm() {
        let start = base
        let end = base.addingTimeInterval(30 * 60)
        let state = activeState(start: start, end: end)
        XCTAssertEqual(resolve(state, now: start), .running)
    }

    func testOneMinuteRhythmHasMeaningfulRunningPeriod() {
        let start = base
        let end = base.addingTimeInterval(60)
        let state = activeState(start: start, end: end)

        XCTAssertEqual(resolve(state, now: start), .running)
        XCTAssertEqual(resolve(state, now: start.addingTimeInterval(20)), .running)
        XCTAssertEqual(resolve(state, now: start.addingTimeInterval(30)), .running)

        // Last portion only (20% of 60s = 12s, after min running window).
        let nearStart = end.addingTimeInterval(
            -LiveActivityNearCompletionPolicy.effectiveNearWindow(totalDuration: 60)
        )
        XCTAssertEqual(resolve(state, now: nearStart), .nearCompletion)
        XCTAssertEqual(resolve(state, now: end.addingTimeInterval(-1)), .nearCompletion)
    }

    func testFiveMinuteRhythmDoesNotStartNearCompletion() {
        let start = base
        let end = base.addingTimeInterval(5 * 60)
        let state = activeState(start: start, end: end)
        XCTAssertEqual(resolve(state, now: start), .running)
        XCTAssertEqual(resolve(state, now: start.addingTimeInterval(60)), .running)
        // Near window = min(5m, 5m*0.2) = 1m
        XCTAssertEqual(resolve(state, now: end.addingTimeInterval(-60)), .nearCompletion)
        XCTAssertEqual(resolve(state, now: end.addingTimeInterval(-61)), .running)
    }

    func testThirtyMinuteRhythmUsesCappedNearWindow() {
        let start = base
        let end = base.addingTimeInterval(30 * 60)
        let state = activeState(start: start, end: end)
        let nearWindow = LiveActivityNearCompletionPolicy.effectiveNearWindow(
            totalDuration: 30 * 60
        )
        XCTAssertEqual(nearWindow, 5 * 60, accuracy: 0.001)
        XCTAssertEqual(resolve(state, now: end.addingTimeInterval(-5 * 60)), .nearCompletion)
        XCTAssertEqual(resolve(state, now: end.addingTimeInterval(-5 * 60 - 1)), .running)
    }

    func testExactFocusEndIsCompleted() {
        let start = base.addingTimeInterval(-30 * 60)
        let end = base
        let state = activeState(start: start, end: end)
        XCTAssertEqual(resolve(state, now: end), .completed)
        XCTAssertEqual(resolve(state, now: end).statusLabel, "완료")
    }

    func testAfterFocusEndIsCompleted() {
        let start = base.addingTimeInterval(-30 * 60)
        let end = base
        let state = activeState(start: start, end: end)
        XCTAssertEqual(resolve(state, now: end.addingTimeInterval(1)), .completed)
    }

    func testOverduePhaseIsCompleted() {
        let start = base.addingTimeInterval(-30 * 60)
        let end = base
        let state = TodayRhythmActivityAttributes.ContentState(
            phase: .overdue,
            focusRoutineID: "focus",
            focusTitle: "아침 스트레칭",
            focusCategoryRawValue: "morning",
            focusStart: start,
            focusEnd: end,
            nextRoutineID: nil,
            nextTitle: nil,
            nextCategoryRawValue: nil,
            nextStart: nil,
            updatedAt: end
        )
        XCTAssertEqual(resolve(state, now: end.addingTimeInterval(10 * 60)), .completed)
    }

    func testCompletedDoesNotRegressToNearOrRunning() {
        let start = base.addingTimeInterval(-30 * 60)
        let end = base
        let activePastEnd = activeState(start: start, end: end)
        XCTAssertEqual(resolve(activePastEnd, now: end.addingTimeInterval(30)), .completed)

        let overdue = TodayRhythmActivityAttributes.ContentState(
            phase: .overdue,
            focusRoutineID: "focus",
            focusTitle: "아침 스트레칭",
            focusCategoryRawValue: "morning",
            focusStart: start,
            focusEnd: end,
            nextRoutineID: nil,
            nextTitle: nil,
            nextCategoryRawValue: nil,
            nextStart: nil,
            updatedAt: end
        )
        // Even if clock were somehow earlier, overdue phase stays completed.
        XCTAssertEqual(resolve(overdue, now: start), .completed)
    }

    func testResolveNeverEmitsPaused() {
        let upcoming = TodayRhythmActivityAttributes.ContentState(
            phase: .upcoming,
            focusRoutineID: nil,
            focusTitle: nil,
            focusCategoryRawValue: nil,
            focusStart: nil,
            focusEnd: nil,
            nextRoutineID: "next",
            nextTitle: "산책",
            nextCategoryRawValue: "movement",
            nextStart: base.addingTimeInterval(60),
            updatedAt: base
        )
        let between = TodayRhythmActivityAttributes.ContentState(
            phase: .betweenRhythms,
            focusRoutineID: nil,
            focusTitle: nil,
            focusCategoryRawValue: nil,
            focusStart: nil,
            focusEnd: nil,
            nextRoutineID: "next",
            nextTitle: "산책",
            nextCategoryRawValue: "movement",
            nextStart: base.addingTimeInterval(60),
            updatedAt: base
        )
        XCTAssertNotEqual(resolve(upcoming, now: base), .paused)
        XCTAssertNotEqual(resolve(between, now: base), .paused)
    }

    func testStatusAccentAgreement() {
        let start = base
        let end = base.addingTimeInterval(30 * 60)
        let state = activeState(start: start, end: end)
        let visual = resolve(state, now: start.addingTimeInterval(10 * 60))
        XCTAssertEqual(visual, .running)
        XCTAssertEqual(visual.statusLabel, "진행 중")
        XCTAssertEqual(visual.color, LiveActivityStateAccent.running.color)
    }

    func testVeryShortDurationNeverEntirelyNearCompletion() {
        let start = base
        let end = base.addingTimeInterval(20)
        let state = activeState(start: start, end: end)
        let window = LiveActivityNearCompletionPolicy.effectiveNearWindow(totalDuration: 20)
        XCTAssertEqual(window, 0, accuracy: 0.001)
        XCTAssertEqual(resolve(state, now: start), .running)
        XCTAssertEqual(resolve(state, now: start.addingTimeInterval(10)), .running)
        XCTAssertEqual(resolve(state, now: end), .completed)
    }

    // MARK: - Helpers

    private func activeState(
        start: Date,
        end: Date
    ) -> TodayRhythmActivityAttributes.ContentState {
        TodayRhythmActivityAttributes.ContentState(
            phase: .active,
            focusRoutineID: "focus",
            focusTitle: "아침 스트레칭",
            focusCategoryRawValue: "morning",
            focusStart: start,
            focusEnd: end,
            nextRoutineID: nil,
            nextTitle: nil,
            nextCategoryRawValue: nil,
            nextStart: nil,
            updatedAt: start
        )
    }
}
