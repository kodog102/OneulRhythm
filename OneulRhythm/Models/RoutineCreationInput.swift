//
//  RoutineCreationInput.swift
//  OneulRhythm
//

import Foundation

struct RoutineCreationInput {
    let id: UUID
    let title: String
    let startTime: Date
    let endTime: Date?
    let category: RoutineCategory
    let reminderMinutes: Int?

    init(
        id: UUID = UUID(),
        title: String,
        startTime: Date,
        endTime: Date?,
        category: RoutineCategory,
        reminderMinutes: Int?
    ) {
        self.id = id
        self.title = title
        self.startTime = startTime
        self.endTime = endTime
        self.category = category
        self.reminderMinutes = reminderMinutes
    }
}
