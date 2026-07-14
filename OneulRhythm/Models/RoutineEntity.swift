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
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}
