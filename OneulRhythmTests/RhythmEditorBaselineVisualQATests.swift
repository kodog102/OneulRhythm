//
//  RhythmEditorBaselineVisualQATests.swift
//  OneulRhythmTests
//
//  Sprint 19-2A — Rhythm Editor baseline visual audit artifacts only.
//  Does not assert layout; writes screenshots under .qa-artifacts/rhythm-editor-baseline/.
//

import SwiftUI
import UIKit
import XCTest
@testable import OneulRhythm

@MainActor
final class RhythmEditorBaselineVisualQATests: XCTestCase {
    private let calendar: Calendar = {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(identifier: "Asia/Seoul")!
        calendar.locale = Locale(identifier: "ko_KR")
        return calendar
    }()

    /// Fixed morning — keeps picker chrome stable across captures.
    private lazy var morningNow: Date = {
        var components = DateComponents()
        components.year = 2026
        components.month = 7
        components.day = 14
        components.hour = 7
        components.minute = 45
        return calendar.date(from: components)!
    }()

    private lazy var eightAM: Date = {
        calendar.date(
            bySettingHour: 8,
            minute: 0,
            second: 0,
            of: morningNow
        ) ?? morningNow
    }()

    private lazy var eightThirtyAM: Date = {
        calendar.date(
            bySettingHour: 8,
            minute: 30,
            second: 0,
            of: morningNow
        ) ?? morningNow
    }()

