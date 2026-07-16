//
//  TodayRhythmSnapshot.swift
//  OneulRhythm
//

import Foundation

/// Presentation-only phase for today's rhythm across surfaces.
/// Not persisted. Derived from a resolved `RoutineSchedule`.
enum TodayRhythmPhase: Equatable {
    case empty
    case upcoming
    case active
    case overdue
    case betweenRhythms
    case dayComplete
}

/// Shared immutable presentation model for today's rhythm.
struct TodayRhythmSnapshot {
    let date: Date
    let phase: TodayRhythmPhase
    let routines: [Routine]
    let currentRoutine: Routine?
    let overdueRoutines: [Routine]
    /// The earliest past-due, not-yet-completed routine — a fact about
    /// today's schedule, not a presentation choice. Presentation priority
    /// (current → past incomplete → next) is decided by `TodayViewModel`.
    let pastIncompleteRoutine: Routine?
    let nextRoutine: Routine?
    let completedCount: Int
    let totalCount: Int
    let progress: Double
    let isComplete: Bool

    init(schedule: RoutineSchedule, date: Date) {
        let routines = schedule.routines
        let totalCount = routines.count
        let completedCount = routines.filter(\.isCompleted).count
        let progress: Double = totalCount == 0
            ? 0
            : Double(completedCount) / Double(totalCount)
        let isComplete = totalCount > 0 && completedCount == totalCount

        self.date = date
        self.routines = routines
        self.currentRoutine = schedule.currentRoutine
        self.overdueRoutines = schedule.overdueRoutines
        self.pastIncompleteRoutine = schedule.overdueRoutines.first
        self.nextRoutine = schedule.nextRoutine
        self.completedCount = completedCount
        self.totalCount = totalCount
        self.progress = progress
        self.isComplete = isComplete
        self.phase = Self.resolvePhase(
            totalCount: totalCount,
            isComplete: isComplete,
            currentRoutine: schedule.currentRoutine,
            overdueRoutines: schedule.overdueRoutines,
            nextRoutine: schedule.nextRoutine,
            completedCount: completedCount
        )
    }

    private static func resolvePhase(
        totalCount: Int,
        isComplete: Bool,
        currentRoutine: Routine?,
        overdueRoutines: [Routine],
        nextRoutine: Routine?,
        completedCount: Int
    ) -> TodayRhythmPhase {
        if totalCount == 0 {
            return .empty
        }

        if isComplete {
            return .dayComplete
        }

        if currentRoutine != nil {
            return .active
        }

        if !overdueRoutines.isEmpty {
            return .overdue
        }

        if nextRoutine != nil {
            return completedCount > 0 ? .betweenRhythms : .upcoming
        }

        return .empty
    }
}
