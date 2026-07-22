//
//  OneulRhythmApp.swift
//  OneulRhythm
//
//  Created by 이유진 on 6/4/26.
//

import SwiftUI
import SwiftData
import os

@main
struct OneulRhythmApp: App {
    private static let logger = Logger(
        subsystem: Bundle.main.bundleIdentifier ?? "OneulRhythm",
        category: "DailyRhythmSync"
    )

    private let sharedModelContainer: ModelContainer
    private let dayPolicy: CalendarDayPolicy
    /// Composed at launch; sync is owned exclusively by the App layer.
    private let dailyRhythmSyncCoordinator: DailyRhythmSyncCoordinator
    private let initialDailyRhythmSyncGate = InitialDailyRhythmSyncGate()
    @StateObject private var launchState = AppLaunchState()

    init() {
        let schema = Schema([
            RoutineEntity.self,
            RecurringRhythmEntity.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        let container: ModelContainer
        do {
            container = try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }

        let modelContext = container.mainContext
        let dayPolicy = CalendarDayPolicy()
        let provisioner = DailyRhythmProvisioner(
            recurringRhythmRepository: SwiftDataRecurringRhythmRepository(
                modelContext: modelContext
            ),
            routineRepository: SwiftDataRoutineRepository(
                modelContext: modelContext
            ),
            recurrenceEngine: RecurrenceEngine(dayPolicy: dayPolicy),
            dateTimeMaterializer: OccurrenceDateTimeMaterializer(dayPolicy: dayPolicy)
        )

        self.sharedModelContainer = container
        self.dayPolicy = dayPolicy
        self.dailyRhythmSyncCoordinator = DailyRhythmSyncCoordinator(
            provisioner: provisioner
        )
    }

    var body: some Scene {
        WindowGroup {
            TodayView(
                repository: makeRoutineRepository(),
                onSaveRoutine: saveRoutine,
                onAppBecomeActive: syncDailyRhythms
            )
            .environmentObject(launchState)
            .task {
                performInitialDailyRhythmSyncIfNeeded()
            }
        }
        .modelContainer(sharedModelContainer)
    }

    private func performInitialDailyRhythmSyncIfNeeded() {
        guard initialDailyRhythmSyncGate.markStartedIfNeeded() else { return }
        defer {
            launchState.completeInitialRhythmSync()
        }

        syncDailyRhythms()
    }

    /// Synchronizes recurring definitions into today's routines.
    /// Safe to call on cold launch and every foreground activation.
    private func syncDailyRhythms() {
        do {
            try dailyRhythmSyncCoordinator.sync(for: Date())
        } catch {
            Self.logger.error(
                "Failed to sync daily rhythms: \(String(describing: error), privacy: .public)"
            )
        }
    }

    private func saveRoutine(_ input: RoutineCreationInput) throws {
        if let recurrence = input.recurrence {
            try saveRecurringRhythm(input, recurrence: recurrence)
            syncDailyRhythms()
        } else {
            try makeRoutineRepository().insert(input)
        }
    }

    private func saveRecurringRhythm(
        _ input: RoutineCreationInput,
        recurrence: RecurrenceRule
    ) throws {
        let calendar = dayPolicy.calendar
        let startMinutes =
            calendar.component(.hour, from: input.startTime) * 60
            + calendar.component(.minute, from: input.startTime)

        let definition = RecurringRhythmEntity(
            id: input.id,
            title: input.title,
            category: input.category,
            startMinutes: startMinutes,
            durationMinutes: durationMinutes(for: input),
            recurrence: recurrence,
            startDate: dayPolicy.day(for: input.startTime),
            reminderMinutes: input.reminderMinutes,
            isActive: true
        )

        try makeRecurringRhythmRepository().insert(definition)
    }

    private func durationMinutes(for input: RoutineCreationInput) -> Int {
        guard let endTime = input.endTime else {
            return Int(RoutineTimingPolicy.defaultActiveDuration / 60)
        }

        let seconds = endTime.timeIntervalSince(input.startTime)
        if seconds > 0 {
            return max(1, Int((seconds / 60).rounded()))
        }

        // Same-day pickers with end before start: treat as overnight span.
        let overnightSeconds = seconds + 24 * 60 * 60
        return max(1, Int((overnightSeconds / 60).rounded()))
    }

    private func makeRoutineRepository() -> SwiftDataRoutineRepository {
        SwiftDataRoutineRepository(
            modelContext: sharedModelContainer.mainContext
        )
    }

    private func makeRecurringRhythmRepository() -> SwiftDataRecurringRhythmRepository {
        SwiftDataRecurringRhythmRepository(
            modelContext: sharedModelContainer.mainContext
        )
    }
}

/// Ensures launch sync runs at most once even if SwiftUI re-enters `.task`.
@MainActor
private final class InitialDailyRhythmSyncGate {
    private var didStart = false

    /// Returns `true` the first time it is called; subsequent calls return `false`.
    func markStartedIfNeeded() -> Bool {
        guard !didStart else { return false }
        didStart = true
        return true
    }
}
