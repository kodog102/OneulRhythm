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

#if DEBUG
extension TodayRhythmActivityAttributes {
    static var preview: TodayRhythmActivityAttributes {
        TodayRhythmActivityAttributes(
            dayID: "2026-07-16",
            calendarDayStart: Calendar.current.startOfDay(for: Date())
        )
    }
}

extension TodayRhythmActivityAttributes.ContentState {
    static var previewActive: TodayRhythmActivityAttributes.ContentState {
        let now = Date()
        return TodayRhythmActivityAttributes.ContentState(
            phase: .active,
            focusRoutineID: UUID().uuidString,
            focusTitle: "따뜻한 차 한잔 마시기",
            focusStart: now.addingTimeInterval(-10 * 60),
            focusEnd: now.addingTimeInterval(20 * 60),
            nextRoutineID: UUID().uuidString,
            nextTitle: "가벼운 산책",
            nextStart: now.addingTimeInterval(30 * 60),
            updatedAt: now
        )
    }
}
#endif
