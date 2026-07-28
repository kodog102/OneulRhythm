//
//  TodaySceneVisualQATests.swift
//  OneulRhythmTests
//
//  Renders Today North Star layout skeleton for visual QA artifacts.
//

import SwiftUI
import UIKit
import XCTest
@testable import OneulRhythm

@MainActor
final class TodaySceneVisualQATests: XCTestCase {
    private var artifactsDirectory: URL {
        URL(fileURLWithPath: #filePath)
            .deletingLastPathComponent()
            .deletingLastPathComponent()
            .appendingPathComponent(".qa-artifacts/today-north-star", isDirectory: true)
    }

    func testRenderTodayNorthStarLayoutSkeleton() throws {
        guard ProcessInfo.processInfo.environment["TODAY_NORTH_STAR_VISUAL_QA"] == "1" else {
            throw XCTSkip("Set TODAY_NORTH_STAR_VISUAL_QA=1 in the test scheme to generate Today layout artifacts.")
        }

        try FileManager.default.createDirectory(
            at: artifactsDirectory,
            withIntermediateDirectories: true
        )

        try snapshot(
            name: "18-5-progress-flow",
            view: TodayView(
                repository: TodayScenePreviewRoutineRepository(
                    entities: TodayScenePreviewData.partialProgressWithNextEntities()
                ),
                recurringRhythmRepository: TodayScenePreviewRecurringRepository(),
                liveActivityCoordinator: TodayScenePreviewLiveActivityCoordinator(),
                nowProvider: { TodayScenePreviewData.nowDuringCurrentRoutine }
            )
            .environmentObject(AppLaunchState.previewCompleted())
            .environmentObject(
                FirstRhythmJourneyProgress.preview(hasCompletedFirstRhythmJourney: true)
            )
        )
    }

    /// Sprint 18-6 — Welcome / Normal Empty / Day Complete alignment with Active shell.
    func testRenderTodayStateAlignmentArtifacts() throws {
        guard ProcessInfo.processInfo.environment["TODAY_NORTH_STAR_VISUAL_QA"] == "1" else {
            throw XCTSkip("Set TODAY_NORTH_STAR_VISUAL_QA=1 in the test scheme to generate Today layout artifacts.")
        }

        try FileManager.default.createDirectory(
            at: artifactsDirectory,
            withIntermediateDirectories: true
        )

        try snapshot(
            name: "18-6-first-journey",
            view: TodayView(
                repository: TodayScenePreviewRoutineRepository(entities: []),
                recurringRhythmRepository: TodayScenePreviewRecurringRepository(),
                liveActivityCoordinator: TodayScenePreviewLiveActivityCoordinator(),
                nowProvider: { TodayScenePreviewData.morningNow }
            )
            .environmentObject(AppLaunchState.previewCompleted())
            .environmentObject(
                FirstRhythmJourneyProgress.preview(hasCompletedFirstRhythmJourney: false)
            )
        )

        try snapshot(
            name: "18-6-normal-empty",
            view: TodayView(
                repository: TodayScenePreviewRoutineRepository(entities: []),
                recurringRhythmRepository: TodayScenePreviewRecurringRepository(),
                liveActivityCoordinator: TodayScenePreviewLiveActivityCoordinator(),
                nowProvider: { TodayScenePreviewData.morningNow }
            )
            .environmentObject(AppLaunchState.previewCompleted())
            .environmentObject(
                FirstRhythmJourneyProgress.preview(hasCompletedFirstRhythmJourney: true)
            )
        )

        try snapshot(
            name: "18-6-day-complete",
            view: TodayView(
                repository: TodayScenePreviewRoutineRepository(
                    entities: TodayScenePreviewData.completedEntities()
                ),
                recurringRhythmRepository: TodayScenePreviewRecurringRepository(),
                liveActivityCoordinator: TodayScenePreviewLiveActivityCoordinator(),
                nowProvider: { TodayScenePreviewData.nowDuringCurrentRoutine }
            )
            .environmentObject(AppLaunchState.previewCompleted())
            .environmentObject(
                FirstRhythmJourneyProgress.preview(hasCompletedFirstRhythmJourney: true)
            )
        )
    }

    /// Sprint 18 Final QA — multi-device + accessibility visual evidence (verification only).
    func testRenderSprint18FinalQAMatrix() throws {
        guard ProcessInfo.processInfo.environment["TODAY_NORTH_STAR_VISUAL_QA"] == "1" else {
            throw XCTSkip("Set TODAY_NORTH_STAR_VISUAL_QA=1 in the test scheme to generate Today layout artifacts.")
        }

        try FileManager.default.createDirectory(
            at: artifactsDirectory,
            withIntermediateDirectories: true
        )

        let devices: [(suffix: String, size: CGSize)] = [
            ("small", CGSize(width: 320, height: 568)),
            ("standard", CGSize(width: 390, height: 844)),
            ("promax", CGSize(width: 430, height: 932))
        ]

        for device in devices {
            try snapshot(
                name: "18-final-active-\(device.suffix)",
                view: activeTodayView(),
                size: device.size
            )
            try snapshot(
                name: "18-final-first-journey-\(device.suffix)",
                view: firstJourneyView(),
                size: device.size
            )
            try snapshot(
                name: "18-final-normal-empty-\(device.suffix)",
                view: normalEmptyView(),
                size: device.size
            )
            try snapshot(
                name: "18-final-day-complete-\(device.suffix)",
                view: dayCompleteView(),
                size: device.size
            )
        }

        try snapshot(
            name: "18-final-active-dynamic-type-large",
            view: activeTodayView().environment(\.sizeCategory, .accessibilityLarge)
        )
        try snapshot(
            name: "18-final-first-journey-dynamic-type-large",
            view: firstJourneyView().environment(\.sizeCategory, .accessibilityLarge)
        )
        try snapshot(
            name: "18-final-active-dark",
            view: activeTodayView().preferredColorScheme(.dark)
        )
        try snapshot(
            name: "18-final-normal-empty-dark",
            view: normalEmptyView().preferredColorScheme(.dark)
        )
        try snapshot(
            name: "18-final-day-complete-dark",
            view: dayCompleteView().preferredColorScheme(.dark)
        )
    }

    /// Sprint 18.8 — First Journey small-height CTA fold + remaining-time ring ratio.
    func testRenderSprint188PolishArtifacts() throws {
        guard ProcessInfo.processInfo.environment["TODAY_NORTH_STAR_VISUAL_QA"] == "1" else {
            throw XCTSkip("Set TODAY_NORTH_STAR_VISUAL_QA=1 in the test scheme to generate Today layout artifacts.")
        }

        try FileManager.default.createDirectory(
            at: artifactsDirectory,
            withIntermediateDirectories: true
        )

        try snapshot(
            name: "18-8-after-first-journey-small",
            view: firstJourneyView(),
            size: CGSize(width: 320, height: 568)
        )

        try snapshot(
            name: "18-8-after-active-ring",
            view: activeTodayView(),
            size: CGSize(width: 390, height: 844)
        )

        // Confirm Standard Welcome remains the open (non-compact) rhythm.
        try snapshot(
            name: "18-8-after-first-journey-standard",
            view: firstJourneyView(),
            size: CGSize(width: 390, height: 844)
        )
    }

    /// Sprint 19-1A — shared atmosphere background presentation (Today Active).
    func testRenderSprint191AAtmosphereBackground() throws {
        guard ProcessInfo.processInfo.environment["TODAY_NORTH_STAR_VISUAL_QA"] == "1" else {
            throw XCTSkip("Set TODAY_NORTH_STAR_VISUAL_QA=1 in the test scheme to generate Today layout artifacts.")
        }

        try FileManager.default.createDirectory(
            at: artifactsDirectory,
            withIntermediateDirectories: true
        )

        try snapshot(
            name: "19-1A-after-active-atmosphere",
            view: activeTodayView(),
            size: CGSize(width: 390, height: 844)
        )
    }

    /// Sprint 19-1B — atmosphere calibration (localized light, preserved landscape).
    func testRenderSprint191BAtmosphereCalibration() throws {
        guard ProcessInfo.processInfo.environment["TODAY_NORTH_STAR_VISUAL_QA"] == "1" else {
            throw XCTSkip("Set TODAY_NORTH_STAR_VISUAL_QA=1 in the test scheme to generate Today layout artifacts.")
        }

        try FileManager.default.createDirectory(
            at: artifactsDirectory,
            withIntermediateDirectories: true
        )

        try snapshot(
            name: "19-1B-after-active-atmosphere",
            view: activeTodayView(),
            size: CGSize(width: 390, height: 844)
        )
    }

    /// Sprint 19-1C — bottom-only fog gradient (upper landscape clear; content untouched).
    func testRenderSprint191CBottomFogCorrection() throws {
        guard ProcessInfo.processInfo.environment["TODAY_NORTH_STAR_VISUAL_QA"] == "1" else {
            throw XCTSkip("Set TODAY_NORTH_STAR_VISUAL_QA=1 in the test scheme to generate Today layout artifacts.")
        }

        try FileManager.default.createDirectory(
            at: artifactsDirectory,
            withIntermediateDirectories: true
        )

        try snapshot(
            name: "19-1C-after-active-atmosphere",
            view: activeTodayView(),
            size: CGSize(width: 390, height: 844)
        )
    }

    /// Sprint 19-1D — bottom-anchored Active content (header top / stack from bottom).
    func testRenderSprint191DBottomAnchoredLayout() throws {
        guard ProcessInfo.processInfo.environment["TODAY_NORTH_STAR_VISUAL_QA"] == "1" else {
            throw XCTSkip("Set TODAY_NORTH_STAR_VISUAL_QA=1 in the test scheme to generate Today layout artifacts.")
        }

        try FileManager.default.createDirectory(
            at: artifactsDirectory,
            withIntermediateDirectories: true
        )

        try snapshot(
            name: "19-1D-after-active-small",
            view: activeTodayView(),
            size: CGSize(width: 320, height: 568)
        )
        try snapshot(
            name: "19-1D-after-active-standard",
            view: activeTodayView(),
            size: CGSize(width: 390, height: 844)
        )
        try snapshot(
            name: "19-1D-after-active-promax",
            view: activeTodayView(),
            size: CGSize(width: 430, height: 932)
        )
    }

    /// Sprint 19-1E — bottom-anchored First Journey / Normal Empty / Day Complete.
    func testRenderSprint191EStateLayoutAlignment() throws {
        guard ProcessInfo.processInfo.environment["TODAY_NORTH_STAR_VISUAL_QA"] == "1" else {
            throw XCTSkip("Set TODAY_NORTH_STAR_VISUAL_QA=1 in the test scheme to generate Today layout artifacts.")
        }

        try FileManager.default.createDirectory(
            at: artifactsDirectory,
            withIntermediateDirectories: true
        )

        let devices: [(suffix: String, size: CGSize)] = [
            ("small", CGSize(width: 320, height: 568)),
            ("standard", CGSize(width: 390, height: 844)),
            ("promax", CGSize(width: 430, height: 932))
        ]

        for device in devices {
            try snapshot(
                name: "19-1E-after-first-journey-\(device.suffix)",
                view: firstJourneyView(),
                size: device.size
            )
            try snapshot(
                name: "19-1E-after-normal-empty-\(device.suffix)",
                view: normalEmptyView(),
                size: device.size
            )
            try snapshot(
                name: "19-1E-after-day-complete-\(device.suffix)",
                view: dayCompleteView(),
                size: device.size
            )
        }
    }

    /// Sprint 19-1F — SE-class clipping correction + Standard regression.
    func testRenderSprint191FSmallHeightCorrection() throws {
        guard ProcessInfo.processInfo.environment["TODAY_NORTH_STAR_VISUAL_QA"] == "1" else {
            throw XCTSkip("Set TODAY_NORTH_STAR_VISUAL_QA=1 in the test scheme to generate Today layout artifacts.")
        }

        try FileManager.default.createDirectory(
            at: artifactsDirectory,
            withIntermediateDirectories: true
        )

        let small = CGSize(width: 320, height: 568)
        let standard = CGSize(width: 390, height: 844)

        try snapshot(name: "19-1F-after-first-journey-small", view: firstJourneyView(), size: small)
        try snapshot(name: "19-1F-after-normal-empty-small", view: normalEmptyView(), size: small)
        try snapshot(name: "19-1F-after-day-complete-small", view: dayCompleteView(), size: small)

        try snapshot(name: "19-1F-after-first-journey-standard", view: firstJourneyView(), size: standard)
        try snapshot(name: "19-1F-after-normal-empty-standard", view: normalEmptyView(), size: standard)
        try snapshot(name: "19-1F-after-day-complete-standard", view: dayCompleteView(), size: standard)
    }

    private func activeTodayView() -> some View {
        TodayView(
            repository: TodayScenePreviewRoutineRepository(
                entities: TodayScenePreviewData.partialProgressWithNextEntities()
            ),
            recurringRhythmRepository: TodayScenePreviewRecurringRepository(),
            liveActivityCoordinator: TodayScenePreviewLiveActivityCoordinator(),
            nowProvider: { TodayScenePreviewData.nowDuringCurrentRoutine }
        )
        .environmentObject(AppLaunchState.previewCompleted())
        .environmentObject(
            FirstRhythmJourneyProgress.preview(hasCompletedFirstRhythmJourney: true)
        )
    }

    private func firstJourneyView() -> some View {
        TodayView(
            repository: TodayScenePreviewRoutineRepository(entities: []),
            recurringRhythmRepository: TodayScenePreviewRecurringRepository(),
            liveActivityCoordinator: TodayScenePreviewLiveActivityCoordinator(),
            nowProvider: { TodayScenePreviewData.morningNow }
        )
        .environmentObject(AppLaunchState.previewCompleted())
        .environmentObject(
            FirstRhythmJourneyProgress.preview(hasCompletedFirstRhythmJourney: false)
        )
    }

    private func normalEmptyView() -> some View {
        TodayView(
            repository: TodayScenePreviewRoutineRepository(entities: []),
            recurringRhythmRepository: TodayScenePreviewRecurringRepository(),
            liveActivityCoordinator: TodayScenePreviewLiveActivityCoordinator(),
            nowProvider: { TodayScenePreviewData.morningNow }
        )
        .environmentObject(AppLaunchState.previewCompleted())
        .environmentObject(
            FirstRhythmJourneyProgress.preview(hasCompletedFirstRhythmJourney: true)
        )
    }

    private func dayCompleteView() -> some View {
        TodayView(
            repository: TodayScenePreviewRoutineRepository(
                entities: TodayScenePreviewData.completedEntities()
            ),
            recurringRhythmRepository: TodayScenePreviewRecurringRepository(),
            liveActivityCoordinator: TodayScenePreviewLiveActivityCoordinator(),
            nowProvider: { TodayScenePreviewData.nowDuringCurrentRoutine }
        )
        .environmentObject(AppLaunchState.previewCompleted())
        .environmentObject(
            FirstRhythmJourneyProgress.preview(hasCompletedFirstRhythmJourney: true)
        )
    }

    /// Sprint 18-5R — fixed checkpoint mapping examples.
    func testRenderFixedRhythmFlowProgressRatios() throws {
        try FileManager.default.createDirectory(
            at: artifactsDirectory,
            withIntermediateDirectories: true
        )

        let cases: [(name: String, completed: Int, total: Int)] = [
            ("18-5R-progress-1-of-2", 1, 2),
            ("18-5R-progress-2-of-6", 2, 6),
            ("18-5R-progress-6-of-12", 6, 12),
            ("18-5R-progress-18-of-20", 18, 20)
        ]

        for item in cases {
            try snapshotProgressCard(
                name: item.name,
                completed: item.completed,
                total: item.total
            )
        }
    }

    private func snapshotProgressCard(
        name: String,
        completed: Int,
        total: Int,
        size: CGSize = CGSize(width: 390, height: 160)
    ) throws {
        let view = VStack(alignment: .leading, spacing: ORSpacing.sm) {
            HStack {
                Text("오늘의 리듬")
                    .todayProgressLabelTypography()
                    .foregroundStyle(ORTodayTypography.supportingInk)
                Spacer(minLength: ORSpacing.xs)
                Text("\(completed) / \(total)")
                    .todayProgressCountTypography()
                    .foregroundStyle(ORTodayTypography.quietInk)
            }
            TodayRhythmFlowIndicator(completedCount: completed, totalCount: total)
        }
        .padding(.horizontal, ORSpacing.md)
        .padding(.vertical, ORSpacing.md)
        .orTodaySecondaryCard()
        .padding(ORSpacing.screenHorizontal)
        .frame(width: size.width, height: size.height)
        .background(
            LinearGradient(
                colors: [
                    Color(red: 0.96, green: 0.94, blue: 0.88),
                    Color(red: 0.78, green: 0.84, blue: 0.76)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
        )

        try snapshot(name: name, view: view, size: size)
    }

    private func snapshot<V: View>(
        name: String,
        view: V,
        size: CGSize = CGSize(width: 390, height: 844)
    ) throws {
        let root = view
            .frame(width: size.width, height: size.height)

        let host = UIHostingController(rootView: root)
        // Decouple from the host simulator's safe-area chrome (e.g. Pro home indicator on an
        // SE-sized UIWindow). Otherwise bottom inset content is laid out below the window bounds
        // and SE-class artifacts clip CTA / card / padding.
        host.safeAreaRegions = []
        host.view.bounds = CGRect(origin: .zero, size: size)
        host.view.backgroundColor = .clear
        host.view.clipsToBounds = true

        let window = UIWindow(frame: CGRect(origin: .zero, size: size))
        window.rootViewController = host
        window.makeKeyAndVisible()

        host.view.setNeedsLayout()
        host.view.layoutIfNeeded()

        let settle = expectation(description: "settle-\(name)")
        DispatchQueue.main.async {
            settle.fulfill()
        }
        wait(for: [settle], timeout: 1.0)
        host.view.setNeedsLayout()
        host.view.layoutIfNeeded()

        // Allow TodayView.task to load routines after launch sync.
        let load = expectation(description: "load-\(name)")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
            load.fulfill()
        }
        wait(for: [load], timeout: 2.0)
        host.view.setNeedsLayout()
        host.view.layoutIfNeeded()

        // Second pass — viewport-height preference (Welcome compact spacing) settles.
        let settlePreference = expectation(description: "preference-\(name)")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
            settlePreference.fulfill()
        }
        wait(for: [settlePreference], timeout: 1.0)
        host.view.setNeedsLayout()
        host.view.layoutIfNeeded()

        let format = UIGraphicsImageRendererFormat()
        format.scale = 2
        format.opaque = true
        let renderer = UIGraphicsImageRenderer(size: size, format: format)
        let image = renderer.image { _ in
            host.view.drawHierarchy(in: host.view.bounds, afterScreenUpdates: true)
        }

        guard let data = image.pngData() else {
            XCTFail("Failed to encode \(name).png")
            return
        }

        let url = artifactsDirectory.appendingPathComponent("\(name).png")
        try data.write(to: url, options: .atomic)
        print("Wrote \(url.path)")
    }
}

@MainActor
private final class TodayScenePreviewRoutineRepository: RoutineRepository {
    private var entities: [RoutineEntity]

