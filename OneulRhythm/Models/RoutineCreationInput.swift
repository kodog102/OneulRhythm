//
//  RoutineCreationInput.swift
//  OneulRhythm
//

import Foundation

struct RoutineCreationInput {
    let title: String
    let startTime: Date
    let endTime: Date?
    let category: RoutineCategory
    let reminderMinutes: Int?
}
