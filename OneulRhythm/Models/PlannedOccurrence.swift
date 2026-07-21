//
//  PlannedOccurrence.swift
//  OneulRhythm
//

import Foundation

/// One planned occurrence produced by recurrence evaluation for a single
/// calendar day.
///
/// A pure transport value between `RecurrenceEngine` and
/// `DailyRhythmProvisioner`. It carries no persistence, Calendar, or
/// recurrence behavior.
///
/// Explicitly `nonisolated` so default MainActor isolation does not attach
/// to this framework-independent domain value.
nonisolated struct PlannedOccurrence: Equatable, Sendable {
    let recurringRhythmID: UUID
    let occurrenceDate: Date
    let title: String
    let category: RoutineCategory
    let startMinutes: Int
    let durationMinutes: Int
    let reminderMinutes: Int?

    init(
        recurringRhythmID: UUID,
        occurrenceDate: Date,
        title: String,
        category: RoutineCategory,
        startMinutes: Int,
        durationMinutes: Int,
        reminderMinutes: Int?
    ) {
        self.recurringRhythmID = recurringRhythmID
        self.occurrenceDate = occurrenceDate
        self.title = title
        self.category = category
        self.startMinutes = startMinutes
        self.durationMinutes = durationMinutes
        self.reminderMinutes = reminderMinutes
    }
}
