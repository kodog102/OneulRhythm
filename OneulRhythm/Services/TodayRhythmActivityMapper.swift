//
//  TodayRhythmActivityMapper.swift
//  OneulRhythm
//

import Foundation

/// Mapped payload for starting or updating today's Live Activity.
struct TodayRhythmActivityPayload {
    let attributes: TodayRhythmActivityAttributes
    let contentState: TodayRhythmActivityAttributes.ContentState
}

/// Pure mapper from `TodayRhythmSnapshot` to Live Activity data.
///
/// Contains no ActivityKit lifecycle, persistence, SwiftUI, or notification logic.
enum TodayRhythmActivityMapper {
    /// Returns `nil` when the snapshot is empty (no Live Activity payload).
    static func map(
        snapshot: TodayRhythmSnapshot,
        calendar: Calendar,
        updatedAt: Date
    ) -> TodayRhythmActivityPayload? {
        guard let phase = Self.phase(from: snapshot.phase) else {
            return nil
        }

        let calendarDayStart = calendar.startOfDay(for: snapshot.date)
        let attributes = TodayRhythmActivityAttributes(
            dayID: Self.dayID(for: calendarDayStart, calendar: calendar),
            calendarDayStart: calendarDayStart
        )

        let focusRoutine = snapshot.currentRoutine ?? snapshot.pastIncompleteRoutine
        let nextRoutine = snapshot.nextRoutine

        let contentState = TodayRhythmActivityAttributes.ContentState(
            phase: phase,
            focusRoutineID: focusRoutine.map { $0.id.uuidString },
            focusTitle: focusRoutine?.title,
            focusStart: focusRoutine?.startTime,
            focusEnd: focusRoutine.map(RoutineTimingPolicy.activeEndTime(for:)),
            nextRoutineID: nextRoutine.map { $0.id.uuidString },
            nextTitle: nextRoutine?.title,
            nextStart: nextRoutine?.startTime,
            updatedAt: updatedAt
        )

        return TodayRhythmActivityPayload(
            attributes: attributes,
            contentState: contentState
        )
    }

    private static func phase(
        from snapshotPhase: TodayRhythmPhase
    ) -> TodayRhythmActivityAttributes.Phase? {
        switch snapshotPhase {
        case .empty:
            return nil
        case .upcoming:
            return .upcoming
        case .active:
            return .active
        case .betweenRhythms:
            return .betweenRhythms
        case .overdue:
            return .overdue
        case .dayComplete:
            return .dayComplete
        }
    }

    private static func dayID(for dayStart: Date, calendar: Calendar) -> String {
        let components = calendar.dateComponents([.year, .month, .day], from: dayStart)
        let year = components.year ?? 0
        let month = components.month ?? 0
        let day = components.day ?? 0
        return String(format: "%04d-%02d-%02d", year, month, day)
    }
}
