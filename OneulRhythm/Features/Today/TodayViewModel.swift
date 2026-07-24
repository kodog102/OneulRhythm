//
//  TodayViewModel.swift
//  OneulRhythm
//

import Combine
import Foundation

/// Today screen presentation states defined by Today-UI-Specification.
enum TodayScreenPresentation: Equatable {
    case empty
    case upcoming
    case current
    case pastIncomplete
    case dayComplete
}

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

    var pastIncompleteRoutine: Routine? {
        snapshot.pastIncompleteRoutine
    }

    /// Snapshot-owned primary rhythm; ViewModel only forwards presentation state.
    var primaryRhythm: Routine? {
        snapshot.primaryRhythm
    }

    var primaryRole: TodayPrimaryRole? {
        snapshot.primaryRole
    }

    /// Quiet secondary preview when primary is current or past incomplete.
    var secondaryNextRoutine: Routine? {
        guard let primaryRole else { return nil }
        switch primaryRole {
        case .current, .pastIncomplete:
            return snapshot.nextRoutine
        case .next:
            return nil
        }
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

    /// Approved Product greeting contract from Today-UI-Specification.
    var greetingText: String {
        let hour = calendar.component(.hour, from: nowProvider())
        switch hour {
        case 5..<12:
            return "좋은 아침이에요."
        case 12..<18:
            return "좋은 오후예요."
        default:
            return "편안한 저녁이에요."
        }
    }

    /// Presentation mapping for Today screen states.
    /// Derived only from existing snapshot facts — no schedule logic.
    var screenPresentation: TodayScreenPresentation {
        if snapshot.totalCount == 0 {
            return .empty
        }

        if snapshot.isComplete {
            return .dayComplete
        }

        switch snapshot.primaryRole {
        case .current:
            return .current
        case .pastIncomplete:
            return .pastIncomplete
        case .next:
            return .upcoming
        case nil:
            return .empty
        }
    }

    /// Progress is available whenever today has at least one rhythm.
    var showsProgress: Bool {
        snapshot.totalCount > 0
    }

    /// Completion is possible only for Current and Past Incomplete.
    var showsCompletionButton: Bool {
        switch primaryRole {
        case .current, .pastIncomplete:
            return true
        case .next, nil:
            return false
        }
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
