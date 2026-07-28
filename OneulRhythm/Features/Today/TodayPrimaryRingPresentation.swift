//
//  TodayPrimaryRingPresentation.swift
//  OneulRhythm
//
//  Sprint 19-2J — ring badge copy/trim derived only from primary role + time.
//

import CoreGraphics
import Foundation

enum TodayPrimaryRingPresentation {
    /// Remaining-time ring label for the primary rhythm card.
    /// Always follows `TodayPrimaryRole` — never reuses Upcoming ("곧") for Past.
    static func label(
        role: TodayPrimaryRole?,
        routine: Routine,
        now: Date
    ) -> String {
        switch role {
        case .next:
            return "곧"
        case .pastIncomplete:
            return routine.formattedTime
        case .current, nil:
            guard let endTime = routine.endTime else {
                return routine.formattedTime
            }
            let remainingMinutes = max(0, Int(endTime.timeIntervalSince(now) / 60))
            if remainingMinutes <= 0 {
                // Exact boundary before role flips — avoid Upcoming copy.
                return routine.formattedTime
            }
            return "\(remainingMinutes)분\n남음"
        }
    }

    /// Ring fill 0...1 for the primary rhythm card.
    static func trim(
        role: TodayPrimaryRole?,
        routine: Routine,
        now: Date
    ) -> CGFloat {
        switch role {
        case .pastIncomplete:
            return 0
        case .next:
            return 0.72
        case .current, nil:
            guard let endTime = routine.endTime else { return 0.72 }
            let totalDuration = endTime.timeIntervalSince(routine.startTime)
            guard totalDuration > 0 else { return 0.72 }
            let remainingDuration = max(0, endTime.timeIntervalSince(now))
            return CGFloat(min(1, remainingDuration / totalDuration))
        }
    }
}
