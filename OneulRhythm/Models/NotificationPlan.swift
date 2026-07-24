//
//  NotificationPlan.swift
//  OneulRhythm
//

import Foundation

/// Desired notification state for a set of rhythms.
///
/// Pure value model. Contains no Apple framework types, scheduling logic,
/// or side effects. Pending-request reconciliation belongs to
/// `NotificationSynchronization` / `NotificationScheduling`.
struct NotificationPlan: Equatable {
    let items: [NotificationPlanItem]

    init(items: [NotificationPlanItem] = []) {
        self.items = items
    }
}

/// A single desired notification within a `NotificationPlan`.
///
/// Pure value model. Trigger calculation belongs to
/// `NotificationTriggerPolicy`; delivery belongs to `NotificationScheduling`.
struct NotificationPlanItem: Equatable {
    let identifier: String
    let title: String
    let body: String
    let triggerDate: Date
}
