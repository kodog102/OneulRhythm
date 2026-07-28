//
//  QuietHoursPolicy.swift
//  OneulRhythm
//
//  Pure Quiet Hours evaluation — Sprint 21-2.
//  Suppresses reminder delivery decisions only; never schedule interpretation.
//

import Foundation

/// Pure policy for Quiet Hours wall-clock windows.
enum QuietHoursPolicy {
    /// Whether `date` falls inside an enabled Quiet Hours window.
    ///
    /// Supports overnight ranges (e.g. 22:00 → 07:00) and same-day ranges
    /// (e.g. 13:00 → 14:00). When disabled, always returns `false`.
    static func contains(
        _ date: Date,
        configuration: QuietHoursConfiguration,
        calendar: Calendar = .current
    ) -> Bool {
        guard configuration.isEnabled else { return false }

        let start = clampMinutes(configuration.startMinutes)
        let end = clampMinutes(configuration.endMinutes)
        let minute = minutesFromMidnight(date, calendar: calendar)

        if start == end {
            // Degenerate window — treat as inactive (no full-day lockout by accident).
            return false
        }

        if start < end {
            return minute >= start && minute < end
        }

        // Overnight: active from start through midnight, and from midnight until end.
        return minute >= start || minute < end
    }

    /// Minutes from midnight for a date (0...1439).
    static func minutesFromMidnight(_ date: Date, calendar: Calendar = .current) -> Int {
        let hour = calendar.component(.hour, from: date)
        let minute = calendar.component(.minute, from: date)
        return (hour * 60) + minute
    }

    /// Builds a reference `Date` today with the given minutes-from-midnight.
    static func date(
        on day: Date,
        minutesFromMidnight: Int,
        calendar: Calendar = .current
    ) -> Date {
        let clamped = clampMinutes(minutesFromMidnight)
        let hour = clamped / 60
        let minute = clamped % 60
        return calendar.date(
            bySettingHour: hour,
            minute: minute,
            second: 0,
            of: day
        ) ?? day
    }

    private static func clampMinutes(_ value: Int) -> Int {
        min(max(value, 0), (24 * 60) - 1)
    }
}
