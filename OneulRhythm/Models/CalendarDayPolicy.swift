//
//  CalendarDayPolicy.swift
//  OneulRhythm
//

import Foundation

/// Shared Calendar-based day identity policy.
///
/// Centralizes how a local calendar day is determined so that recurrence
/// applicability, recurring definition start-date comparison, generated
/// `occurrenceDate` normalization, and duplicate occurrence lookup all agree
/// on what "the same day" means.
///
/// The `Calendar` is injected once at initialization rather than read from
/// global state on every call, so behavior stays deterministic and testable.
struct CalendarDayPolicy {
    private let calendar: Calendar

    init(calendar: Calendar = .current) {
        self.calendar = calendar
    }

    /// Returns the calendar's normalized start of day for `date`.
    func day(for date: Date) -> Date {
        calendar.startOfDay(for: date)
    }

    /// Returns whether `lhs` and `rhs` fall on the same local calendar day.
    func isSameDay(_ lhs: Date, _ rhs: Date) -> Bool {
        calendar.isDate(lhs, inSameDayAs: rhs)
    }

    /// Returns whether `date` falls on a weekend, according to the injected Calendar.
    func isWeekend(_ date: Date) -> Bool {
        calendar.isDateInWeekend(date)
    }
}
