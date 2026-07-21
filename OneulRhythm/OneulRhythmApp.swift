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
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            RoutineEntity.self,
            RecurringRhythmEntity.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

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
