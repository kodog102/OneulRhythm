//
//  LiveActivityCoordinating.swift
//  OneulRhythm
//

import Foundation

/// Owns the lifecycle of OneulRhythm’s single one-day Live Activity.
///
/// Presentation input is always `TodayRhythmSnapshot`.
/// Implementations must not expose ActivityKit types.
protocol LiveActivityCoordinating {
    /// Aligns the day Live Activity with the latest today snapshot.
    /// Future implementations may start, update, or leave the day session unchanged.
    func sync(snapshot: TodayRhythmSnapshot)

    /// Ends the current day Live Activity session when one is active.
    func end()
}
