//
//  RecurringDefinitionDeletionPolicy.swift
//  OneulRhythm
//

import Foundation

/// Business policy for which linked occurrences to remove when a recurring
/// definition is deleted from Management.
///
/// Approved matrix:
/// - before today → preserve
/// - today + completed → preserve
/// - today + incomplete → delete
/// - after today → delete
///
/// Does not touch persistence or definition deactivation.
enum RecurringDefinitionDeletionPolicy {
    /// Returns occurrence ids that should be deleted for the linked set.
    ///
    /// - Parameters:
    ///   - linkedOccurrences: Occurrences belonging to the deleted definition.
    ///   - now: Reference instant for "today".
    ///   - dayPolicy: Shared local day-identity policy.
    static func occurrenceIDsToDelete(
        linkedOccurrences: [Routine],
        now: Date,
        dayPolicy: CalendarDayPolicy
    ) -> Set<UUID> {
        let today = dayPolicy.day(for: now)
        var idsToDelete = Set<UUID>()

        for occurrence in linkedOccurrences {
            let occurrenceDay = day(for: occurrence, dayPolicy: dayPolicy)

            if occurrenceDay < today {
                continue
            }

            if occurrenceDay > today {
                idsToDelete.insert(occurrence.id)
                continue
            }

            // Same calendar day as today.
            if occurrence.status == .completed {
                continue
            }

            idsToDelete.insert(occurrence.id)
        }

        return idsToDelete
    }

    private static func day(
        for occurrence: Routine,
        dayPolicy: CalendarDayPolicy
    ) -> Date {
        if let occurrenceDate = occurrence.occurrenceDate {
            return dayPolicy.day(for: occurrenceDate)
        }
        return dayPolicy.day(for: occurrence.startTime)
    }
}
