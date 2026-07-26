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
    /// Composes the Management catalog from persistence-facing domain inputs.
    ///
    /// - Parameters:
    ///   - recurring: Active recurring definitions only.
    ///   - routines: All persisted routines; occurrence rows are ignored.
    ///   - now: Reference instant for one-time day visibility.
    ///   - dayPolicy: Shared local day-identity policy.
    /// - Returns: Sectioned Management items with section-local sorting.
    static func compose(
        recurring: [RecurringManagementRhythm],
        routines: [Routine],
        now: Date,
        dayPolicy: CalendarDayPolicy
    ) -> ManagementRhythmCatalog {
        let today = dayPolicy.day(for: now)
        let calendar = dayPolicy.calendar

        let recurringItems = recurring
            .map { ManagementRhythmItem.recurring($0) }
            .sorted { lhs, rhs in
                let lhsMinutes = lhs.sortMinutes(calendar: calendar)
                let rhsMinutes = rhs.sortMinutes(calendar: calendar)
                if lhsMinutes != rhsMinutes {
                    return lhsMinutes < rhsMinutes
                }
                return lhs.title.localizedStandardCompare(rhs.title) == .orderedAscending
            }

        let oneTimeItems = routines
            .compactMap { routine -> ManagementRhythmItem? in
                guard routine.recurringRhythmID == nil else {
                    return nil
                }

                let routineDay = dayPolicy.day(for: routine.startTime)
                guard routineDay >= today else {
                    return nil
                }

                return .oneTime(routine)
            }
            .sorted { lhs, rhs in
                guard case .oneTime(let left) = lhs,
                      case .oneTime(let right) = rhs else {
                    return false
                }

                if left.startTime != right.startTime {
                    return left.startTime < right.startTime
                }
                return left.title.localizedStandardCompare(right.title) == .orderedAscending
            }

        return ManagementRhythmCatalog(
            recurring: recurringItems,
            oneTime: oneTimeItems
        )
    }
}
