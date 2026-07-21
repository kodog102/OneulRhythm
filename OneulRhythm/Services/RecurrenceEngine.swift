//
//  RecurrenceEngine.swift
//  OneulRhythm
//

import Foundation

/// Pure engine that projects one recurring definition onto one requested
/// calendar day.
///
/// Returns a `PlannedOccurrence` when the definition applies, otherwise `nil`.
/// Persistence, occurrence materialization, and scheduling remain outside
/// this type.
///
/// Uses the project's default actor isolation so it can call
/// `RecurrenceRule` / `CalendarDayPolicy` without introducing isolation
/// mismatches (those types are not modified in this task).
struct RecurrenceEngine {
    private let dayPolicy: CalendarDayPolicy

    init(dayPolicy: CalendarDayPolicy) {
        self.dayPolicy = dayPolicy
    }

    /// Plans a single occurrence for `definition` on `requestedDate`.
    ///
    /// Returns `nil` when the definition is inactive or its recurrence rule
    /// does not apply to the requested local calendar day.
    func planOccurrence(
        for definition: RecurringRhythmEntity,
        on requestedDate: Date
    ) -> PlannedOccurrence? {
        guard definition.isActive else {
            return nil
        }

        guard definition.recurrence.occurs(
            on: requestedDate,
            startingAt: definition.startDate,
            using: dayPolicy
        ) else {
            return nil
        }

        return PlannedOccurrence(
            recurringRhythmID: definition.id,
            occurrenceDate: dayPolicy.day(for: requestedDate),
            title: definition.title,
            category: definition.category,
            startMinutes: definition.startMinutes,
            durationMinutes: definition.durationMinutes,
            reminderMinutes: definition.reminderMinutes
        )
    }
}
