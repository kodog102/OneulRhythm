//
//  AppReminderPreferenceStore.swift
//  OneulRhythm
//

import Foundation

/// Persists the app-wide reminder preference (Settings → 알림 → 리마인더).
///
/// Owns product preference only. Does not grant OS permission or schedule
/// notifications. Notification pipeline consumption is deferred.
struct AppReminderPreferenceStore {
    static let storageKey = "oneulRhythm.settings.remindersEnabled"

    private let defaults: UserDefaults
    private let key: String

    /// Default `true` — Less Input; product may attempt reminders when OS allows.
    init(
        defaults: UserDefaults = .standard,
        key: String = Self.storageKey,
        defaultEnabled: Bool = true
    ) {
        self.defaults = defaults
        self.key = key
        if defaults.object(forKey: key) == nil {
            defaults.set(defaultEnabled, forKey: key)
        }
    }

    var isEnabled: Bool {
        get { defaults.bool(forKey: key) }
        nonmutating set { defaults.set(newValue, forKey: key) }
    }
}
