//
//  RoutineScheduleEngine.swift
//  OneulRhythm
//

import Foundation

enum RoutineScheduleRole {
    case current
    case overdue
    case next
    case completed
}

struct RoutineSchedule {
    let routines: [Routine]
    let currentRoutine: Routine?
    let overdueRoutines: [Routine]
    let nextRoutine: Routine?
}

struct RoutineScheduleEngine {
    /// Temporary active window used when a routine has no end time.
    static let defaultActiveDuration: TimeInterval = 30 * 60

    func resolve(
        routines: [Routine],
        now: Date,
        calendar: Calendar = .current
    ) -> RoutineSchedule {
        let todaysRoutines = routines
            .filter { calendar.isDate($0.startTime, inSameDayAs: now) }
            .sorted { lhs, rhs in
                if lhs.startTime != rhs.startTime {
                    return lhs.startTime < rhs.startTime
                }

                return lhs.id.uuidString < rhs.id.uuidString
            }

        let current = todaysRoutines.first { routine in
            guard !routine.isCompleted else { return false }
            return isActive(routine, at: now)
        }

        let overdue = todaysRoutines.filter { routine in
            guard !routine.isCompleted else { return false }
            guard routine.id != current?.id else { return false }
            return hasEnded(routine, at: now)
        }

        let next = todaysRoutines.first { routine in
            guard !routine.isCompleted else { return false }
            guard routine.id != current?.id else { return false }
            guard !overdue.contains(where: { $0.id == routine.id }) else { return false }
            return routine.startTime > now
        }

        let resolvedRoutines = todaysRoutines.map { routine in
            if routine.isCompleted {
                return routine.updatingStatus(.completed)
            }

            if routine.id == current?.id {
                return routine.updatingStatus(.current)
            }

            return routine.updatingStatus(.upcoming)
        }

        let resolvedOverdue = overdue.map { routine in
            resolvedRoutines.first { $0.id == routine.id } ?? routine.updatingStatus(.upcoming)
        }

        return RoutineSchedule(
            routines: resolvedRoutines,
            currentRoutine: resolvedRoutines.first { $0.id == current?.id },
            overdueRoutines: resolvedOverdue,
            nextRoutine: resolvedRoutines.first { $0.id == next?.id }
        )
    }

    private func isActive(_ routine: Routine, at now: Date) -> Bool {
        let endTime = activeEndTime(for: routine)
        return routine.startTime <= now && now < endTime
    }

    private func hasEnded(_ routine: Routine, at now: Date) -> Bool {
        now >= activeEndTime(for: routine)
    }

    private func activeEndTime(for routine: Routine) -> Date {
        routine.endTime
            ?? routine.startTime.addingTimeInterval(Self.defaultActiveDuration)
    }
}
