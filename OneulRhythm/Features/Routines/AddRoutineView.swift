//
//  AddRoutineView.swift
//  OneulRhythm
//

import SwiftUI
import UIKit

enum RoutineFormMode: Equatable {
    case create
    case edit(routineID: UUID, originalStartTime: Date)
}

struct AddRoutineView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.openURL) private var openURL

    @FocusState private var isTitleFocused: Bool

    @State private var title: String
    @State private var startTime: Date
    @State private var hasEndTime: Bool
    @State private var endTime: Date
    @State private var selectedCategory: RoutineCategory
    @State private var selectedRecurrence: RecurrenceRule?
    @State private var reminderEnabled: Bool
    @State private var reminderMinutes: Int
    @State private var isSaving = false
    @State private var isShowingSaveError = false
    @State private var isShowingPastTimeConfirmation = false
    @State private var isShowingNotificationSettingsPrompt = false
    @State private var isResolvingReminderPermission = false

    private let mode: RoutineFormMode
    private let onSave: (RoutineCreationInput) throws -> Void
    /// Called after a successful save instead of a single-level `dismiss` when provided
    /// (e.g. My Rhythms → Editor should return to Today without flashing Management).
    private let onSaveSuccess: (() -> Void)?
    private let notificationScheduler: NotificationScheduling
    private let nowProvider: () -> Date
    private let calendar: Calendar

    private let categoryOptions = [
        CategoryOption(title: "아침", category: .morning),
        CategoryOption(title: "집중", category: .focus),
        CategoryOption(title: "움직임", category: .movement),
        CategoryOption(title: "휴식", category: .rest),
        CategoryOption(title: "저녁", category: .evening)
    ]
    private let recurrenceOptions: [RecurrenceOption] = [
        RecurrenceOption(title: "반복 안 함", rule: nil),
        RecurrenceOption(title: "매일", rule: .daily),
        RecurrenceOption(title: "평일", rule: .weekdays),
        RecurrenceOption(title: "주말", rule: .weekends)
    ]
    private let reminderOptions = [5, 10, 15, 30]

    init(
        mode: RoutineFormMode = .create,
        title: String = "",
        startTime: Date = Date(),
        hasEndTime: Bool = false,
        endTime: Date = Date().addingTimeInterval(30 * 60),
        category: RoutineCategory = .morning,
        recurrence: RecurrenceRule? = nil,
        reminderEnabled: Bool = false,
        reminderMinutes: Int = 10,
        onSave: @escaping (RoutineCreationInput) throws -> Void = { _ in },
        onSaveSuccess: (() -> Void)? = nil,
        notificationScheduler: NotificationScheduling = NotificationService(),
        nowProvider: @escaping () -> Date = Date.init,
        calendar: Calendar = .current
    ) {
        self.mode = mode
        _title = State(initialValue: title)
        let initialStartTime: Date
        switch mode {
        case .create:
            initialStartTime = Self.snapToNextMinute(startTime, calendar: calendar)
        case .edit:
            initialStartTime = startTime
        }
        _startTime = State(initialValue: initialStartTime)
        _hasEndTime = State(initialValue: hasEndTime)
        _endTime = State(initialValue: endTime)
        _selectedCategory = State(initialValue: category)
        _selectedRecurrence = State(initialValue: recurrence)
        _reminderEnabled = State(initialValue: reminderEnabled)
        _reminderMinutes = State(initialValue: reminderMinutes)
        self.onSave = onSave
        self.onSaveSuccess = onSaveSuccess
        self.notificationScheduler = notificationScheduler
        self.nowProvider = nowProvider
        self.calendar = calendar
    }

    /// Fixed bottom action chrome height (pads + button), excluding device safe area.
    private static let bottomActionChromeHeight: CGFloat =
        ORSpacing.md + ORSpacing.primaryButtonHeight + ORSpacing.md

    var body: some View {
        GeometryReader { geometry in
            // Dedicated Save row height (pads + button + air). Must be excluded from
            // ScrollView’s frame — safeAreaInset alone only adds contentInset and still
            // lets form content paint under a transparent floating Save.
            let saveRegionHeight = Self.bottomActionChromeHeight + ORSpacing.sm
            let scrollHeight = max(0, geometry.size.height - saveRegionHeight)

            VStack(spacing: 0) {
                ScrollView {
                    VStack(alignment: .leading, spacing: 0) {
                        // Sprint 19-2D — Capture starts immediately; no decorative header / section label.
                        captureCard

                        scheduleCard
                            .padding(.top, ORSpacing.lg) // 24pt

                        categoryCard
                            .padding(.top, ORSpacing.lg) // 24pt

                        reminderCard
                            .padding(.top, ORSpacing.lg) // 24pt
                    }
                    .padding(.horizontal, ORSpacing.screenHorizontal)
                    .padding(.top, ORSpacing.md)
                    .padding(.bottom, ORSpacing.md)
                }
                .scrollDismissesKeyboard(.interactively)
                .frame(width: geometry.size.width, height: scrollHeight, alignment: .top)
                .clipped()

                // Fixed bottom action row (safe-area sibling). Landscape shows through;
                // no material scrim. ScrollView cannot draw into this band.
                saveButton
                    .padding(.horizontal, ORSpacing.screenHorizontal)
                    .padding(.top, ORSpacing.md)
                    .padding(.bottom, ORSpacing.md)
                    .frame(width: geometry.size.width)
                    .frame(height: saveRegionHeight, alignment: .center)
            }
            .frame(width: geometry.size.width, height: geometry.size.height, alignment: .top)
        }
        .background {
            ORAtmosphereBackground()
        }
        // Sprint 19-2G — project navigation standard (transparent bar, landscape behind).
        .orNavigationStandard()
        .tint(ORColors.primary)
        .environment(\.locale, Locale(identifier: "ko_KR"))
        .alert("리듬을 저장하지 못했어요", isPresented: $isShowingSaveError) {
            Button("확인", role: .cancel) {}
        } message: {
            Text("잠시 후 다시 시도해주세요.")
        }
        .alert(
            "알림이 비활성화되어 있어요.",
            isPresented: $isShowingNotificationSettingsPrompt
        ) {
            Button("설정으로 이동") {
                reminderEnabled = false
                openNotificationSettings()
            }
            .accessibilityLabel("설정으로 이동")
            .accessibilityHint("앱 알림 설정 화면을 엽니다")

            Button("취소", role: .cancel) {
                reminderEnabled = false
            }
            .accessibilityLabel("취소")
        } message: {
            Text("리마인더를 사용하려면\n설정에서 알림을 허용해주세요.")
        }
        .confirmationDialog(
            "선택한 시간이 이미 지났어요",
            isPresented: $isShowingPastTimeConfirmation,
            titleVisibility: .visible
        ) {
            Button("내일로 등록") {
                saveRoutine(for: .tomorrow)
            }
            .accessibilityLabel("내일로 등록")
            .accessibilityHint("같은 시간으로 내일의 리듬을 만듭니다")

            Button("오늘로 등록") {
                saveRoutine(for: .sameDay)
            }
            .accessibilityLabel("오늘로 등록")
            .accessibilityHint("오늘 지나간 리듬으로 등록합니다")

            Button("취소", role: .cancel) {}
                .accessibilityLabel("취소")
        } message: {
            Text("오늘의 지나간 리듬으로 등록하거나,\n내일 같은 시간으로 이어갈 수 있어요.")
        }
        .onChange(of: reminderEnabled) { _, isEnabled in
            guard isEnabled else { return }
            Task {
                await resolveReminderPermission()
            }
        }
        .onAppear {
            guard case .create = mode else { return }
            isTitleFocused = true
        }
    }

    // MARK: - Capture Card (DR-019 Primary)

    /// Name + start time — strongest emphasis; first reading order.
    private var captureCard: some View {
        VStack(alignment: .leading, spacing: 0) {
            TextField("예: 따뜻한 차 한잔 마시기", text: $title)
                .orTypography(.title, weight: .semibold)
                .foregroundStyle(ORTodayTypography.displayInk)
                .submitLabel(.done)
                .focused($isTitleFocused)
                .accessibilityLabel("리듬 이름")

            Divider()
                .overlay(ORColors.divider)
                .padding(.vertical, ORSpacing.md)

            timePickerRow(title: "시작 시간", selection: $startTime)
        }
        .padding(ORSpacing.cardPadding)
        .editorCaptureSurface()
        .accessibilityElement(children: .contain)
    }

    // MARK: - Schedule Card (end time + repeat)

    /// End time and recurrence share one quieter Configure surface (Sprint 19-2B regroup).
    private var scheduleCard: some View {
        VStack(alignment: .leading, spacing: ORSpacing.md) {
            Toggle("종료 시간", isOn: $hasEndTime)
                .orTypography(.body)
                .foregroundStyle(ORColors.textSecondary)
                .tint(ORColors.primary)

            if hasEndTime {
                Divider()
                    .overlay(ORColors.divider)

                timePickerRow(title: "종료 시간", selection: $endTime)
            }

            Divider()
                .overlay(ORColors.divider)

            Text("반복")
                .orTypography(.caption, weight: .medium)
                .foregroundStyle(ORColors.textTertiary)

            LazyVGrid(
                columns: [
                    GridItem(.flexible(), spacing: ORSpacing.sm),
                    GridItem(.flexible(), spacing: ORSpacing.sm)
                ],
                spacing: ORSpacing.sm
            ) {
                ForEach(recurrenceOptions) { option in
                    selectionChip(
                        title: option.title,
                        isSelected: selectedRecurrence == option.rule
                    ) {
                        selectedRecurrence = option.rule
                    }
                }
            }
        }
        .padding(ORSpacing.cardPadding)
        .configureSurface()
        .accessibilityElement(children: .contain)
    }

    // MARK: - Category Card

    private var categoryCard: some View {
        VStack(alignment: .leading, spacing: ORSpacing.md) {
            Text("카테고리")
                .orTypography(.caption, weight: .medium)
                .foregroundStyle(ORColors.textTertiary)

            LazyVGrid(
                columns: [
                    GridItem(.flexible(), spacing: ORSpacing.sm),
                    GridItem(.flexible(), spacing: ORSpacing.sm),
                    GridItem(.flexible(), spacing: ORSpacing.sm)
                ],
                spacing: ORSpacing.sm
            ) {
                ForEach(categoryOptions) { option in
                    selectionChip(
                        title: option.title,
                        isSelected: selectedCategory == option.category
                    ) {
                        selectedCategory = option.category
                    }
                }
            }
        }
        .padding(ORSpacing.cardPadding)
        .configureSurface()
        .accessibilityElement(children: .contain)
    }

    // MARK: - Reminder Card

    private var reminderCard: some View {
        VStack(alignment: .leading, spacing: ORSpacing.md) {
            Toggle("시작 전에 알려주기", isOn: $reminderEnabled)
                .orTypography(.body)
                .foregroundStyle(ORColors.textSecondary)
                .tint(ORColors.primary)
                .disabled(isResolvingReminderPermission)
                .accessibilityLabel("시작 전에 알려주기")
                .accessibilityHint("리마인더는 선택 사항이며, 알림 권한이 필요할 수 있어요")

            if reminderEnabled {
                Divider()
                    .overlay(ORColors.divider)

                LazyVGrid(
                    columns: [
                        GridItem(.flexible(), spacing: ORSpacing.sm),
                        GridItem(.flexible(), spacing: ORSpacing.sm)
                    ],
                    spacing: ORSpacing.sm
                ) {
                    ForEach(reminderOptions, id: \.self) { minutes in
                        selectionChip(
                            title: "\(minutes)분 전",
                            isSelected: reminderMinutes == minutes
                        ) {
                            reminderMinutes = minutes
                        }
                    }
                }
            }
        }
        .padding(ORSpacing.cardPadding)
        .configureSurface()
        .accessibilityElement(children: .contain)
    }

    // MARK: - Save (bottom safe-area inset)

    private var saveButton: some View {
        Button(action: handleSaveTapped) {
            Group {
                if isSaving {
                    ProgressView()
                        .tint(.white)
                        .accessibilityLabel("저장 중")
                } else {
                    Text(saveButtonTitle)
                        .orTypography(.body, weight: .semibold)
                        .foregroundStyle(Color.white.opacity(isTitleEmpty ? 0.95 : 1))
                        .multilineTextAlignment(.center)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, ORSpacing.md)
            .frame(minHeight: ORSpacing.primaryButtonHeight)
            // Sprint 19-2C — disabled stays obvious/readable, never as strong as enabled.
            .background(ORColors.primary.opacity(isTitleEmpty ? 0.68 : 1))
            .clipShape(
                RoundedRectangle(
                    cornerRadius: ORRadius.button,
                    style: .continuous
                )
            )
        }
        .buttonStyle(.plain)
        .disabled(isSaveDisabled)
        .accessibilityHint(saveAccessibilityHint)
    }

    private func timePickerRow(
        title: String,
        selection: Binding<Date>
    ) -> some View {
        HStack(spacing: ORSpacing.md) {
            Text(title)
                .orTypography(.body)
                .foregroundStyle(ORTodayTypography.displayInk)

            Spacer(minLength: ORSpacing.sm)

            DatePicker(
                title,
                selection: selection,
                displayedComponents: .hourAndMinute
            )
            .labelsHidden()
            .datePickerStyle(.compact)
        }
    }

    private func selectionChip(
        title: String,
        isSelected: Bool,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            Text(title)
                .orTypography(.caption, weight: .medium)
                .foregroundStyle(isSelected ? Color.white : ORColors.textSecondary)
                .frame(maxWidth: .infinity)
                .padding(.vertical, ORSpacing.sm)
                .background(isSelected ? ORColors.primary : ORColors.primaryMuted)
                .clipShape(
                    RoundedRectangle(
                        cornerRadius: ORRadius.md,
                        style: .continuous
                    )
                )
        }
        .buttonStyle(.plain)
        .accessibilityLabel(title)
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }

    private var saveButtonTitle: String {
        switch mode {
        case .create:
            return "리듬 저장하기"
        case .edit:
            return "변경 저장하기"
        }
    }

    private var saveAccessibilityHint: String {
        switch mode {
        case .create:
            return "리듬을 저장하고 이전 화면으로 돌아갑니다"
        case .edit:
            return "변경을 저장하고 이전 화면으로 돌아갑니다"
        }
    }

    private var isTitleEmpty: Bool {
        title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    private var isSaveDisabled: Bool {
        isTitleEmpty || isSaving
    }

    private func handleSaveTapped() {
        guard !isSaving else { return }

        let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedTitle.isEmpty else { return }

        // Recurring rhythms skip the Today/Tomorrow dialog; they start from today.
        // Edit keeps the original calendar day unless the user chooses tomorrow.
        if selectedRecurrence == nil, isSelectedStartTimeInPastOnTargetDay() {
            isShowingPastTimeConfirmation = true
            return
        }

        saveRoutine(for: .sameDay)
    }

    @MainActor
    private func resolveReminderPermission() async {
        guard reminderEnabled else { return }
        guard !isResolvingReminderPermission else { return }

        isResolvingReminderPermission = true
        defer { isResolvingReminderPermission = false }

        let status = await notificationScheduler.authorizationStatus()

        switch status {
        case .authorized:
            break
        case .notDetermined:
            do {
                let granted = try await notificationScheduler.requestAuthorization()
                if !granted {
                    reminderEnabled = false
                }
            } catch {
                reminderEnabled = false
            }
        case .denied:
            isShowingNotificationSettingsPrompt = true
        }
    }

    private func openNotificationSettings() {
        guard let url = URL(string: UIApplication.openNotificationSettingsURLString) else {
            return
        }

        openURL(url)
    }

    private func saveRoutine(for dayChoice: PastTimeDayChoice) {
        guard !isSaving else { return }

        let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedTitle.isEmpty else { return }

        let now = nowProvider()
        let baselineDay = targetBaselineDay(now: now)
        let targetDay: Date
        switch dayChoice {
        case .sameDay:
            targetDay = baselineDay
        case .tomorrow:
            guard let tomorrow = calendar.date(byAdding: .day, value: 1, to: baselineDay) else {
                isShowingSaveError = true
                return
            }
            targetDay = tomorrow
        }

        let resolvedStart = date(on: targetDay, copyingTimeFrom: startTime)
        let resolvedEnd = hasEndTime
            ? date(on: targetDay, copyingTimeFrom: endTime)
            : nil

        let inputID: UUID
        switch mode {
        case .create:
            inputID = UUID()
        case .edit(let routineID, _):
            inputID = routineID
        }

        let input = RoutineCreationInput(
            id: inputID,
            title: trimmedTitle,
            startTime: resolvedStart,
            endTime: resolvedEnd,
            category: selectedCategory,
            reminderMinutes: reminderEnabled ? reminderMinutes : nil,
            recurrence: selectedRecurrence
        )

        isSaving = true

        Task { @MainActor in
            defer { isSaving = false }

            do {
                try onSave(input)
                // Recurring reminders are persisted only; scheduling remains out of scope.
                if input.recurrence == nil {
                    await scheduleReminderIfNeeded(
                        for: Routine(
                            id: input.id,
                            title: input.title,
                            startTime: input.startTime,
                            endTime: input.endTime,
                            category: input.category,
                            status: .upcoming,
                            reminderMinutes: input.reminderMinutes
                        )
                    )
                }
                // Sprint 19-2H — optional root pop (Today) after save from My Rhythms.
                if let onSaveSuccess {
                    onSaveSuccess()
                } else {
                    dismiss()
                }
            } catch {
                isShowingSaveError = true
            }
        }
    }

    private func targetBaselineDay(now: Date) -> Date {
        switch mode {
        case .create:
            return now
        case .edit(_, let originalStartTime):
            return originalStartTime
        }
    }

    /// Floors to the minute boundary (seconds & sub-second become 0).
    static func floorToMinute(_ date: Date, calendar: Calendar) -> Date {
        let comps = calendar.dateComponents(
            [.year, .month, .day, .hour, .minute],
            from: date
        )
        return calendar.date(from: comps) ?? date
    }

    /// Ceils to the next minute boundary if the input is not already aligned.
    /// This prevents “past-by-seconds” dialogs for an untouched hour+minute picker.
    static func snapToNextMinute(_ date: Date, calendar: Calendar) -> Date {
        let minuteStart = floorToMinute(date, calendar: calendar)
        let parts = calendar.dateComponents([.second, .nanosecond], from: date)
        let second = parts.second ?? 0
        let nanosecond = parts.nanosecond ?? 0
        guard second != 0 || nanosecond != 0 else { return minuteStart }

        return calendar.date(byAdding: .minute, value: 1, to: minuteStart) ?? minuteStart
    }

    /// Create/Edit shared past-time comparison, done at minute precision.
    /// - Important: only hour+minute selection matters (seconds are not user-visible).
    static func isStartTimeInPastOnTargetDay(
        startTime: Date,
        now: Date,
        mode: RoutineFormMode,
        calendar: Calendar
    ) -> Bool {
        let baselineDay: Date
        switch mode {
        case .create:
            baselineDay = now
        case .edit(_, let originalStartTime):
            baselineDay = originalStartTime
        }

        let resolvedStart = calendar.date(
            bySettingHour: calendar.component(.hour, from: startTime),
            minute: calendar.component(.minute, from: startTime),
            second: calendar.component(.second, from: startTime),
            of: baselineDay
        ) ?? startTime

        let resolvedStartMinute = floorToMinute(resolvedStart, calendar: calendar)
        let nowMinute = floorToMinute(now, calendar: calendar)
        return resolvedStartMinute < nowMinute
    }

    @MainActor
    private func scheduleReminderIfNeeded(for routine: Routine) async {
        let plan = NotificationMapper.makePlan(
            routines: [routine],
            now: nowProvider(),
            calendar: calendar
        )

        guard !plan.items.isEmpty else { return }

        let status = await notificationScheduler.authorizationStatus()
        guard status == .authorized else { return }

        for item in plan.items {
            do {
                try await notificationScheduler.schedule(
                    identifier: item.identifier,
                    title: item.title,
                    body: item.body,
                    at: item.triggerDate
                )
            } catch {
                // Save already succeeded; notification failure must not block the flow.
            }
        }
    }

    private func isSelectedStartTimeInPastOnTargetDay() -> Bool {
        let now = nowProvider()
        return Self.isStartTimeInPastOnTargetDay(
            startTime: startTime,
            now: now,
            mode: mode,
            calendar: calendar
        )
    }

    private func date(on day: Date, copyingTimeFrom source: Date) -> Date {
        let timeComponents = calendar.dateComponents(
            [.hour, .minute, .second],
            from: source
        )

        return calendar.date(
            bySettingHour: timeComponents.hour ?? 0,
            minute: timeComponents.minute ?? 0,
            second: timeComponents.second ?? 0,
            of: day
        ) ?? source
    }
}

