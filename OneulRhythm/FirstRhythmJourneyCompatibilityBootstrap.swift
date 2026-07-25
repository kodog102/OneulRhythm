//
//  FirstRhythmJourneyCompatibilityBootstrap.swift
//  OneulRhythm
//

import Foundation

/// One-time upgrade compatibility for DR-015.
///
/// Existing creators (pre-DR-015) have no journey preference yet.
/// This bootstrap initializes that preference from persisted evidence once.
/// It is not render-time Empty State inference.
@MainActor
enum FirstRhythmJourneyCompatibilityBootstrap {
    /// Marks First Journey complete when incomplete and creator evidence exists.
    /// Idempotent. Throws when repository reads fail so callers can log and skip.
    static func applyIfNeeded(
        progress: FirstRhythmJourneyProgress,
        routineRepository: RoutineRepository,
        recurringRhythmRepository: RecurringRhythmRepository
    ) throws {
        guard !progress.hasCompletedFirstRhythmJourney else { return }

        let hasExistingCreatorEvidence = try hasExistingCreatorEvidence(
            routineRepository: routineRepository,
            recurringRhythmRepository: recurringRhythmRepository
        )
        guard hasExistingCreatorEvidence else { return }

        progress.markFirstRhythmCreated()
    }

    /// Evidence: any stored routine row, or any active recurring definition.
    static func hasExistingCreatorEvidence(
        routineRepository: RoutineRepository,
        recurringRhythmRepository: RecurringRhythmRepository
    ) throws -> Bool {
        if try !routineRepository.fetchRoutines().isEmpty {
            return true
        }
        if try !recurringRhythmRepository.fetchActive().isEmpty {
            return true
        }
        return false
    }
}
