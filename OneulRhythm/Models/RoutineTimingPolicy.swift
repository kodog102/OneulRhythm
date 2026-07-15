//
//  RoutineTimingPolicy.swift
//  OneulRhythm
//

import Foundation

/// Shared domain rules for resolving a routine's active window.
enum RoutineTimingPolicy {
    /// Temporary active window used when a routine has no end time.
    static let defaultActiveDuration: TimeInterval = 30 * 60

    static func activeEndTime(for routine: Routine) -> Date {
        routine.endTime
            ?? routine.startTime.addingTimeInterval(defaultActiveDuration)
    }
}
