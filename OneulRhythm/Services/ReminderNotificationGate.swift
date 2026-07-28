//
//  ReminderNotificationGate.swift
//  OneulRhythm
//
//  Connects Settings reminder preferences to notification delivery (Sprint 21-2).
//  Filters desired reminder plans only — does not touch Schedule Engine / Live Activity.
//

import Foundation

/// Gates reminder notification delivery using app preferences.
enum ReminderNotificationGate {
    /// Returns whether a reminder at `triggerDate` should be delivered.
    static func shouldDeliver(
        triggerDate: Date,
        remindersEnabled: Bool,
        quietHours: QuietHoursConfiguration,
        calendar: Calendar = .current
    ) -> Bool {
        guard remindersEnabled else { return false }
        return !QuietHoursPolicy.contains(
            triggerDate,
            configuration: quietHours,
            calendar: calendar
        )
    }

    /// Filters a desired plan down to deliverable reminder items.
    static func filter(
        plan: NotificationPlan,
        remindersEnabled: Bool,
        quietHours: QuietHoursConfiguration,
        calendar: Calendar = .current
    ) -> NotificationPlan {
        guard remindersEnabled else {
            return NotificationPlan(items: [])
        }

        let items = plan.items.filter { item in
            shouldDeliver(
                triggerDate: item.triggerDate,
                remindersEnabled: true,
                quietHours: quietHours,
                calendar: calendar
            )
        }
        return NotificationPlan(items: items)
    }
}
