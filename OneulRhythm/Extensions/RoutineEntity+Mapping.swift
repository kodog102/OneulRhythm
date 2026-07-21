//
//  RoutineEntity+Mapping.swift
//  OneulRhythm
//

import Foundation

extension RoutineEntity {
    func toDomain() -> Routine {
        guard
            let category = RoutineCategory(rawValue: categoryRawValue),
            let status = RoutineStatus(rawValue: statusRawValue)
        else {
            preconditionFailure("RoutineEntity contains an unsupported enum raw value.")
        }

        return Routine(
            id: id,
            title: title,
            startTime: startTime,
            endTime: endTime,
            category: category,
            status: status,
            recurringRhythmID: recurringRhythmID,
            occurrenceDate: occurrenceDate
        )
    }

    convenience init(
        routine: Routine,
        reminderMinutes: Int? = nil,
        createdAt: Date = Date(),
        updatedAt: Date = Date()
    ) {
        self.init(
            id: routine.id,
            title: routine.title,
            startTime: routine.startTime,
            endTime: routine.endTime,
            category: routine.category,
            status: routine.status == .current ? .upcoming : routine.status,
            reminderMinutes: reminderMinutes,
            recurringRhythmID: routine.recurringRhythmID,
            occurrenceDate: routine.occurrenceDate,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }
}