// MARK: - Editor surfaces (Sprint 19-2C visual polish — local to this form)

private extension View {
    /// Capture glass — translucent float aligned to Today card depth, without redesigning layout.
    func editorCaptureSurface() -> some View {
        background {
            RoundedRectangle(cornerRadius: ORRadius.lg, style: .continuous)
                .fill(Color.white.opacity(0.84))
                .compositingGroup()
                .shadow(color: ORTodaySurface.warmShadow.opacity(0.22), radius: 26, x: 0, y: 12)
                .shadow(color: Color.black.opacity(0.06), radius: 6, x: 0, y: 2)
        }
    }

    /// Secondary Configure band — quieter than Capture; soft elevation for Today consistency.
    func configureSurface() -> some View {
        background {
            RoundedRectangle(cornerRadius: ORRadius.lg, style: .continuous)
                .fill(ORColors.card.opacity(0.78))
                .compositingGroup()
                .shadow(color: ORTodaySurface.warmShadow.opacity(0.14), radius: 18, x: 0, y: 8)
                .shadow(color: Color.black.opacity(0.04), radius: 3, x: 0, y: 1)
        }
    }
}

private enum PastTimeDayChoice {
    case sameDay
    case tomorrow
}

private struct CategoryOption: Identifiable {
    let title: String
    let category: RoutineCategory

