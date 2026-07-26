//
//  ManagementRhythmCatalog.swift
//  OneulRhythm
//

import Foundation

/// Sectioned Management list owned by `ManagementRhythmComposer`.
///
/// Recurring definitions and one-time plans remain separate; empty sections
/// are represented as empty arrays for the View to hide.
struct ManagementRhythmCatalog {
    var recurring: [ManagementRhythmItem]
    var oneTime: [ManagementRhythmItem]

    static let empty = ManagementRhythmCatalog(recurring: [], oneTime: [])

    var isEmpty: Bool {
        recurring.isEmpty && oneTime.isEmpty
    }

    /// Stable identity for quiet list insertion/removal animation.
    var contentIdentity: [UUID] {
        recurring.map(\.id) + oneTime.map(\.id)
    }

    func item(id: UUID) -> ManagementRhythmItem? {
        if let recurringItem = recurring.first(where: { $0.id == id }) {
            return recurringItem
        }
        return oneTime.first(where: { $0.id == id })
    }
}
