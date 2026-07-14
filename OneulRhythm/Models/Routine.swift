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

    init(
        id: UUID = UUID(),
        title: String,
        startTime: Date,
        endTime: Date?,
        category: RoutineCategory,
        status: RoutineStatus
    ) {
        self.id = id
        self.title = title
        self.startTime = startTime
        self.endTime = endTime
        self.category = category
        self.status = status
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
            status: status
        )
    }

    private static let displayTimeFormat = Date.FormatStyle(
        date: .omitted,
        time: .shortened
    )
}