    init(entities: [RoutineEntity]) {
        self.entities = entities
    }

    func fetchRoutines() throws -> [RoutineEntity] { entities }
    func insert(_ input: RoutineCreationInput) throws {}
    func insert(_ routine: RoutineEntity) throws { entities.append(routine) }
    func update(_ input: RoutineCreationInput) throws {}
    func clearRecurrenceMetadata(id: UUID) throws {}
    func updateStatus(id: UUID, status: RoutineStatus) throws {
        guard let index = entities.firstIndex(where: { $0.id == id }) else {
            throw RoutineRepositoryError.routineNotFound
        }
        entities[index].statusRawValue = status.rawValue
        entities[index].updatedAt = Date()
    }
    func delete(_ routine: RoutineEntity) throws {
        entities.removeAll { $0.id == routine.id }
    }
    func delete(id: UUID) throws {
        entities.removeAll { $0.id == id }
    }
    func hasOccurrence(recurringRhythmID: UUID, occurrenceDate: Date) throws -> Bool {
        entities.contains {
            $0.recurringRhythmID == recurringRhythmID && $0.occurrenceDate == occurrenceDate
        }
    }
}

@MainActor
private final class TodayScenePreviewRecurringRepository: RecurringRhythmRepository {
    func insert(_ definition: RecurringRhythmEntity) throws {}
    func fetchActive() throws -> [RecurringRhythmEntity] { [] }
    func update(
        id: UUID,
        title: String,
        category: RoutineCategory,
        startMinutes: Int,
        durationMinutes: Int,
        recurrence: RecurrenceRule,
        reminderMinutes: Int?
    ) throws {}
    func deactivate(id: UUID) throws {}
}

private struct TodayScenePreviewLiveActivityCoordinator: LiveActivityCoordinating {
    func sync(snapshot: TodayRhythmSnapshot) {}
    func end() {}
}

private enum TodayScenePreviewData {
    static var morningNow: Date {
        MockRoutineData.date(hour: 9, minute: 0)
    }

