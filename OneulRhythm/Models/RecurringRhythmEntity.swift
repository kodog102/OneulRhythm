//
//  RecurringRhythmEntity.swift
//  OneulRhythm
//

import Foundation
import SwiftData

@Model
final class RecurringRhythmEntity {
    @Attribute(.unique) var id: UUID
    var title: String
    var categoryRawValue: String
    /// Local wall-clock start time as minutes from local midnight (0...1439).
    var startMinutes: Int
    /// Duration in minutes. May cross midnight (for example, start 1380 + duration 120).
    var durationMinutes: Int
    var recurrenceRawValue: String
    var startDate: Date
    var reminderMinutes: Int?
    var isActive: Bool

    init(
        id: UUID = UUID(),
        title: String,
        category: RoutineCategory,
        startMinutes: Int,
        durationMinutes: Int,
        recurrence: RecurrenceRule,
        startDate: Date,
        reminderMinutes: Int? = nil,
        isActive: Bool = true
    ) {
        self.id = id
        self.title = title
        self.categoryRawValue = category.rawValue
        self.startMinutes = startMinutes
        self.durationMinutes = durationMinutes
        self.recurrenceRawValue = recurrence.rawValue
        self.startDate = startDate
        self.reminderMinutes = reminderMinutes
        self.isActive = isActive
    }

    var category: RoutineCategory {
        guard let category = RoutineCategory(rawValue: categoryRawValue) else {
            preconditionFailure("RecurringRhythmEntity contains an unsupported category raw value.")
        }
        return category
    }

    var recurrence: RecurrenceRule {
        guard let recurrence = RecurrenceRule(rawValue: recurrenceRawValue) else {
            preconditionFailure("RecurringRhythmEntity contains an unsupported recurrence raw value.")
        }
        return recurrence
    }
}
