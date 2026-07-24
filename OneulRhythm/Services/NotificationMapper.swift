//
//  NotificationMapper.swift
//  OneulRhythm
//

import Foundation

/// Pure mapper from domain rhythms to a desired `NotificationPlan`.
///
/// Uses `NotificationTriggerPolicy` as the single trigger-date policy.
/// Performs no scheduling, persistence, or UserNotifications work.
enum NotificationMapper {
    private static let notificationTitle = "리듬 시작"

    /// Builds a deterministic notification plan for the given rhythms.
    ///
    /// - Parameters:
    ///   - routines: Candidate rhythms. Rhythms without a schedulable
    ///     reminder are omitted.
    ///   - now: Current date forwarded to the trigger policy.
    ///   - calendar: Calendar used for trigger calculation.
    /// - Returns: Desired notification state. Empty when nothing should
    ///   be scheduled.
    static func makePlan(
        routines: [Routine],
        now: Date,
        calendar: Calendar
    ) -> NotificationPlan {
        let items = routines.compactMap { routine -> NotificationPlanItem? in
            guard let triggerDate = NotificationTriggerPolicy.triggerDate(
                startTime: routine.startTime,
                reminderMinutes: routine.reminderMinutes,
                now: now,
                calendar: calendar
            ) else {
                return nil
            }

            return NotificationPlanItem(
                identifier: routine.id.uuidString,
                title: notificationTitle,
                body: body(for: routine.title),
                triggerDate: triggerDate
            )
        }
        .sorted(by: Self.isOrderedBefore)

        return NotificationPlan(items: items)
    }

    private static func body(for title: String) -> String {
        "\"\(title)\" 리듬을 시작할 시간이에요."
    }

    /// Deterministic ordering: earlier trigger first, then identifier.
    private static func isOrderedBefore(
        _ lhs: NotificationPlanItem,
        _ rhs: NotificationPlanItem
    ) -> Bool {
        if lhs.triggerDate != rhs.triggerDate {
            return lhs.triggerDate < rhs.triggerDate
        }

        return lhs.identifier < rhs.identifier
    }
}
