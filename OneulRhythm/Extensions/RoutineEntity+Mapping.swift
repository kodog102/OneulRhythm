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
            startTime: startTime.formatted(Self.domainTimeFormat),
            endTime: endTime?.formatted(Self.domainTimeFormat),
            category: category,
            status: status
        )
    }

    convenience init(
        routine: Routine,
        startTime: Date,
        endTime: Date?,
        reminderMinutes: Int? = nil,
        createdAt: Date = Date(),
        updatedAt: Date = Date()
    ) {
        self.init(
            id: routine.id,
            title: routine.title,
            startTime: startTime,
            endTime: endTime,
            category: routine.category,
            status: routine.status,
            reminderMinutes: reminderMinutes,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }

    private static let domainTimeFormat = Date.FormatStyle(
        date: .omitted,
        time: .shortened
    )
}
