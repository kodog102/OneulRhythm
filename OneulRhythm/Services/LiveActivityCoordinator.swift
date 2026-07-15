//
//  LiveActivityCoordinator.swift
//  OneulRhythm
//

import Foundation

/// Placeholder coordinator for the one-day Live Activity lifecycle.
///
/// Does not talk to ActivityKit yet. Safe to inject; app behavior stays unchanged.
final class LiveActivityCoordinator: LiveActivityCoordinating {
    init() {}

    func sync(snapshot: TodayRhythmSnapshot) {
        _ = snapshot
    }

    func end() {}
}
