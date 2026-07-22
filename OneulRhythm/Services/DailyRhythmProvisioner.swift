//
//  DailyRhythmProvisioner.swift
//  OneulRhythm
//

import Foundation

/// Coordinates daily materialization of recurring rhythm definitions.
///
/// Task 8B-1 introduces only the dependency surface and entry API.
/// Provisioning behavior is intentionally unimplemented until later tasks.
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

    /// Provisions recurring occurrences for the requested calendar day.
    ///
    /// Unimplemented in Task 8B-1. Later tasks will fetch active definitions,
    /// plan occurrences, materialize timestamps, and insert missing routines.
    func provision(for date: Date) throws {
        // Keep injected dependencies and the requested date referenced so the
        // skeleton compiles cleanly without performing any provisioning work.
        _ = (
            recurringRhythmRepository,
            routineRepository,
            recurrenceEngine,
            dateTimeMaterializer,
            date
        )
        fatalError("DailyRhythmProvisioner.provision(for:) is not implemented yet.")
    }
}
