//
//  AppLaunchStateTests.swift
//  OneulRhythmTests
//

import XCTest
@testable import OneulRhythm

@MainActor
final class AppLaunchStateTests: XCTestCase {
    func testStartsIncomplete() {
        let state = AppLaunchState()

        XCTAssertFalse(state.didCompleteInitialRhythmSync)
    }

    func testBecomesCompleteWhenMarked() {
        let state = AppLaunchState()

        state.completeInitialRhythmSync()

        XCTAssertTrue(state.didCompleteInitialRhythmSync)
    }

    func testRemainsCompleteOnRepeatedMarking() {
        let state = AppLaunchState()

        state.completeInitialRhythmSync()
        state.completeInitialRhythmSync()

        XCTAssertTrue(state.didCompleteInitialRhythmSync)
    }
}
