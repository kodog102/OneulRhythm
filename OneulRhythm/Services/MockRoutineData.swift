//
//  MockRoutineData.swift
//  OneulRhythm
//

import Foundation

enum MockRoutineData {
    static let referenceDay: Date = {
        var components = DateComponents()
        components.year = 2026
        components.month = 7
        components.day = 14
        return Calendar.current.date(from: components) ?? Date()
    }()

    static let currentRoutine = Routine(
        title: "따뜻한 차 한잔 마시기",
        startTime: date(hour: 7, minute: 30),
        endTime: date(hour: 7, minute: 45),
        category: .morning,
        status: .current
    )

    static let nextRoutine = Routine(
        title: "가벼운 산책",
        startTime: date(hour: 8, minute: 0),
        endTime: nil,
        category: .movement,
        status: .upcoming
    )

    static func date(hour: Int, minute: Int, on day: Date = referenceDay) -> Date {
        Calendar.current.date(
            bySettingHour: hour,
            minute: minute,
            second: 0,
            of: day
        ) ?? day
    }
}
