//
//  RoutineEntity.swift
//  OneulRhythm
//

import Foundation
import SwiftData

@Model
final class RoutineEntity {
    @Attribute(.unique) var id: UUID
    var title: String
    var startTime: Date
    var endTime: Date?
    var categoryRawValue: String
    var statusRawValue: String
    var reminderMinutes: Int?
    /// Originating `RecurringRhythmEntity.id` when this row is a materialized
    /// recurring occurrence. `nil` for one-time routines.
    var recurringRhythmID: UUID?
    /// Normalized local calendar day for a materialized occurrence
    /// (`CalendarDayPolicy.day(for:)`). `nil` for one-time routines.
    /// Normalization is owned by callers — this entity stores the value as-is.
    var occurrenceDate: Date?
    var createdAt: Date
    var updatedAt: Date

    init(
        id: UUID = UUID(),
        title: String,
        startTime: Date,
        endTime: Date? = nil,
        category: RoutineCategory,
        status: RoutineStatus,
        reminderMinutes: Int? = nil,
        recurringRhythmID: UUID? = nil,
        occurrenceDate: Date? = nil,
        createdAt: Date = Date(),
        updatedAt: Date = Date()
    ) {
        self.id = id
        self.title = title
        self.startTime = startTime
        self.endTime = endTime
        self.categoryRawValue = category.rawValue
        self.statusRawValue = status.rawValue
        self.reminderMinutes = reminderMinutes
        self.recurringRhythmID = recurringRhythmID
        self.occurrenceDate = occurrenceDate
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}
