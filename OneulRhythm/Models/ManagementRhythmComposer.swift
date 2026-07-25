//
//  ManagementRhythmComposer.swift
//  OneulRhythm
//

import Foundation

/// Business composition for Routine Management list membership.
///
/// Builds configured-rhythm items from active recurring definitions and
/// today/future one-time routines. Historical recurring occurrences and past
/// one-time routines are excluded.
enum ManagementRhythmComposer {
    /// Composes the Management list from persistence-facing domain inputs.
    ///
    /// - Parameters:
    ///   - recurring: Active recurring definitions only.
    ///   - routines: All persisted routines; occurrence rows are ignored.
    ///   - now: Reference instant for one-time day visibility.
    ///   - dayPolicy: Shared local day-identity policy.
    /// - Returns: Management items sorted by wall-clock start, then title.
    static func compose(
        recurring: [RecurringManagementRhythm],
        routines: [Routine],
        now: Date,
        dayPolicy: CalendarDayPolicy
    ) -> [ManagementRhythmItem] {
        let today = dayPolicy.day(for: now)

        let recurringItems = recurring.map { ManagementRhythmItem.recurring($0) }

        let oneTimeItems = routines.compactMap { routine -> ManagementRhythmItem? in
            guard routine.recurringRhythmID == nil else {
                return nil
            }

            let routineDay = dayPolicy.day(for: routine.startTime)
            guard routineDay >= today else {
                return nil
            }

            return .oneTime(routine)
        }

        let calendar = dayPolicy.calendar
        return (recurringItems + oneTimeItems).sorted { lhs, rhs in
            let lhsMinutes = lhs.sortMinutes(calendar: calendar)
            let rhsMinutes = rhs.sortMinutes(calendar: calendar)
            if lhsMinutes != rhsMinutes {
                return lhsMinutes < rhsMinutes
            }
            return lhs.title.localizedStandardCompare(rhs.title) == .orderedAscending
        }
    }
}
