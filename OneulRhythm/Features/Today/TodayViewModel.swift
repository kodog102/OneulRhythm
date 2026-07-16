//
//  TodayViewModel.swift
//  OneulRhythm
//

import Combine
import Foundation

@MainActor
final class TodayViewModel: ObservableObject {
    @Published private(set) var snapshot: TodayRhythmSnapshot
    @Published private(set) var isLoading = false
    @Published private(set) var completingRoutineID: UUID?
    @Published private(set) var loadErrorMessage: String?
    @Published var completionErrorMessage: String?

    private let repository: RoutineRepository
    private let scheduleEngine: RoutineScheduleEngine
    private let liveActivityCoordinator: LiveActivityCoordinating
    private let nowProvider: () -> Date
    private let calendar: Calendar

    init(
        repository: RoutineRepository,
        scheduleEngine: RoutineScheduleEngine = RoutineScheduleEngine(),
        liveActivityCoordinator: LiveActivityCoordinating? = nil,
        nowProvider: @escaping () -> Date = Date.init,
        calendar: Calendar = .current
    ) {
        self.repository = repository
        self.scheduleEngine = scheduleEngine
        self.liveActivityCoordinator = liveActivityCoordinator
            ?? LiveActivityCoordinator(calendar: calendar, nowProvider: nowProvider)
        self.nowProvider = nowProvider
        self.calendar = calendar
        self.snapshot = TodayRhythmSnapshot(
            schedule: RoutineSchedule(
                routines: [],
                currentRoutine: nil,
                overdueRoutines: [],
                nextRoutine: nil
            ),
            date: nowProvider()
        )
    }

    var routines: [Routine] {
        snapshot.routines
    }

    var currentRoutine: Routine? {
        snapshot.currentRoutine
    }

    var overdueRoutines: [Routine] {
        snapshot.overdueRoutines
    }

    var nextRoutine: Routine? {
        snapshot.nextRoutine
    }

    var completedRoutineCount: Int {
        snapshot.completedCount
    }

    var totalRoutineCount: Int {
        snapshot.totalCount
    }

    var progress: Double {
        snapshot.progress
    }

    var isComplete: Bool {
        snapshot.isComplete
    }

    var formattedTodayDate: String {
        var format = Date.FormatStyle()
            .month(.wide)
            .day()
            .weekday(.wide)
            .locale(Locale(identifier: "ko_KR"))
        format.calendar = calendar
        return nowProvider().formatted(format)
    }

    var progressMessage: String {
        guard snapshot.totalCount > 0 else {
            return "오늘의 첫 리듬을 만들어보세요."
        }

        if snapshot.completedCount == 0 {
            return "첫 리듬부터 천천히 시작해보세요."
        }

        if snapshot.isComplete {
            return "오늘의 리듬을 모두 이어냈어요."
        }

        return "오늘의 흐름이 차분하게 이어지고 있어요."
    }

    func loadRoutines() {
        isLoading = true
        loadErrorMessage = nil
        defer { isLoading = false }

        do {
            try refreshRoutines()
        } catch {
            loadErrorMessage = "리듬을 불러오지 못했어요.\n잠시 후 다시 시도해주세요."
        }
    }

    func completeRoutine(_ routine: Routine) {
        guard completingRoutineID == nil else { return }
        guard !routine.isCompleted else { return }

        completingRoutineID = routine.id
        completionErrorMessage = nil
        defer { completingRoutineID = nil }

        do {
            try repository.updateStatus(id: routine.id, status: .completed)
        } catch {
            completionErrorMessage = "잠시 후 다시 시도해주세요."
            return
        }

        do {
            try refreshRoutines()
        } catch {
            loadErrorMessage = "리듬을 불러오지 못했어요.\n잠시 후 다시 시도해주세요."
        }
    }

    func isCompleting(_ routine: Routine) -> Bool {
        completingRoutineID == routine.id
    }

    private func refreshRoutines() throws {
        let persisted = try repository.fetchRoutines().map { $0.toDomain() }
        let now = nowProvider()
        let schedule = scheduleEngine.resolve(
            routines: persisted,
            now: now,
            calendar: calendar
        )

        snapshot = TodayRhythmSnapshot(schedule: schedule, date: now)
        liveActivityCoordinator.sync(snapshot: snapshot)
    }
}
