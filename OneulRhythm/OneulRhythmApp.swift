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
    /// Composed at launch; initial sync is triggered once via the root `.task`.
    private let dailyRhythmSyncCoordinator: DailyRhythmSyncCoordinator
    private let initialDailyRhythmSyncGate = InitialDailyRhythmSyncGate()

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
        self.dailyRhythmSyncCoordinator = DailyRhythmSyncCoordinator(
            provisioner: provisioner
        )
    }

    var body: some Scene {
        WindowGroup {
            TodayView(
                repository: makeRoutineRepository(),
                onSaveRoutine: saveRoutine
            )
            .task {
                performInitialDailyRhythmSyncIfNeeded()
            }
        }
        .modelContainer(sharedModelContainer)
    }

    private func performInitialDailyRhythmSyncIfNeeded() {
        guard initialDailyRhythmSyncGate.markStartedIfNeeded() else { return }

        do {
            try dailyRhythmSyncCoordinator.sync(for: Date())
        } catch {
            Self.logger.error(
                "Failed to sync daily rhythms: \(String(describing: error), privacy: .public)"
            )
        }
    }

    private func saveRoutine(_ input: RoutineCreationInput) throws {
        try makeRoutineRepository().insert(input)
    }

    private func makeRoutineRepository() -> SwiftDataRoutineRepository {
        SwiftDataRoutineRepository(
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