    private var artifactsDirectory: URL {
        URL(fileURLWithPath: #filePath)
            .deletingLastPathComponent()
            .deletingLastPathComponent()
            .appendingPathComponent(".qa-artifacts/rhythm-editor-baseline", isDirectory: true)
    }

    private var layoutArtifactsDirectory: URL {
        URL(fileURLWithPath: #filePath)
            .deletingLastPathComponent()
            .deletingLastPathComponent()
            .appendingPathComponent(".qa-artifacts/rhythm-editor-layout", isDirectory: true)
    }

    private var polishArtifactsDirectory: URL {
        URL(fileURLWithPath: #filePath)
            .deletingLastPathComponent()
            .deletingLastPathComponent()
            .appendingPathComponent(".qa-artifacts/rhythm-editor-polish", isDirectory: true)
    }

    private var simplifyArtifactsDirectory: URL {
        URL(fileURLWithPath: #filePath)
            .deletingLastPathComponent()
            .deletingLastPathComponent()
            .appendingPathComponent(".qa-artifacts/rhythm-editor-simplify", isDirectory: true)
    }

    private var floatingSaveArtifactsDirectory: URL {
        URL(fileURLWithPath: #filePath)
            .deletingLastPathComponent()
            .deletingLastPathComponent()
            .appendingPathComponent(".qa-artifacts/rhythm-editor-floating-save", isDirectory: true)
    }

    private var boundsArtifactsDirectory: URL {
        URL(fileURLWithPath: #filePath)
            .deletingLastPathComponent()
            .deletingLastPathComponent()
            .appendingPathComponent(".qa-artifacts/rhythm-editor-bounds", isDirectory: true)
    }

    private var navigationStandardArtifactsDirectory: URL {
        URL(fileURLWithPath: #filePath)
            .deletingLastPathComponent()
            .deletingLastPathComponent()
            .appendingPathComponent(".qa-artifacts/rhythm-editor-navigation", isDirectory: true)
    }

    /// Sprint 19-2A baseline — current AddRoutineView on SE / Standard / Pro Max.
    func testRenderSprint192ARhythmEditorBaseline() throws {
        guard ProcessInfo.processInfo.environment["RHYTHM_EDITOR_VISUAL_QA"] == "1" else {
            throw XCTSkip("Set RHYTHM_EDITOR_VISUAL_QA=1 to generate Rhythm Editor baseline artifacts.")
        }

        try FileManager.default.createDirectory(
            at: artifactsDirectory,
            withIntermediateDirectories: true
        )

        let small = CGSize(width: 320, height: 568)
        let standard = CGSize(width: 390, height: 844)
        let proMax = CGSize(width: 430, height: 932)

        try snapshot(
            name: "19-2A-create-one-time-small",
            view: createOneTimeView(),
            size: small,
            directory: artifactsDirectory
        )
        try snapshot(
            name: "19-2A-create-one-time-standard",
            view: createOneTimeView(),
            size: standard,
            directory: artifactsDirectory
        )
        try snapshot(
            name: "19-2A-create-one-time-promax",
            view: createOneTimeView(),
            size: proMax,
            directory: artifactsDirectory
        )

        try snapshot(
            name: "19-2A-create-recurring-standard",
            view: createRecurringView(),
            size: standard,
            directory: artifactsDirectory
        )

        try snapshot(
            name: "19-2A-edit-one-time-standard",
            view: editOneTimeView(),
            size: standard,
            directory: artifactsDirectory
        )
        try snapshot(
            name: "19-2A-edit-recurring-standard",
            view: editRecurringView(),
            size: standard,
            directory: artifactsDirectory
        )

        // Best-effort keyboard state: Create focuses the title on appear.
        // Simulator hosting may not paint the system keyboard into the snapshot.
        try snapshot(
            name: "19-2A-keyboard-standard",
            view: createOneTimeView(),
            size: standard,
            directory: artifactsDirectory,
            settleForKeyboard: true
        )
    }

    /// Sprint 19-2B — Layout DNA (atmosphere, header, card regroup, bottom Save).
    func testRenderSprint192BRhythmEditorLayoutDNA() throws {
        guard ProcessInfo.processInfo.environment["RHYTHM_EDITOR_VISUAL_QA"] == "1" else {
            throw XCTSkip("Set RHYTHM_EDITOR_VISUAL_QA=1 to generate Rhythm Editor layout artifacts.")
        }

        try FileManager.default.createDirectory(
            at: layoutArtifactsDirectory,
            withIntermediateDirectories: true
        )

        let small = CGSize(width: 320, height: 568)
        let standard = CGSize(width: 390, height: 844)
        let proMax = CGSize(width: 430, height: 932)

        try snapshot(
            name: "19-2B-create-small",
            view: createOneTimeView(),
            size: small,
            directory: layoutArtifactsDirectory
        )
        try snapshot(
            name: "19-2B-create-filled-small",
            view: createRecurringView(),
            size: small,
            directory: layoutArtifactsDirectory
        )
        try snapshot(
            name: "19-2B-create-standard",
            view: createOneTimeView(),
            size: standard,
            directory: layoutArtifactsDirectory
        )
        try snapshot(
            name: "19-2B-create-promax",
            view: createOneTimeView(),
            size: proMax,
            directory: layoutArtifactsDirectory
        )

        try snapshot(
            name: "19-2B-edit-standard",
            view: editOneTimeView(),
            size: standard,
            directory: layoutArtifactsDirectory
        )
        try snapshot(
            name: "19-2B-edit-promax",
            view: editOneTimeView(),
            size: proMax,
            directory: layoutArtifactsDirectory
        )

        try snapshot(
            name: "19-2B-create-recurring-standard",
            view: createRecurringView(),
            size: standard,
            directory: layoutArtifactsDirectory
        )

        try snapshot(
            name: "19-2B-keyboard-standard",
            view: createOneTimeView(),
            size: standard,
            directory: layoutArtifactsDirectory,
            settleForKeyboard: true
        )
    }

    /// Sprint 19-2C — Visual polish (scrim, disabled CTA, card depth). Layout unchanged from 19-2B.
    func testRenderSprint192CRhythmEditorVisualPolish() throws {
        guard ProcessInfo.processInfo.environment["RHYTHM_EDITOR_VISUAL_QA"] == "1" else {
            throw XCTSkip("Set RHYTHM_EDITOR_VISUAL_QA=1 to generate Rhythm Editor polish artifacts.")
        }

        try FileManager.default.createDirectory(
            at: polishArtifactsDirectory,
            withIntermediateDirectories: true
        )

        let small = CGSize(width: 320, height: 568)
        let standard = CGSize(width: 390, height: 844)
        let proMax = CGSize(width: 430, height: 932)

        try snapshot(
            name: "19-2C-create-empty-small",
            view: createOneTimeView(),
            size: small,
            directory: polishArtifactsDirectory
        )
        try snapshot(
            name: "19-2C-create-empty-standard",
            view: createOneTimeView(),
            size: standard,
            directory: polishArtifactsDirectory
        )
        try snapshot(
            name: "19-2C-create-empty-promax",
            view: createOneTimeView(),
            size: proMax,
            directory: polishArtifactsDirectory
        )

        try snapshot(
            name: "19-2C-create-filled-small",
            view: createRecurringView(),
            size: small,
            directory: polishArtifactsDirectory
        )
        try snapshot(
            name: "19-2C-create-filled-standard",
            view: createRecurringView(),
            size: standard,
            directory: polishArtifactsDirectory
        )
        try snapshot(
            name: "19-2C-create-filled-promax",
            view: createRecurringView(),
            size: proMax,
            directory: polishArtifactsDirectory
        )

        try snapshot(
            name: "19-2C-edit-standard",
            view: editOneTimeView(),
            size: standard,
            directory: polishArtifactsDirectory
        )
        try snapshot(
            name: "19-2C-edit-promax",
            view: editOneTimeView(),
            size: proMax,
            directory: polishArtifactsDirectory
        )
    }

    /// Sprint 19-2D — Content simplification + scroll/bottom-action clearance.
    func testRenderSprint192DRhythmEditorContentSimplification() throws {
        guard ProcessInfo.processInfo.environment["RHYTHM_EDITOR_VISUAL_QA"] == "1" else {
            throw XCTSkip("Set RHYTHM_EDITOR_VISUAL_QA=1 to generate Rhythm Editor simplification artifacts.")
        }

        try FileManager.default.createDirectory(
            at: simplifyArtifactsDirectory,
            withIntermediateDirectories: true
        )

        let small = CGSize(width: 320, height: 568)
        let standard = CGSize(width: 390, height: 844)
        let proMax = CGSize(width: 430, height: 932)

        try snapshot(
            name: "19-2D-create-empty-small",
            view: createOneTimeView(),
            size: small,
            directory: simplifyArtifactsDirectory
        )
        try snapshot(
            name: "19-2D-create-empty-standard",
            view: createOneTimeView(),
            size: standard,
            directory: simplifyArtifactsDirectory
        )
        try snapshot(
            name: "19-2D-create-empty-promax",
            view: createOneTimeView(),
            size: proMax,
            directory: simplifyArtifactsDirectory
        )

        try snapshot(
            name: "19-2D-create-filled-small",
            view: createRecurringView(),
            size: small,
            directory: simplifyArtifactsDirectory
        )
        try snapshot(
            name: "19-2D-create-filled-standard",
            view: createRecurringView(),
            size: standard,
            directory: simplifyArtifactsDirectory
        )
        try snapshot(
            name: "19-2D-create-filled-promax",
            view: createRecurringView(),
            size: proMax,
            directory: simplifyArtifactsDirectory
        )

        try snapshot(
            name: "19-2D-edit-standard",
            view: editOneTimeView(),
            size: standard,
            directory: simplifyArtifactsDirectory
        )
        try snapshot(
            name: "19-2D-edit-promax",
            view: editOneTimeView(),
            size: proMax,
            directory: simplifyArtifactsDirectory
        )

        // Reminder section scrolled fully above fixed Save (SE is the tightest).
        try snapshot(
            name: "19-2D-reminder-above-save-small",
            view: createRecurringView(),
            size: small,
            directory: simplifyArtifactsDirectory,
            scrollToBottom: true
        )
        try snapshot(
            name: "19-2D-reminder-above-save-standard",
            view: createRecurringView(),
            size: standard,
            directory: simplifyArtifactsDirectory,
            scrollToBottom: true
        )
    }

    /// Sprint 19-2E — Remove bottom CTA scrim; Save floats over landscape.
    func testRenderSprint192ERhythmEditorFloatingSave() throws {
        guard ProcessInfo.processInfo.environment["RHYTHM_EDITOR_VISUAL_QA"] == "1" else {
            throw XCTSkip("Set RHYTHM_EDITOR_VISUAL_QA=1 to generate Rhythm Editor floating-save artifacts.")
        }

        try FileManager.default.createDirectory(
            at: floatingSaveArtifactsDirectory,
            withIntermediateDirectories: true
        )

        let small = CGSize(width: 320, height: 568)
        let standard = CGSize(width: 390, height: 844)
        let proMax = CGSize(width: 430, height: 932)

        // Disabled Save (empty title)
        try snapshot(
            name: "19-2E-disabled-small",
            view: createOneTimeView(),
            size: small,
            directory: floatingSaveArtifactsDirectory
        )
        try snapshot(
            name: "19-2E-disabled-standard",
            view: createOneTimeView(),
            size: standard,
            directory: floatingSaveArtifactsDirectory
        )
        try snapshot(
            name: "19-2E-disabled-promax",
            view: createOneTimeView(),
            size: proMax,
            directory: floatingSaveArtifactsDirectory
        )

        // Enabled Save (filled title)
        try snapshot(
            name: "19-2E-enabled-small",
            view: createRecurringView(),
            size: small,
            directory: floatingSaveArtifactsDirectory
        )
        try snapshot(
            name: "19-2E-enabled-standard",
            view: createRecurringView(),
            size: standard,
            directory: floatingSaveArtifactsDirectory
        )
        try snapshot(
            name: "19-2E-enabled-promax",
            view: createRecurringView(),
            size: proMax,
            directory: floatingSaveArtifactsDirectory
        )

        // Reminder scrolled fully above floating Save
        try snapshot(
            name: "19-2E-reminder-above-save-small",
            view: createRecurringView(),
            size: small,
            directory: floatingSaveArtifactsDirectory,
            scrollToBottom: true
        )
        try snapshot(
            name: "19-2E-reminder-above-save-standard",
            view: createRecurringView(),
            size: standard,
            directory: floatingSaveArtifactsDirectory,
            scrollToBottom: true
        )
        try snapshot(
            name: "19-2E-reminder-above-save-promax",
            view: createRecurringView(),
            size: proMax,
            directory: floatingSaveArtifactsDirectory,
            scrollToBottom: true
        )
    }

    /// Sprint 19-2F — Restore navigation chrome + ScrollView viewport above Save.
    func testRenderSprint192FRhythmEditorNavAndScrollBounds() throws {
        guard ProcessInfo.processInfo.environment["RHYTHM_EDITOR_VISUAL_QA"] == "1" else {
            throw XCTSkip("Set RHYTHM_EDITOR_VISUAL_QA=1 to generate Rhythm Editor bounds artifacts.")
        }

        try FileManager.default.createDirectory(
            at: boundsArtifactsDirectory,
            withIntermediateDirectories: true
        )

        let small = CGSize(width: 320, height: 568)
        let standard = CGSize(width: 390, height: 844)
        let proMax = CGSize(width: 430, height: 932)

        try snapshot(
            name: "19-2F-create-empty-small",
            view: createOneTimeView(),
            size: small,
            directory: boundsArtifactsDirectory
        )
        try snapshot(
            name: "19-2F-create-empty-standard",
            view: createOneTimeView(),
            size: standard,
            directory: boundsArtifactsDirectory
        )
        try snapshot(
            name: "19-2F-create-empty-promax",
            view: createOneTimeView(),
            size: proMax,
            directory: boundsArtifactsDirectory
        )

        try snapshot(
            name: "19-2F-create-filled-small",
            view: createRecurringView(),
            size: small,
            directory: boundsArtifactsDirectory
        )
        try snapshot(
            name: "19-2F-create-filled-standard",
            view: createRecurringView(),
            size: standard,
            directory: boundsArtifactsDirectory
        )
        try snapshot(
            name: "19-2F-create-filled-promax",
            view: createRecurringView(),
            size: proMax,
            directory: boundsArtifactsDirectory
        )

        try snapshot(
            name: "19-2F-edit-standard",
            view: editOneTimeView(),
            size: standard,
            directory: boundsArtifactsDirectory
        )
        try snapshot(
            name: "19-2F-edit-promax",
            view: editOneTimeView(),
            size: proMax,
            directory: boundsArtifactsDirectory
        )

        try snapshot(
            name: "19-2F-reminder-above-save-small",
            view: createRecurringView(),
            size: small,
            directory: boundsArtifactsDirectory,
            scrollToBottom: true
        )
        try snapshot(
            name: "19-2F-reminder-above-save-standard",
            view: createRecurringView(),
            size: standard,
            directory: boundsArtifactsDirectory,
            scrollToBottom: true
        )
        try snapshot(
            name: "19-2F-reminder-above-save-promax",
            view: createRecurringView(),
            size: proMax,
            directory: boundsArtifactsDirectory,
            scrollToBottom: true
        )
    }

    /// Sprint 19-2G — Transparent navigation standard on Rhythm Editor.
    func testRenderSprint192GRhythmEditorNavigationStandard() throws {
        guard ProcessInfo.processInfo.environment["RHYTHM_EDITOR_VISUAL_QA"] == "1" else {
            throw XCTSkip("Set RHYTHM_EDITOR_VISUAL_QA=1 to generate Rhythm Editor navigation artifacts.")
        }

        try FileManager.default.createDirectory(
            at: navigationStandardArtifactsDirectory,
            withIntermediateDirectories: true
        )

        let small = CGSize(width: 320, height: 568)
        let standard = CGSize(width: 390, height: 844)
        let proMax = CGSize(width: 430, height: 932)

        try snapshot(
            name: "19-2G-create-empty-small",
            view: createOneTimeView(),
            size: small,
            directory: navigationStandardArtifactsDirectory
        )
        try snapshot(
            name: "19-2G-create-empty-standard",
            view: createOneTimeView(),
            size: standard,
            directory: navigationStandardArtifactsDirectory
        )
        try snapshot(
            name: "19-2G-create-empty-promax",
            view: createOneTimeView(),
            size: proMax,
            directory: navigationStandardArtifactsDirectory
        )

        try snapshot(
            name: "19-2G-create-filled-small",
            view: createRecurringView(),
            size: small,
            directory: navigationStandardArtifactsDirectory
        )
        try snapshot(
            name: "19-2G-create-filled-standard",
            view: createRecurringView(),
            size: standard,
            directory: navigationStandardArtifactsDirectory
        )
        try snapshot(
            name: "19-2G-create-filled-promax",
            view: createRecurringView(),
            size: proMax,
            directory: navigationStandardArtifactsDirectory
        )

        try snapshot(
            name: "19-2G-edit-small",
            view: editOneTimeView(),
            size: small,
            directory: navigationStandardArtifactsDirectory
        )
        try snapshot(
            name: "19-2G-edit-standard",
            view: editOneTimeView(),
            size: standard,
            directory: navigationStandardArtifactsDirectory
        )
        try snapshot(
            name: "19-2G-edit-promax",
            view: editOneTimeView(),
            size: proMax,
            directory: navigationStandardArtifactsDirectory
        )
    }

    private func createOneTimeView() -> some View {
        editorNavigationStack {
            AddRoutineView(
                mode: .create,
                title: "",
                startTime: eightAM,
                hasEndTime: false,
                category: .morning,
                recurrence: nil,
                reminderEnabled: false,
                nowProvider: { self.morningNow },
                calendar: calendar
            )
        }
    }

    private func createRecurringView() -> some View {
        editorNavigationStack {
            AddRoutineView(
                mode: .create,
                title: "아침 스트레칭",
                startTime: eightAM,
                hasEndTime: false,
                category: .morning,
                recurrence: .weekdays,
                reminderEnabled: true,
                reminderMinutes: 10,
                nowProvider: { self.morningNow },
                calendar: calendar
            )
        }
    }

    private func editOneTimeView() -> some View {
        let id = UUID(uuidString: "AAAAAAAA-BBBB-CCCC-DDDD-EEEEEEEEEEEE")!
        return editorNavigationStack {
            AddRoutineView(
                mode: .edit(routineID: id, originalStartTime: eightAM),
                title: "병원 방문",
                startTime: eightAM,
                hasEndTime: true,
                endTime: eightThirtyAM,
                category: .focus,
                recurrence: nil,
                reminderEnabled: false,
                nowProvider: { self.morningNow },
                calendar: calendar
            )
        }
    }

    private func editRecurringView() -> some View {
        let id = UUID(uuidString: "BBBBBBBB-CCCC-DDDD-EEEE-FFFFFFFFFFFF")!
        return editorNavigationStack {
            AddRoutineView(
                mode: .edit(routineID: id, originalStartTime: eightAM),
                title: "아침 스트레칭",
                startTime: eightAM,
                hasEndTime: false,
                category: .morning,
                recurrence: .weekdays,
                reminderEnabled: true,
                reminderMinutes: 10,
                nowProvider: { self.morningNow },
                calendar: calendar
            )
        }
    }

    /// Pushes the editor so the system Back control is present (matches product NavigationStack).
    private func editorNavigationStack<Editor: View>(
        @ViewBuilder editor: () -> Editor
    ) -> some View {
        NavigationStack {
            Text("오늘")
                .font(.body)
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.clear)
                .orNavigationStandard(title: "오늘")
                .navigationDestination(isPresented: .constant(true)) {
                    editor()
                }
        }
    }

    private func snapshot<V: View>(
        name: String,
        view: V,
        size: CGSize,
        directory: URL,
        settleForKeyboard: Bool = false,
        scrollToBottom: Bool = false
    ) throws {
        let root = view
            .frame(width: size.width, height: size.height)

        let host = UIHostingController(rootView: root)
        // Avoid inheriting the host simulator's safe areas into mismatched window sizes,
        // but restore size-appropriate top/bottom insets so nav + Save layout correctly.
        host.safeAreaRegions = []
        let isCompactHeight = size.height <= 600
        host.additionalSafeAreaInsets = UIEdgeInsets(
            top: isCompactHeight ? 20 : 59,
            left: 0,
            bottom: isCompactHeight ? 0 : 34,
            right: 0
        )
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

        // Allow navigationDestination(.constant(true)) to push the editor.
        let navSettle = expectation(description: "nav-\(name)")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            navSettle.fulfill()
        }
        wait(for: [navSettle], timeout: 1.0)
        host.view.setNeedsLayout()
        host.view.layoutIfNeeded()

        if settleForKeyboard {
            // Allow Create-mode title focus + any keyboard presentation attempt.
            let keyboardWait = expectation(description: "keyboard-\(name)")
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.45) {
                keyboardWait.fulfill()
            }
            wait(for: [keyboardWait], timeout: 2.0)
            host.view.setNeedsLayout()
            host.view.layoutIfNeeded()
        }

        if scrollToBottom {
            scrollEmbeddedScrollViewsToBottom(in: host.view)
            host.view.setNeedsLayout()
            host.view.layoutIfNeeded()
            let scrollSettle = expectation(description: "scroll-\(name)")
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                scrollSettle.fulfill()
            }
            wait(for: [scrollSettle], timeout: 1.0)
            scrollEmbeddedScrollViewsToBottom(in: host.view)
            host.view.layoutIfNeeded()
        }

        let format = UIGraphicsImageRendererFormat()
        format.scale = 2
        format.opaque = true
        let renderer = UIGraphicsImageRenderer(size: size, format: format)
        let image = renderer.image { _ in
            host.view.drawHierarchy(in: host.view.bounds, afterScreenUpdates: true)
        }

        window.isHidden = true
        window.rootViewController = nil

        guard let data = image.pngData() else {
            XCTFail("Failed to encode \(name).png")
            return
        }

        let url = directory.appendingPathComponent("\(name).png")
        try data.write(to: url, options: .atomic)
        print("Wrote \(url.path)")
    }

    private func scrollEmbeddedScrollViewsToBottom(in root: UIView) {
        var scrollViews: [UIScrollView] = []
        func collect(_ view: UIView) {
            if let scrollView = view as? UIScrollView {
                scrollViews.append(scrollView)
            }
            view.subviews.forEach(collect)
        }
        collect(root)

        for scrollView in scrollViews {
            scrollView.layoutIfNeeded()
            let inset = scrollView.adjustedContentInset
            let maxY = max(
                0,
                scrollView.contentSize.height - scrollView.bounds.height + inset.bottom
            )
            guard maxY > 0 else { continue }
            scrollView.setContentOffset(CGPoint(x: -inset.left, y: maxY), animated: false)
            scrollView.layoutIfNeeded()
        }
    }
}
