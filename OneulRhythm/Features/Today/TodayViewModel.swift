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
    /// Becomes true after the first `loadRoutines()` finishes (success or failure).
    /// Prevents treating the empty bootstrap snapshot as Empty / Welcome before launch resolve.
    @Published private(set) var hasResolvedInitialSnapshot = false
    @Published private(set) var completingRoutineID: UUID?
    @Published private(set) var loadErrorMessage: String?
    @Published var completionErrorMessage: String?

    private let repository: RoutineRepository
    private let scheduleEngine: RoutineScheduleEngine
    private let liveActivityCoordinator: LiveActivityCoordinating
    private let nowProvider: () -> Date
    private let calendar: Calendar

    /// When true, a one-shot task is kept armed for the next timeline transition.
    private var isTimelineAutoRefreshEnabled = false
    private var timelineRefreshTask: Task<Void, Never>?

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

    /// Progress orients Active Today only — never Day Complete, Empty, or Welcome.
    var showsProgress: Bool {
        guard snapshot.totalCount > 0 else { return false }
        switch screenPresentation {
        case .dayComplete, .empty:
            return false
        case .upcoming, .current, .pastIncomplete:
            return true
        }
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
        defer {
            isLoading = false
            hasResolvedInitialSnapshot = true
        }

        do {
            try refreshRoutines()
        } catch {
            loadErrorMessage = "리듬을 불러오지 못했어요.\n잠시 후 다시 시도해주세요."
        }
    }

    /// Sprint 19-2I — arm timeline-driven refresh while Today is the visible surface.
    func startTimelineAutoRefresh() {
        isTimelineAutoRefreshEnabled = true
        rescheduleTimelineRefresh()
    }

    /// Sprint 19-2I — cancel pending wake-ups when Today is covered or leaves the hierarchy.
    func stopTimelineAutoRefresh() {
        isTimelineAutoRefreshEnabled = false
        timelineRefreshTask?.cancel()
        timelineRefreshTask = nil
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
        rescheduleTimelineRefresh()
    }

    /// Quiet re-resolve at a timeline boundary — no loading chrome (avoids flicker).
    private func performTimelineRefresh() {
        guard isTimelineAutoRefreshEnabled else { return }
        loadErrorMessage = nil
        do {
            try refreshRoutines()
        } catch {
            loadErrorMessage = "리듬을 불러오지 못했어요.\n잠시 후 다시 시도해주세요."
            rescheduleTimelineRefresh()
        }
    }

    private func rescheduleTimelineRefresh() {
        timelineRefreshTask?.cancel()
        timelineRefreshTask = nil
        guard isTimelineAutoRefreshEnabled else { return }

        let now = nowProvider()
        guard let next = TodayTimelineRefresh.nextTransitionDate(
            snapshot: snapshot,
            now: now,
            calendar: calendar
        ) else {
            return
        }

        let delay = next.timeIntervalSince(now)
        let sleepNanoseconds: UInt64
        if delay <= 0 {
            // Boundary already due (skew / exact hit) — refresh on the next run loop turn.
            sleepNanoseconds = 50_000_000
        } else {
            // Cap to avoid UInt64 overflow on distant dates; midnight is well within range.
            let capped = min(delay, 60 * 60 * 24 * 2)
            sleepNanoseconds = UInt64(capped * 1_000_000_000)
        }

        timelineRefreshTask = Task { @MainActor [weak self] in
            do {
                try await Task.sleep(nanoseconds: sleepNanoseconds)
            } catch {
                return
            }
            guard let self, !Task.isCancelled else { return }
            self.performTimelineRefresh()
        }
    }
}
