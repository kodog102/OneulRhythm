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
                recurringRhythmRepository: makeRecurringRhythmRepository(),
                onSaveRoutine: saveRoutine,
                onUpdateRoutine: updateRoutine,
                onDeleteRoutine: deleteRoutine,
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

    private func updateRoutine(_ input: RoutineCreationInput) throws {
        let repository = makeRoutineRepository()
        let recurringRepository = makeRecurringRhythmRepository()
        let entities = try repository.fetchRoutines()
        let activeDefinitions = try recurringRepository.fetchActive()
        let hasActiveDefinition = activeDefinitions.contains { $0.id == input.id }

        if let recurrence = input.recurrence {
            if hasActiveDefinition {
                try updateRecurringRhythm(
                    id: input.id,
                    input: input,
                    recurrence: recurrence
                )
                try refreshOccurrences(
                    forDefinitionID: input.id,
                    input: input,
                    entities: entities,
                    repository: repository
                )
                return
            }

            guard let entity = entities.first(where: { $0.id == input.id }) else {
                throw RoutineRepositoryError.routineNotFound
            }
            let existing = entity.toDomain()

            if let definitionID = existing.recurringRhythmID {
                try updateRecurringRhythm(
                    id: definitionID,
                    input: input,
                    recurrence: recurrence
                )
                try repository.update(input)
                try refreshOccurrences(
                    forDefinitionID: definitionID,
                    input: input,
                    entities: entities.filter { $0.id != input.id },
                    repository: repository
                )
            } else {
                try repository.delete(id: input.id)
                try saveRecurringRhythm(input, recurrence: recurrence)
                syncDailyRhythms()
            }
            return
        }

        if hasActiveDefinition {
            let related = entities.filter { $0.recurringRhythmID == input.id }
            for relatedEntity in related {
                try repository.delete(relatedEntity)
            }
            try recurringRepository.deactivate(id: input.id)
            try repository.insert(input)
            return
        }

        guard let entity = entities.first(where: { $0.id == input.id }) else {
            throw RoutineRepositoryError.routineNotFound
        }
        let existing = entity.toDomain()

        if let definitionID = existing.recurringRhythmID {
            try recurringRepository.deactivate(id: definitionID)
            let related = entities.filter {
                $0.recurringRhythmID == definitionID && $0.id != input.id
            }
            for relatedEntity in related {
                try repository.delete(relatedEntity)
            }
            try repository.clearRecurrenceMetadata(id: input.id)
            try repository.update(input)
        } else {
            try repository.update(input)
        }
    }

    /// Deletes by Management identity: one-time routine id, or recurring definition id.
    private func deleteRoutine(id: UUID) throws {
        let repository = makeRoutineRepository()
        let recurringRepository = makeRecurringRhythmRepository()
        let entities = try repository.fetchRoutines()

        if let entity = entities.first(where: { $0.id == id }) {
            if let recurringRhythmID = entity.recurringRhythmID {
                try RecurringDefinitionDeletion.apply(
                    definitionID: recurringRhythmID,
                    entities: entities,
                    now: Date(),
                    dayPolicy: dayPolicy,
                    repository: repository,
                    recurringRepository: recurringRepository
                )
            } else {
                try repository.delete(entity)
            }
            return
        }

        try RecurringDefinitionDeletion.apply(
            definitionID: id,
            entities: entities,
            now: Date(),
            dayPolicy: dayPolicy,
            repository: repository,
            recurringRepository: recurringRepository
        )
    }

    private func refreshOccurrences(
        forDefinitionID definitionID: UUID,
        input: RoutineCreationInput,
        entities: [RoutineEntity],
        repository: RoutineRepository
    ) throws {
        let related = entities.filter { $0.recurringRhythmID == definitionID }
        for entity in related {
            guard let occurrenceDate = entity.occurrenceDate else { continue }
            let startTime = date(on: occurrenceDate, copyingTimeFrom: input.startTime)
            let endTime = input.endTime.map {
                date(on: occurrenceDate, copyingTimeFrom: $0)
            }
            try repository.update(
                RoutineCreationInput(
                    id: entity.id,
                    title: input.title,
                    startTime: startTime,
                    endTime: endTime,
                    category: input.category,
                    reminderMinutes: input.reminderMinutes
                )
            )
        }
    }

    private func date(on day: Date, copyingTimeFrom source: Date) -> Date {
        let calendar = dayPolicy.calendar
        let dayStart = dayPolicy.day(for: day)
        let hour = calendar.component(.hour, from: source)
        let minute = calendar.component(.minute, from: source)
        let second = calendar.component(.second, from: source)
        return calendar.date(
            bySettingHour: hour,
            minute: minute,
            second: second,
            of: dayStart
        ) ?? dayStart
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

    private func updateRecurringRhythm(
        id: UUID,
        input: RoutineCreationInput,
        recurrence: RecurrenceRule
    ) throws {
        let calendar = dayPolicy.calendar
        let startMinutes =
            calendar.component(.hour, from: input.startTime) * 60
            + calendar.component(.minute, from: input.startTime)

        try makeRecurringRhythmRepository().update(
            id: id,
            title: input.title,
            category: input.category,
            startMinutes: startMinutes,
            durationMinutes: durationMinutes(for: input),
            recurrence: recurrence,
            reminderMinutes: input.reminderMinutes
        )
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
