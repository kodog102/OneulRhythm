//
//  NotificationTriggerPolicy.swift
//  OneulRhythm
//

import Foundation

/// Pure domain policy that computes when a reminder notification should fire.
///
/// Returns `nil` when no notification should be scheduled. Performs no
/// scheduling, persistence, or UserNotifications work.
enum NotificationTriggerPolicy {
    /// Computes the reminder trigger time for an occurrence.
    ///
    /// - Parameters:
    ///   - startTime: Rhythm start date.
    ///   - reminderMinutes: Minutes before `startTime` to fire, or `nil` when
    ///     no reminder is configured.
    ///   - now: Current date used for the future-only guard.
    ///   - calendar: Calendar used for minute offset arithmetic.
    /// - Returns: `startTime` minus `reminderMinutes`, or `nil` when
    ///   `reminderMinutes` is missing, calendar calculation fails, or the
    ///   trigger is not strictly after `now`.
    static func triggerDate(
        startTime: Date,
        reminderMinutes: Int?,
        now: Date,
        calendar: Calendar = .current
    ) -> Date? {
        guard let reminderMinutes else {
            return nil
        }

        guard let trigger = calendar.date(
            byAdding: .minute,
            value: -reminderMinutes,
            to: startTime
        ) else {
            return nil
        }

        guard trigger > now else {
            return nil
        }

        return trigger
    }
}
