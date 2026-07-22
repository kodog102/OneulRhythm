//
//  OneulRhythmApp.swift
//  OneulRhythm
//
//  Created by 이유진 on 6/4/26.
//

import SwiftUI
import SwiftData

@main
struct OneulRhythmApp: App {
    private let sharedModelContainer: ModelContainer
    /// Retained for the upcoming lifecycle sync task; not invoked at launch.
    private let dailyRhythmSyncCoordinator: DailyRhythmSyncCoordinator

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
        }
        .modelContainer(sharedModelContainer)
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
