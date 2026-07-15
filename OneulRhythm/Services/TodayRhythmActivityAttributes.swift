//
//  TodayRhythmActivityAttributes.swift
//  OneulRhythm
//

import ActivityKit
import Foundation

/// Live Activity contract for one calendar day.
///
/// Static attributes identify the day session only.
/// Dynamic content projects a quiet subset of `TodayRhythmSnapshot`.
struct TodayRhythmActivityAttributes: ActivityAttributes {
    /// Quiet Live Activity phase. Does not include empty — empty means no activity.
    enum Phase: String, Codable, Hashable {
        case upcoming
        case active
        case betweenRhythms
        case overdue
        case dayComplete
    }

    struct ContentState: Codable, Hashable {
        var phase: Phase
        var focusRoutineID: String?
        var focusTitle: String?
        var focusStart: Date?
        var focusEnd: Date?
        var nextRoutineID: String?
        var nextTitle: String?
        var nextStart: Date?
        var updatedAt: Date
    }

    /// Stable identifier for the calendar day session.
    var dayID: String

    /// Start of the calendar day represented by this Live Activity.
    var calendarDayStart: Date
}
