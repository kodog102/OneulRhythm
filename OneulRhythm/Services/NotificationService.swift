//
//  NotificationService.swift
//  OneulRhythm
//

import Foundation
import UserNotifications

struct PendingNotificationRequest: Equatable {
    let identifier: String
    let title: String?
    let body: String?
    let triggerDate: Date?
}

protocol NotificationScheduling {
    func requestAuthorization() async throws -> Bool
    func schedule(
        identifier: String,
        title: String,
        body: String,
        at date: Date
    ) async throws
    func cancel(identifier: String)
    func cancelAll()
    func pendingRequests() async -> [PendingNotificationRequest]
}

final class NotificationService: NotificationScheduling {
    private let center: UNUserNotificationCenter
    private let calendar: Calendar

    init(
        center: UNUserNotificationCenter = .current(),
        calendar: Calendar = .current
    ) {
        self.center = center
        self.calendar = calendar
    }

    func requestAuthorization() async throws -> Bool {
        try await center.requestAuthorization(options: [.alert, .sound, .badge])
    }

    func schedule(
        identifier: String,
        title: String,
        body: String,
        at date: Date
    ) async throws {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default

        let components = calendar.dateComponents(
            [.year, .month, .day, .hour, .minute, .second],
            from: date
        )
        let trigger = UNCalendarNotificationTrigger(
            dateMatching: components,
            repeats: false
        )

        let request = UNNotificationRequest(
            identifier: identifier,
            content: content,
            trigger: trigger
        )

        try await center.add(request)
    }

    func cancel(identifier: String) {
        center.removePendingNotificationRequests(withIdentifiers: [identifier])
    }

    func cancelAll() {
        center.removeAllPendingNotificationRequests()
    }

    func pendingRequests() async -> [PendingNotificationRequest] {
        let requests = await center.pendingNotificationRequests()
        return requests.map { request in
            let triggerDate = (request.trigger as? UNCalendarNotificationTrigger)?
                .nextTriggerDate()

            return PendingNotificationRequest(
                identifier: request.identifier,
                title: request.content.title.isEmpty ? nil : request.content.title,
                body: request.content.body.isEmpty ? nil : request.content.body,
                triggerDate: triggerDate
            )
        }
    }
}
