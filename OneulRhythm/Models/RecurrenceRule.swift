//
//  RecurrenceRule.swift
//  OneulRhythm
//

import Foundation

/// A pure recurrence rule describing which local calendar days a recurring
/// rhythm occurs on.
///
/// A one-time rhythm is represented elsewhere by the absence of a
/// `RecurrenceRule` — this type intentionally has no `.none` case.
enum RecurrenceRule: String, CaseIterable, Codable, Sendable {
    case daily
    case weekdays
    case weekends

    /// Returns whether this rule occurs on `date`, given the recurring
    /// definition's `startDate`.
    ///
    /// Dates are always normalized through `dayPolicy` before comparison;
    /// raw timestamps are never compared directly.
    func occurs(
        on date: Date,
        startingAt startDate: Date,
        using dayPolicy: CalendarDayPolicy
    ) -> Bool {
        let requestedDay = dayPolicy.day(for: date)
        let startDay = dayPolicy.day(for: startDate)

        guard requestedDay >= startDay else {
            return false
        }

        switch self {
        case .daily:
            return true
        case .weekdays:
            return !dayPolicy.isWeekend(requestedDay)
        case .weekends:
            return dayPolicy.isWeekend(requestedDay)
        }
    }
}
