//
//  OccurrenceDateTimeMaterializer.swift
//  OneulRhythm
//

import Foundation

/// Pure service that converts a `PlannedOccurrence` into concrete local
/// start and end timestamps for one calendar day.
///
/// Uses the calendar injected through `CalendarDayPolicy`. Does not create
/// entities, touch persistence, or compute reminder fire dates.
struct OccurrenceDateTimeMaterializer {
    private let dayPolicy: CalendarDayPolicy

    init(dayPolicy: CalendarDayPolicy) {
        self.dayPolicy = dayPolicy
    }

    func materialize(_ occurrence: PlannedOccurrence) -> MaterializedOccurrence {
        let calendar = dayPolicy.calendar
        let day = occurrence.occurrenceDate

        guard let startDate = calendar.date(
            byAdding: .minute,
            value: occurrence.startMinutes,
            to: day
        ) else {
            preconditionFailure("Unable to materialize startDate from occurrenceDate and startMinutes.")
        }

        guard let endDate = calendar.date(
            byAdding: .minute,
            value: occurrence.durationMinutes,
            to: startDate
        ) else {
            preconditionFailure("Unable to materialize endDate from startDate and durationMinutes.")
        }

        return MaterializedOccurrence(
            recurringRhythmID: occurrence.recurringRhythmID,
            occurrenceDate: occurrence.occurrenceDate,
            title: occurrence.title,
            category: occurrence.category,
            startDate: startDate,
            endDate: endDate,
            reminderMinutes: occurrence.reminderMinutes
        )
    }
}
