//
//  LiveActivityReconcilePlanner.swift
//  OneulRhythm
//
//  Pure reconcile decisions for the one-day Live Activity (Sprint 21-11).
//  No ActivityKit calls — coordinator executes the plan.
//

import Foundation

/// Eligible ActivityKit session descriptor for planning (testable without ActivityKit timing).
struct LiveActivitySessionDescriptor: Equatable {
    let id: String
    let dayID: String
    let phase: TodayRhythmActivityAttributes.Phase
    let updatedAt: Date
    let isEligible: Bool
}

/// Commands the coordinator executes against ActivityKit.
enum LiveActivityReconcileCommand: Equatable {
    /// End every eligible session (empty snapshot / activities disabled cleanup).
    case endAllEligible
    /// End eligible sessions whose dayID differs from today's payload.
    case endOtherDays(keepingDayID: String)
    /// Day complete: end same-day eligible sessions with final content (no replacement request).
    case endDayComplete(activityIDs: [String], content: TodayRhythmActivityAttributes.ContentState)
    /// End duplicate same-day sessions that are not the canonical winner.
    case endDuplicates(activityIDs: [String])
    /// Push latest ContentState to the canonical same-day session.
    case update(activityID: String, content: TodayRhythmActivityAttributes.ContentState)
    /// No same-day eligible session — request a new Activity (`pushType` remains nil).
    case request(TodayRhythmActivityPayload)
}

/// Foreground-sync reconcile policy — mirrors `LiveActivityCoordinator` behavior without ActivityKit.
enum LiveActivityReconcilePlanner {
    static func plan(
        desiredPayload: TodayRhythmActivityPayload?,
        sessions: [LiveActivitySessionDescriptor]
    ) -> [LiveActivityReconcileCommand] {
        let eligible = sessions.filter(\.isEligible)

        guard let desiredPayload else {
            return eligible.isEmpty ? [] : [.endAllEligible]
        }

        var commands: [LiveActivityReconcileCommand] = [
            .endOtherDays(keepingDayID: desiredPayload.attributes.dayID)
        ]

        let sameDay = eligible.filter { $0.dayID == desiredPayload.attributes.dayID }

        if desiredPayload.contentState.phase == .dayComplete {
            if !sameDay.isEmpty {
                commands.append(
                    .endDayComplete(
                        activityIDs: sameDay.map(\.id),
                        content: desiredPayload.contentState
                    )
                )
            }
            return commands
        }

        let canonical = selectCanonical(from: sameDay)
        let duplicates = sameDay.filter { $0.id != canonical?.id }.map(\.id)
        if !duplicates.isEmpty {
            commands.append(.endDuplicates(activityIDs: duplicates))
        }

        if let canonical {
            commands.append(
                .update(
                    activityID: canonical.id,
                    content: desiredPayload.contentState
                )
            )
        } else {
            commands.append(.request(desiredPayload))
        }

        return commands
    }

    /// Same selection rule as the coordinator: latest `updatedAt`, then lexicographically smallest id.
    static func selectCanonical(
        from sessions: [LiveActivitySessionDescriptor]
    ) -> LiveActivitySessionDescriptor? {
        sessions.min { lhs, rhs in
            if lhs.updatedAt != rhs.updatedAt {
                return lhs.updatedAt > rhs.updatedAt
            }
            return lhs.id < rhs.id
        }
    }
}
