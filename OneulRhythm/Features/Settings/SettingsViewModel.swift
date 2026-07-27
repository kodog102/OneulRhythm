//
//  SettingsViewModel.swift
//  OneulRhythm
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
        }
    }

    @Published private(set) var authorizationStatus: NotificationAuthorizationStatus = .notDetermined

    let appVersion: String

    private let preferenceStore: AppReminderPreferenceStore
    private let notificationScheduling: NotificationScheduling

    init(
        preferenceStore: AppReminderPreferenceStore,
        notificationScheduling: NotificationScheduling,
        bundle: Bundle = .main
    ) {
        self.preferenceStore = preferenceStore
        self.notificationScheduling = notificationScheduling
        self.remindersEnabled = preferenceStore.isEnabled
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
