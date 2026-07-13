//
//  TodayViewModel.swift
//  OneulRhythm
//

import Combine
import Foundation

@MainActor
final class TodayViewModel: ObservableObject {
    @Published private(set) var currentRoutine: Routine
    let nextRoutine: Routine

    init(
        currentRoutine: Routine? = nil,
        nextRoutine: Routine? = nil
    ) {
        self.currentRoutine = currentRoutine ?? MockRoutineData.currentRoutine
        self.nextRoutine = nextRoutine ?? MockRoutineData.nextRoutine
    }

    func completeCurrentRoutine() {
        currentRoutine = currentRoutine.updatingStatus(.completed)
    }

    func snoozeCurrentRoutine() {
        print("10분 뒤에 다시 알림")
    }
}