    var id: String { title }
}

private struct RecurrenceOption: Identifiable {
    let title: String
    let rule: RecurrenceRule?

    var id: String { title }
}

#Preview("빈 양식") {
    NavigationStack {
        AddRoutineView(
            nowProvider: { MockRoutineData.date(hour: 10, minute: 0) }
        )
    }
}

#Preview("입력된 양식") {
    NavigationStack {
        AddRoutineView(
            title: "따뜻한 차 한잔 마시기",
            startTime: MockRoutineData.date(hour: 7, minute: 30),
            hasEndTime: true,
            endTime: MockRoutineData.date(hour: 7, minute: 45),
            category: .morning,
            reminderEnabled: true,
            reminderMinutes: 10,
            nowProvider: { MockRoutineData.date(hour: 10, minute: 0) }
        )
    }
}

#Preview("미래 시간") {
    NavigationStack {
        AddRoutineView(
            title: "가벼운 산책",
            startTime: MockRoutineData.date(hour: 18, minute: 0),
            nowProvider: { MockRoutineData.date(hour: 10, minute: 0) }
        )
    }
}

#Preview("편집") {
    NavigationStack {
        AddRoutineView(
            mode: .edit(
                routineID: UUID(),
                originalStartTime: MockRoutineData.date(hour: 7, minute: 30)
            ),
            title: "따뜻한 차 한잔 마시기",
            startTime: MockRoutineData.date(hour: 7, minute: 30),
            category: .morning,
            nowProvider: { MockRoutineData.date(hour: 10, minute: 0) }
        )
    }
}

#Preview("큰 Dynamic Type") {
    NavigationStack {
        AddRoutineView(
            nowProvider: { MockRoutineData.date(hour: 10, minute: 0) }
        )
    }
    .environment(\.sizeCategory, .accessibilityLarge)
}
