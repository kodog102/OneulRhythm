//
//  LiveActivityVisualQATests.swift
//  OneulRhythmTests
//
//  Renders Live Activity presentation views for Sprint 21-1 visual QA.
//

import SwiftUI
import UIKit
import XCTest
@testable import OneulRhythm

@MainActor
final class LiveActivityVisualQATests: XCTestCase {
    private var artifactsDirectory: URL {
        URL(fileURLWithPath: #filePath)
            .deletingLastPathComponent()
            .deletingLastPathComponent()
            .appendingPathComponent(".qa-artifacts/sprint-21-1-live-activity/after", isDirectory: true)
    }

    private let fixedNow: Date = {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(identifier: "Asia/Seoul")!
        return calendar.date(
            from: DateComponents(year: 2026, month: 7, day: 27, hour: 12, minute: 25)
        )!
    }()

    /// Test-local fixture — not part of the production Attributes API.
    private func fixtureState(
        now: Date,
        title: String = "아침 스트레칭",
        nextTitle: String? = "가벼운 산책",
        minutesUntilFocusEnd: Double = 7,
        minutesSinceFocusStart: Double = 3
    ) -> TodayRhythmActivityAttributes.ContentState {
        TodayRhythmActivityAttributes.ContentState(
            phase: .active,
            focusRoutineID: "visual-qa-focus",
            focusTitle: title,
            focusCategoryRawValue: "morning",
            focusStart: now.addingTimeInterval(-minutesSinceFocusStart * 60),
            focusEnd: now.addingTimeInterval(minutesUntilFocusEnd * 60),
            nextRoutineID: nextTitle == nil ? nil : "visual-qa-next",
            nextTitle: nextTitle,
            nextCategoryRawValue: nextTitle == nil ? nil : "movement",
            nextStart: nextTitle == nil ? nil : now.addingTimeInterval(30 * 60),
            updatedAt: now
        )
    }

    func testRenderLiveActivityPresentationStates() throws {
        // Artifacts land under `.qa-artifacts/` (gitignored). Supplemental
        // ImageRenderer evidence only — not a substitute for platform captures.
        try FileManager.default.createDirectory(
            at: artifactsDirectory,
            withIntermediateDirectories: true
        )

        let state = fixtureState(now: fixedNow)

        try snapshot(
            name: "01-expanded",
            size: CGSize(width: 360, height: 100),
            view: TodayRhythmExpandedCardView(state: state, now: fixedNow)
        )

        try snapshot(
            name: "02-notification-compact",
            size: CGSize(width: 360, height: 64),
            view: TodayRhythmNotificationCompactView(state: state, now: fixedNow)
        )

        try snapshot(
            name: "03-standby",
            size: CGSize(width: 520, height: 120),
            view: TodayRhythmStandByView(state: state, now: fixedNow)
        )

        try snapshot(
            name: "04-expanded-island",
            size: CGSize(width: 280, height: 72),
            view: HStack(alignment: .center, spacing: ORSpacing.sm) {
                TodayRhythmIslandCategoryMark(
                    state: state,
                    now: fixedNow,
                    size: TodayRhythmLiveActivityIslandMetrics.expandedMark
                )
                TodayRhythmIslandExpandedView(state: state, now: fixedNow)
            }
            .padding(ORSpacing.sm)
            .background(Color.black)
        )

        try snapshot(
            name: "05-compact",
            size: CGSize(width: 200, height: 40),
            view: HStack(spacing: ORSpacing.xs) {
                TodayRhythmIslandCategoryMark(
                    state: state,
                    now: fixedNow,
                    size: TodayRhythmLiveActivityIslandMetrics.compactMark
                )
                TodayRhythmIslandCompactTrailingView(state: state, now: fixedNow)
            }
            .padding(.horizontal, ORSpacing.sm)
            .padding(.vertical, ORSpacing.xs)
            .background(Capsule().fill(Color.black))
        )

        try snapshot(
            name: "06-minimal",
            size: CGSize(width: 44, height: 44),
            view: TodayRhythmIslandCategoryMark(
                state: state,
                now: fixedNow,
                size: TodayRhythmLiveActivityIslandMetrics.minimalMark
            )
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Circle().fill(Color.black))
        )

        try snapshot(
            name: "07-lock-screen-host",
            size: CGSize(width: 360, height: 100),
            view: TodayRhythmLockScreenView(state: state, now: fixedNow)
                .padding(.horizontal, 8)
        )
    }

    private func snapshot<V: View>(name: String, size: CGSize, view: V) throws {
        let root = view
            .frame(width: size.width, height: size.height)
            .environment(\.colorScheme, .light)

        let controller = UIHostingController(rootView: root)
        controller.view.bounds = CGRect(origin: .zero, size: size)
        controller.view.backgroundColor = .clear

        let window = UIWindow(frame: controller.view.bounds)
        window.rootViewController = controller
        window.makeKeyAndVisible()
        controller.view.setNeedsLayout()
        controller.view.layoutIfNeeded()

        let format = UIGraphicsImageRendererFormat()
        format.scale = 2
        format.opaque = false
        let renderer = UIGraphicsImageRenderer(size: size, format: format)
        let image = renderer.image { _ in
            controller.view.drawHierarchy(in: controller.view.bounds, afterScreenUpdates: true)
        }

        guard let data = image.pngData() else {
            XCTFail("Failed to encode \(name)")
            return
        }

        let url = artifactsDirectory.appendingPathComponent("\(name).png")
        try data.write(to: url)
    }
}
