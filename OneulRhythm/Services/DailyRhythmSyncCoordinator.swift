//
//  DailyRhythmSyncCoordinator.swift
//  OneulRhythm
//

import Foundation

/// Boundary between application lifecycle and daily rhythm provisioning.
///
/// Forwards a caller-supplied date to `DailyRhythmProvisioning` without
/// interpreting calendars, fetching data, or owning refresh policy.
@MainActor
final class DailyRhythmSyncCoordinator {
    private let provisioner: DailyRhythmProvisioning

    init(provisioner: DailyRhythmProvisioning) {
        self.provisioner = provisioner
    }

    /// Synchronizes recurring daily rhythms for the supplied date.
    func sync(for date: Date) throws {
        try provisioner.provision(for: date)
    }
}
