//
//  QuietHoursPreferenceStore.swift
//  OneulRhythm
//
//  Settings → 알림 → 조용한 시간 preference (Sprint 21-2).
//  Owns product preference only — does not schedule or interpret rhythms.
//

import Foundation

/// Persists Quiet Hours enablement and wall-clock window.
///
/// Quiet Hours suppresses reminder *notifications* only. It must not affect
/// Today, Live Activity, Schedule Engine, or routine generation.
struct QuietHoursPreferenceStore {
    static let enabledKey = "oneulRhythm.settings.quietHours.enabled"
    static let startMinutesKey = "oneulRhythm.settings.quietHours.startMinutes"
    static let endMinutesKey = "oneulRhythm.settings.quietHours.endMinutes"

    /// Default window: 22:00 → 07:00 (overnight).
    static let defaultStartMinutes = 22 * 60
    static let defaultEndMinutes = 7 * 60

    private let defaults: UserDefaults

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        if defaults.object(forKey: Self.enabledKey) == nil {
            defaults.set(false, forKey: Self.enabledKey)
        }
        if defaults.object(forKey: Self.startMinutesKey) == nil {
            defaults.set(Self.defaultStartMinutes, forKey: Self.startMinutesKey)
        }
        if defaults.object(forKey: Self.endMinutesKey) == nil {
            defaults.set(Self.defaultEndMinutes, forKey: Self.endMinutesKey)
        }
    }

    var isEnabled: Bool {
        get { defaults.bool(forKey: Self.enabledKey) }
        nonmutating set { defaults.set(newValue, forKey: Self.enabledKey) }
    }

    /// Minutes from midnight (0...1439).
    var startMinutes: Int {
        get { clampedMinutes(defaults.integer(forKey: Self.startMinutesKey)) }
        nonmutating set { defaults.set(clampedMinutes(newValue), forKey: Self.startMinutesKey) }
    }

    /// Minutes from midnight (0...1439).
    var endMinutes: Int {
        get { clampedMinutes(defaults.integer(forKey: Self.endMinutesKey)) }
        nonmutating set { defaults.set(clampedMinutes(newValue), forKey: Self.endMinutesKey) }
    }

    var configuration: QuietHoursConfiguration {
        QuietHoursConfiguration(
            isEnabled: isEnabled,
            startMinutes: startMinutes,
            endMinutes: endMinutes
        )
    }

    private func clampedMinutes(_ value: Int) -> Int {
        min(max(value, 0), (24 * 60) - 1)
    }
}

/// Immutable Quiet Hours window snapshot for pure policy evaluation.
struct QuietHoursConfiguration: Equatable {
    var isEnabled: Bool
    var startMinutes: Int
    var endMinutes: Int
}
