//
//  AppLaunchState.swift
//  OneulRhythm
//

import Foundation
import Combine

/// App-level launch progress for ordering Today load after initial sync.
///
/// Owns only whether the initial recurring-rhythm sync attempt has finished.
/// Does not perform sync or load routines.
@MainActor
final class AppLaunchState: ObservableObject {
    @Published private(set) var didCompleteInitialRhythmSync = false

    /// Marks the initial sync attempt as finished (success or failure).
    func completeInitialRhythmSync() {
        didCompleteInitialRhythmSync = true
    }
}

extension AppLaunchState {
    /// Preview / non-app hosts skip launch sync and start already complete.
    static func previewCompleted() -> AppLaunchState {
        let state = AppLaunchState()
        state.completeInitialRhythmSync()
        return state
    }
}
