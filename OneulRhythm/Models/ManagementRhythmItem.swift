//
//  ManagementRhythmItem.swift
//  OneulRhythm
//

import Foundation

/// Configured recurring rhythm shown once in Routine Management.
///
/// Identity is the recurring definition id, never a materialized occurrence id.
struct RecurringManagementRhythm: Equatable, Identifiable {
    let id: UUID
    let title: String
    let category: RoutineCategory
    let startMinutes: Int
    let durationMinutes: Int
    let recurrence: RecurrenceRule
    let reminderMinutes: Int?
    let startDate: Date

    init(
        id: UUID,
        title: String,
        category: RoutineCategory,
        startMinutes: Int,
        durationMinutes: Int,
        recurrence: RecurrenceRule,
        reminderMinutes: Int?,
        startDate: Date
    ) {
        self.id = id
        self.title = title
        self.category = category
        self.startMinutes = startMinutes
        self.durationMinutes = durationMinutes
        self.recurrence = recurrence
        self.reminderMinutes = reminderMinutes
        self.startDate = startDate
    }

    init(_ entity: RecurringRhythmEntity) {
        self.init(
            id: entity.id,
            title: entity.title,
            category: entity.category,
            startMinutes: entity.startMinutes,
            durationMinutes: entity.durationMinutes,
            recurrence: entity.recurrence,
            reminderMinutes: entity.reminderMinutes,
            startDate: entity.startDate
        )
    }
}

/// One configured rhythm in Routine Management.
///
/// Recurring items use definition identity. One-time items use routine identity.
enum ManagementRhythmItem: Identifiable {
    case recurring(RecurringManagementRhythm)
    case oneTime(Routine)

    var id: UUID {
        switch self {
        case .recurring(let rhythm):
            return rhythm.id
        case .oneTime(let routine):
            return routine.id
        }
    }

    var title: String {
        switch self {
        case .recurring(let rhythm):
            return rhythm.title
        case .oneTime(let routine):
            return routine.title
        }
    }

    var isRecurring: Bool {
        switch self {
        case .recurring:
            return true
        case .oneTime:
            return false
        }
    }

    var recurrence: RecurrenceRule? {
        switch self {
        case .recurring(let rhythm):
            return rhythm.recurrence
        case .oneTime:
            return nil
        }
    }

    var category: RoutineCategory {
        switch self {
        case .recurring(let rhythm):
            return rhythm.category
        case .oneTime(let routine):
            return routine.category
        }
    }

    var reminderMinutes: Int? {
        switch self {
        case .recurring(let rhythm):
            return rhythm.reminderMinutes
        case .oneTime(let routine):
            return routine.reminderMinutes
        }
    }

    /// Wall-clock minutes from midnight used for Management list ordering.
    func sortMinutes(calendar: Calendar) -> Int {
        switch self {
        case .recurring(let rhythm):
            return rhythm.startMinutes
        case .oneTime(let routine):
            return calendar.component(.hour, from: routine.startTime) * 60
                + calendar.component(.minute, from: routine.startTime)
        }
    }

    func displayStartTime(referenceDay: Date, calendar: Calendar) -> Date {
        switch self {
        case .recurring(let rhythm):
            let day = calendar.startOfDay(for: referenceDay)
            return calendar.date(
                byAdding: .minute,
                value: rhythm.startMinutes,
                to: day
            ) ?? day
        case .oneTime(let routine):
            return routine.startTime
        }
    }

    func displayEndTime(referenceDay: Date, calendar: Calendar) -> Date? {
        switch self {
        case .recurring(let rhythm):
            let start = displayStartTime(referenceDay: referenceDay, calendar: calendar)
            return calendar.date(
                byAdding: .minute,
                value: rhythm.durationMinutes,
                to: start
            )
        case .oneTime(let routine):
            return routine.endTime
        }
    }

    func formattedTime(referenceDay: Date, calendar: Calendar) -> String {
        switch self {
        case .oneTime(let routine):
            return routine.formattedTime
        case .recurring:
            let start = displayStartTime(referenceDay: referenceDay, calendar: calendar)
            let startText = start.formatted(Self.displayTimeFormat)
            guard let end = displayEndTime(referenceDay: referenceDay, calendar: calendar) else {
                return startText
            }
            return "\(startText) - \(end.formatted(Self.displayTimeFormat))"
        }
    }

    private static let displayTimeFormat = Date.FormatStyle(
        date: .omitted,
        time: .shortened
    )
    .locale(Locale(identifier: "ko_KR"))
}
