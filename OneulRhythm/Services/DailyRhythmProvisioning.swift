//
//  DailyRhythmProvisioning.swift
//  OneulRhythm
//

import Foundation

/// Application-facing boundary for provisioning recurring daily rhythms.
///
/// Lifecycle surfaces (e.g. `DailyRhythmSyncCoordinator`) depend on this
/// protocol rather than the concrete provisioner.
@MainActor
protocol DailyRhythmProvisioning {
    func provision(for date: Date) throws
}
