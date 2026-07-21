//
//  MaterializedOccurrence.swift
//  OneulRhythm
//

import Foundation

/// A planned occurrence with concrete local start and end timestamps.
///
/// Produced by `OccurrenceDateTimeMaterializer` for the future provisioner.
/// Carries no persistence or scheduling behavior.
nonisolated struct MaterializedOccurrence: Equatable, Sendable {
    let recurringRhythmID: UUID
    let occurrenceDate: Date
    let title: String
    let category: RoutineCategory
    let startDate: Date
    let endDate: Date
    let reminderMinutes: Int?

    init(
        recurringRhythmID: UUID,
        occurrenceDate: Date,
        title: String,
        category: RoutineCategory,
        startDate: Date,
        endDate: Date,
        reminderMinutes: Int?
    ) {
        self.recurringRhythmID = recurringRhythmID
        self.occurrenceDate = occurrenceDate
        self.title = title
        self.category = category
        self.startDate = startDate
        self.endDate = endDate
        self.reminderMinutes = reminderMinutes
    }
}
