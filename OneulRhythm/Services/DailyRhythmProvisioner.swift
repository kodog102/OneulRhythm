//
//  DailyRhythmProvisioner.swift
//  OneulRhythm
//

import Foundation

/// Coordinates daily materialization of recurring rhythm definitions.
///
/// Orchestrates repository fetch, recurrence planning, datetime materialization,
/// duplicate lookup, and routine insertion. Contains no date or recurrence
/// business rules of its own.
final class DailyRhythmProvisioner {
    private let recurringRhythmRepository: RecurringRhythmRepository
    private let routineRepository: RoutineRepository
    private let recurrenceEngine: RecurrenceEngine
    private let dateTimeMaterializer: OccurrenceDateTimeMaterializer

    init(
        recurringRhythmRepository: RecurringRhythmRepository,
        routineRepository: RoutineRepository,
        recurrenceEngine: RecurrenceEngine,
        dateTimeMaterializer: OccurrenceDateTimeMaterializer
    ) {
        self.recurringRhythmRepository = recurringRhythmRepository
        self.routineRepository = routineRepository
        self.recurrenceEngine = recurrenceEngine
        self.dateTimeMaterializer = dateTimeMaterializer
    }

    /// Provisions missing daily routines for recurring definitions that apply
    /// to the requested calendar day.
    func provision(for date: Date) throws {
        let definitions = try recurringRhythmRepository.fetchActive()

        for definition in definitions {
            guard let planned = recurrenceEngine.planOccurrence(
                for: definition,
                on: date
            ) else {
                continue
            }

            let materialized = dateTimeMaterializer.materialize(planned)

            let alreadyExists = try routineRepository.hasOccurrence(
                recurringRhythmID: materialized.recurringRhythmID,
                occurrenceDate: materialized.occurrenceDate
            )
            guard !alreadyExists else {
                continue
            }

            let routine = RoutineEntity(
                title: materialized.title,
                startTime: materialized.startDate,
                endTime: materialized.endDate,
                category: materialized.category,
                status: .upcoming,
                reminderMinutes: materialized.reminderMinutes,
                recurringRhythmID: materialized.recurringRhythmID,
                occurrenceDate: materialized.occurrenceDate
            )

            try routineRepository.insert(routine)
        }
    }
}
