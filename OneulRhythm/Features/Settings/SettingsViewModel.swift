//
//  SettingsViewModel.swift
//  OneulRhythm
//
//  Settings orchestration — Sprint 21-2 connects reminder + Quiet Hours preferences
//  to notification delivery without changing Schedule Engine / Live Activity.
//

import Combine
import Foundation
import UIKit

@MainActor
final class SettingsViewModel: ObservableObject {
    @Published var remindersEnabled: Bool {
        didSet {
            guard remindersEnabled != preferenceStore.isEnabled else { return }
            preferenceStore.isEnabled = remindersEnabled
            Task { await applyReminderPreferenceChange() }
        }
    }

    @Published var quietHoursEnabled: Bool {
        didSet {
            guard quietHoursEnabled != quietHoursStore.isEnabled else { return }
            quietHoursStore.isEnabled = quietHoursEnabled
            Task { await applyQuietHoursPreferenceChange() }
        }
    }

    @Published var quietHoursStart: Date {
        didSet {
            let minutes = QuietHoursPolicy.minutesFromMidnight(quietHoursStart, calendar: calendar)
            guard minutes != quietHoursStore.startMinutes else { return }
            quietHoursStore.startMinutes = minutes
            Task { await applyQuietHoursPreferenceChange() }
        }
    }

    @Published var quietHoursEnd: Date {
        didSet {
            let minutes = QuietHoursPolicy.minutesFromMidnight(quietHoursEnd, calendar: calendar)
            guard minutes != quietHoursStore.endMinutes else { return }
            quietHoursStore.endMinutes = minutes
            Task { await applyQuietHoursPreferenceChange() }
        }
    }

    @Published private(set) var authorizationStatus: NotificationAuthorizationStatus = .notDetermined

    let appVersion: String

    private let preferenceStore: AppReminderPreferenceStore
    private let quietHoursStore: QuietHoursPreferenceStore
    private let notificationScheduling: NotificationScheduling
    private let calendar: Calendar

    init(
        preferenceStore: AppReminderPreferenceStore,
        quietHoursStore: QuietHoursPreferenceStore = QuietHoursPreferenceStore(),
        notificationScheduling: NotificationScheduling,
        calendar: Calendar = .current,
        bundle: Bundle = .main
    ) {
        self.preferenceStore = preferenceStore
        self.quietHoursStore = quietHoursStore
        self.notificationScheduling = notificationScheduling
        self.calendar = calendar
        self.remindersEnabled = preferenceStore.isEnabled
        self.quietHoursEnabled = quietHoursStore.isEnabled
        let referenceDay = Date()
        self.quietHoursStart = QuietHoursPolicy.date(
            on: referenceDay,
            minutesFromMidnight: quietHoursStore.startMinutes,
            calendar: calendar
        )
        self.quietHoursEnd = QuietHoursPolicy.date(
            on: referenceDay,
            minutesFromMidnight: quietHoursStore.endMinutes,
            calendar: calendar
        )
        self.appVersion = Self.resolveMarketingVersion(from: bundle)
    }

    /// Secondary status for `시스템 알림 설정` (Settings UI Spec).
    var systemNotificationStatusText: String {
        switch authorizationStatus {
        case .authorized:
            return "허용됨"
        case .denied:
            return "꺼짐"
        case .notDetermined:
            return "허용 필요"
        }
    }

    func refreshAuthorizationStatus() async {
        authorizationStatus = await notificationScheduling.authorizationStatus()
    }

    func openSystemNotificationSettings() {
        guard let url = URL(string: UIApplication.openNotificationSettingsURLString) else {
            return
        }
        UIApplication.shared.open(url)
    }

    func openFeedbackMail() {
        openMail(subject: "OneulRhythm 피드백")
    }

    func openContactMail() {
        openMail(subject: "OneulRhythm 문의")
    }

    private func applyReminderPreferenceChange() async {
        if !remindersEnabled {
            notificationScheduling.cancelAll()
            return
        }
        // Re-enable does not reschedule historical plans — Create/Edit schedules going forward.
        await suppressPendingInsideQuietHours()
    }

    private func applyQuietHoursPreferenceChange() async {
        guard remindersEnabled else { return }
        await suppressPendingInsideQuietHours()
    }

    /// Cancels pending reminder notifications whose trigger falls inside Quiet Hours.
    private func suppressPendingInsideQuietHours() async {
        let configuration = quietHoursStore.configuration
        guard configuration.isEnabled else { return }

        let pending = await notificationScheduling.pendingRequests()
        for request in pending {
            guard let triggerDate = request.triggerDate else { continue }
            if QuietHoursPolicy.contains(
                triggerDate,
                configuration: configuration,
                calendar: calendar
            ) {
                notificationScheduling.cancel(identifier: request.identifier)
            }
        }
    }

    private func openMail(subject: String) {
        // Stub destination — legal/product addresses deferred.
        var components = URLComponents()
        components.scheme = "mailto"
        components.path = "hello@oneulrhythm.app"
        components.queryItems = [
            URLQueryItem(name: "subject", value: subject)
        ]
        guard let url = components.url else { return }
        UIApplication.shared.open(url)
    }

    private static func resolveMarketingVersion(from bundle: Bundle) -> String {
        let version = bundle.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
        let trimmed = version?.trimmingCharacters(in: .whitespacesAndNewlines)
        if let trimmed, !trimmed.isEmpty {
            return trimmed
        }
        return "—"
    }
}
