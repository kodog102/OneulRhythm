//
//  MockRoutineData.swift
//  OneulRhythm
//

import Foundation

enum MockRoutineData {
    static let currentRoutine = Routine(
        title: "따뜻한 차 한잔 마시기",
        startTime: "오전 7:30",
        endTime: "7:45",
        category: .morning,
        status: .current
    )

    static let nextRoutine = Routine(
        title: "가벼운 산책",
        startTime: "오전 8:00",
        endTime: nil,
        category: .movement,
        status: .upcoming
    )
}
