//
//  FirstRhythmJourneyProgressTests.swift
//  OneulRhythmTests
//

import XCTest
@testable import OneulRhythm

@MainActor
final class FirstRhythmJourneyProgressTests: XCTestCase {
    private var suiteName: String!
    private var defaults: UserDefaults!

    override func setUp() {
        super.setUp()
        suiteName = "oneulRhythm.tests.firstRhythmJourney.\(UUID().uuidString)"
        defaults = UserDefaults(suiteName: suiteName)
        defaults.removePersistentDomain(forName: suiteName)
    }

    override func tearDown() {
        defaults.removePersistentDomain(forName: suiteName)
        defaults = nil
        suiteName = nil
        super.tearDown()
    }

    func testFreshDefaultsRemainFirstJourney() {
        let progress = FirstRhythmJourneyProgress(defaults: defaults)

        XCTAssertFalse(progress.hasCompletedFirstRhythmJourney)
    }

    func testMarkFirstRhythmCreatedCompletesJourney() {
        let progress = FirstRhythmJourneyProgress(defaults: defaults)

        progress.markFirstRhythmCreated()

        XCTAssertTrue(progress.hasCompletedFirstRhythmJourney)
    }

    func testCompletionPersistsAcrossRelaunch() {
        let firstLaunch = FirstRhythmJourneyProgress(defaults: defaults)
        firstLaunch.markFirstRhythmCreated()

        let relaunched = FirstRhythmJourneyProgress(defaults: defaults)

        XCTAssertTrue(relaunched.hasCompletedFirstRhythmJourney)
    }

    func testMarkIsIdempotent() {
        let progress = FirstRhythmJourneyProgress(defaults: defaults)

        progress.markFirstRhythmCreated()
        progress.markFirstRhythmCreated()

        XCTAssertTrue(progress.hasCompletedFirstRhythmJourney)
        XCTAssertTrue(
            defaults.bool(forKey: FirstRhythmJourneyProgress.storageKey)
        )
    }

    func testCompletionIsIndependentOfRoutineCount() {
        // Completion is preference-backed, not inferred from stored rhythms.
        let progress = FirstRhythmJourneyProgress(defaults: defaults)
        progress.markFirstRhythmCreated()

        // Simulate “all rhythms deleted” — preference must stay completed.
        let afterDeletion = FirstRhythmJourneyProgress(defaults: defaults)

        XCTAssertTrue(afterDeletion.hasCompletedFirstRhythmJourney)
    }
}