    static var nowDuringCurrentRoutine: Date {
        MockRoutineData.date(hour: 7, minute: 35)
    }

    @MainActor
    static func completedEntities() -> [RoutineEntity] {
        [
            RoutineEntity(
                routine: Routine(
                    title: "아침 스트레칭",
                    startTime: MockRoutineData.date(hour: 6, minute: 30),
                    endTime: MockRoutineData.date(hour: 6, minute: 45),
                    category: .morning,
                    status: .completed
                )
            ),
            RoutineEntity(
                routine: Routine(
                    title: "따뜻한 차 한잔 마시기",
                    startTime: MockRoutineData.date(hour: 7, minute: 0),
                    endTime: MockRoutineData.date(hour: 7, minute: 20),
                    category: .morning,
                    status: .completed
                )
            )
        ]
    }

    @MainActor
    static func currentWithNextEntities() -> [RoutineEntity] {
        [
            RoutineEntity(
                routine: MockRoutineData.currentRoutine.updatingStatus(.upcoming)
            ),
            RoutineEntity(
                routine: MockRoutineData.nextRoutine
            )
        ]
    }

    /// Partial day for Progress Flow QA — completed + current + next.
    @MainActor
    static func partialProgressWithNextEntities() -> [RoutineEntity] {
        [
            RoutineEntity(
                routine: Routine(
                    title: "아침 스트레칭",
                    startTime: MockRoutineData.date(hour: 6, minute: 30),
                    endTime: MockRoutineData.date(hour: 6, minute: 45),
                    category: .morning,
                    status: .completed
                )
            ),
            RoutineEntity(
                routine: Routine(
                    title: "따뜻한 차 한잔 마시기",
                    startTime: MockRoutineData.date(hour: 7, minute: 0),
                    endTime: MockRoutineData.date(hour: 7, minute: 20),
                    category: .morning,
                    status: .completed
                )
            ),
            RoutineEntity(
                routine: MockRoutineData.currentRoutine.updatingStatus(.upcoming)
            ),
            RoutineEntity(
                routine: MockRoutineData.nextRoutine
            ),
            RoutineEntity(
                routine: Routine(
                    title: "짧은 정리",
                    startTime: MockRoutineData.date(hour: 9, minute: 0),
                    endTime: MockRoutineData.date(hour: 9, minute: 15),
                    category: .focus,
                    status: .upcoming
                )
            ),
            RoutineEntity(
                routine: Routine(
                    title: "저녁 산책",
                    startTime: MockRoutineData.date(hour: 19, minute: 0),
                    endTime: MockRoutineData.date(hour: 19, minute: 30),
                    category: .movement,
                    status: .upcoming
                )
            )
        ]
    }
}
