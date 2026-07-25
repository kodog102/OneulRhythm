//
//  FirstRhythmJourneyProgress.swift
//  OneulRhythm
//

import Combine
import Foundation

/// Persists whether the user has ever successfully created a rhythm.
///
/// DR-015: First Journey ends only after successful first creation.
/// Independent of how many rhythms currently exist.
@MainActor
final class FirstRhythmJourneyProgress: ObservableObject {
    /// UserDefaults key for first successful rhythm creation.
    static let storageKey =
        "oneulRhythm.firstRhythmJourney.hasSuccessfullyCreatedRhythm"

    @Published private(set) var hasCompletedFirstRhythmJourney: Bool

    private let defaults: UserDefaults
    private let key: String

    init(
        defaults: UserDefaults = .standard,
        key: String? = nil
    ) {
        let resolvedKey = key ?? Self.storageKey
        self.defaults = defaults
        self.key = resolvedKey
        self.hasCompletedFirstRhythmJourney = defaults.bool(forKey: resolvedKey)
    }

    /// Marks First Journey complete. Idempotent; safe on every successful create.
    func markFirstRhythmCreated() {
        guard !hasCompletedFirstRhythmJourney else { return }
        hasCompletedFirstRhythmJourney = true
        defaults.set(true, forKey: key)
    }
}

extension FirstRhythmJourneyProgress {
    /// Isolated defaults so Canvas previews never touch production preferences.
    static func preview(hasCompletedFirstRhythmJourney: Bool) -> FirstRhythmJourneyProgress {
        let suiteName = "oneulRhythm.preview.firstRhythmJourney.\(UUID().uuidString)"
        let defaults = UserDefaults(suiteName: suiteName) ?? .standard
        defaults.removePersistentDomain(forName: suiteName)
        let progress = FirstRhythmJourneyProgress(defaults: defaults)
        if hasCompletedFirstRhythmJourney {
            progress.markFirstRhythmCreated()
        }
        return progress
    }
}
