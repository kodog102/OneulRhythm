//
//  NotificationSynchronization.swift
//  OneulRhythm
//

import Foundation

/// A minimal change required to reconcile pending notifications with a
/// desired `NotificationPlan`.
///
/// Pure value. Contains no Apple framework types or side effects.
enum NotificationSyncChange: Equatable {
    /// Cancel a pending request that is absent from the desired plan,
    /// or that must be replaced before rescheduling.
    case remove(identifier: String)
    /// Schedule a desired plan item that is missing or was replaced.
    case schedule(NotificationPlanItem)
}

/// Pure reconciliation between desired notification state and pending requests.
///
/// Computes the minimal deterministic set of remove/schedule operations.
/// Does not calculate trigger dates, apply business rules, or touch
/// UserNotifications.
enum NotificationSynchronization {
    /// Returns the minimal ordered changes that make pending match desired.
    ///
    /// Ordering:
    /// 1. All removes, sorted by identifier
    /// 2. All schedules, sorted by triggerDate then identifier
    ///
    /// An update is expressed as remove + schedule for the same identifier.
    static func changes(
        desired: NotificationPlan,
        pending: [PendingNotificationRequest]
    ) -> [NotificationSyncChange] {
        let pendingByIdentifier = Dictionary(
            pending.map { ($0.identifier, $0) },
            uniquingKeysWith: { first, _ in first }
        )
        let desiredByIdentifier = Dictionary(
            desired.items.map { ($0.identifier, $0) },
            uniquingKeysWith: { first, _ in first }
        )

        var removals: [String] = []
        var schedules: [NotificationPlanItem] = []

        for identifier in pendingByIdentifier.keys.sorted() {
            guard let pendingRequest = pendingByIdentifier[identifier] else {
                continue
            }

            guard let desiredItem = desiredByIdentifier[identifier] else {
                removals.append(identifier)
                continue
            }

            if matches(pending: pendingRequest, desired: desiredItem) {
                continue
            }

            removals.append(identifier)
            schedules.append(desiredItem)
        }

        for identifier in desiredByIdentifier.keys.sorted() {
            guard pendingByIdentifier[identifier] == nil,
                  let desiredItem = desiredByIdentifier[identifier]
            else {
                continue
            }

            schedules.append(desiredItem)
        }

        schedules.sort(by: Self.isScheduleOrderedBefore)

        let removeChanges = removals.map(NotificationSyncChange.remove)
        let scheduleChanges = schedules.map(NotificationSyncChange.schedule)
        return removeChanges + scheduleChanges
    }

    private static func matches(
        pending: PendingNotificationRequest,
        desired: NotificationPlanItem
    ) -> Bool {
        pending.identifier == desired.identifier
            && pending.title == desired.title
            && pending.body == desired.body
            && pending.triggerDate == desired.triggerDate
    }

    private static func isScheduleOrderedBefore(
        _ lhs: NotificationPlanItem,
        _ rhs: NotificationPlanItem
    ) -> Bool {
        if lhs.triggerDate != rhs.triggerDate {
            return lhs.triggerDate < rhs.triggerDate
        }

        return lhs.identifier < rhs.identifier
    }
}
