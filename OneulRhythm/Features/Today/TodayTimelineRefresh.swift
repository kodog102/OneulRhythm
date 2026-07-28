//
//  TodayTimelineRefresh.swift
//  OneulRhythm
//
//  Sprint 19-2I — next meaningful Today UI transition (presentation-only).
//

import Foundation

enum TodayTimelineRefresh {
    /// Earliest future instant when Today's visible snapshot roles can change.
    ///
    /// Candidates: incomplete rhythm starts/ends (via `RoutineTimingPolicy`), and
    /// local midnight (day rollover for empty / day-complete).
    static func nextTransitionDate(
        snapshot: TodayRhythmSnapshot,
        now: Date,
        calendar: Calendar
    ) -> Date? {
        var candidates: [Date] = []

        for routine in snapshot.routines where !routine.isCompleted {
            if routine.startTime > now {
                candidates.append(routine.startTime)
            }
            let end = RoutineTimingPolicy.activeEndTime(for: routine)
            if end > now {
                candidates.append(end)
            }
        }

        if let startOfTomorrow = calendar.date(
            byAdding: .day,
            value: 1,
            to: calendar.startOfDay(for: now)
        ), startOfTomorrow > now {
            candidates.append(startOfTomorrow)
        }

        return candidates.min()
    }
}
