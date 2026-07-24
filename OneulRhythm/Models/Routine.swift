//
//  Routine.swift
//  OneulRhythm
//

import Foundation

enum RoutineCategory: String, Codable, CaseIterable {
    case morning = "morning"
    case focus = "focus"
    case movement = "movement"
    case rest = "rest"
    case evening = "evening"
}

enum RoutineStatus: String, Codable, CaseIterable {
    case upcoming = "upcoming"
    case current = "current"
    case completed = "completed"
}

struct Routine: Identifiable {
    let id: UUID
    let title: String
    let startTime: Date
    let endTime: Date?
    let category: RoutineCategory
    let status: RoutineStatus
    /// Minutes before `startTime` to remind, or `nil` when no reminder is set.
    let reminderMinutes: Int?
    /// Originating recurring definition id when this rhythm was materialized
    /// from a recurring template. `nil` for one-time routines.
    let recurringRhythmID: UUID?
    /// Normalized local calendar day for a materialized occurrence.
    /// `nil` for one-time routines.
    let occurrenceDate: Date?

    init(
        id: UUID = UUID(),
        title: String,
        startTime: Date,
        endTime: Date?,
        category: RoutineCategory,
        status: RoutineStatus,
        reminderMinutes: Int? = nil,
        recurringRhythmID: UUID? = nil,
        occurrenceDate: Date? = nil
    ) {
        self.id = id
        self.title = title
        self.startTime = startTime
        self.endTime = endTime
        self.category = category
        self.status = status
        self.reminderMinutes = reminderMinutes
        self.recurringRhythmID = recurringRhythmID
        self.occurrenceDate = occurrenceDate
    }

    var isCurrent: Bool {
        status == .current
    }

    var isCompleted: Bool {
        status == .completed
    }

    var formattedTime: String {
        let timeText = startTime.formatted(Self.displayTimeFormat)

        guard let endTime else {
            return timeText
        }

        return "\(timeText) - \(endTime.formatted(Self.displayTimeFormat))"
    }

    func updatingStatus(_ status: RoutineStatus) -> Routine {
        Routine(
            id: id,
            title: title,
            startTime: startTime,
            endTime: endTime,
            category: category,
            status: status,
            reminderMinutes: reminderMinutes,
            recurringRhythmID: recurringRhythmID,
            occurrenceDate: occurrenceDate
        )
    }

    // Explicitly locale-pinned to ko_KR, matching the rest of the app's
    // Korean-only presentation (e.g. `TodayViewModel.formattedTodayDate`).
    // Still fully locale-aware formatting — Foundation resolves the
    // AM/PM ("오전"/"오후") and ordering itself; no strings are hardcoded.
    private static let displayTimeFormat = Date.FormatStyle(
        date: .omitted,
        time: .shortened
    )
    .locale(Locale(identifier: "ko_KR"))
}
