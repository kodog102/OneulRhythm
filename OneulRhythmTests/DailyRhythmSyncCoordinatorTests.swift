//
//  DailyRhythmSyncCoordinatorTests.swift
//  OneulRhythmTests
//

import XCTest
@testable import OneulRhythm

@MainActor
final class DailyRhythmSyncCoordinatorTests: XCTestCase {
    func testInitPerformsNoWork() {
        let spy = SpyDailyRhythmProvisioning()
        _ = DailyRhythmSyncCoordinator(provisioner: spy)

        XCTAssertEqual(spy.provisionCallCount, 0)
        XCTAssertTrue(spy.provisionedDates.isEmpty)
    }

    func testSyncCallsProvisionExactlyOnce() throws {
        let spy = SpyDailyRhythmProvisioning()
        let coordinator = DailyRhythmSyncCoordinator(provisioner: spy)
        let date = Date(timeIntervalSince1970: 1_700_000_000)

        try coordinator.sync(for: date)

        XCTAssertEqual(spy.provisionCallCount, 1)
    }

    func testSyncForwardsSuppliedDateUnchanged() throws {
        let spy = SpyDailyRhythmProvisioning()
        let coordinator = DailyRhythmSyncCoordinator(provisioner: spy)
        let date = Date(timeIntervalSince1970: 1_800_000_123.456)

        try coordinator.sync(for: date)

        XCTAssertEqual(spy.provisionedDates, [date])
    }

    func testSyncPropagatesErrors() {
        let spy = SpyDailyRhythmProvisioning(error: SpyProvisioningError.failed)
        let coordinator = DailyRhythmSyncCoordinator(provisioner: spy)
        let date = Date(timeIntervalSince1970: 1_700_000_000)

        XCTAssertThrowsError(try coordinator.sync(for: date)) { error in
            guard let provisioningError = error as? SpyProvisioningError,
                  case .failed = provisioningError else {
                XCTFail("Expected SpyProvisioningError.failed, got \(error)")
                return
            }
        }
        XCTAssertEqual(spy.provisionCallCount, 1)
        XCTAssertEqual(spy.provisionedDates, [date])
    }
}

// MARK: - Spies

private enum SpyProvisioningError: Error {
    case failed
}

@MainActor
private final class SpyDailyRhythmProvisioning: DailyRhythmProvisioning {
    private let error: Error?
    private(set) var provisionCallCount = 0
    private(set) var provisionedDates: [Date] = []

    init(error: Error? = nil) {
        self.error = error
    }

    func provision(for date: Date) throws {
        provisionCallCount += 1
        provisionedDates.append(date)
        if let error {
            throw error
        }
    }
}
