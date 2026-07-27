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
        notificationScheduler: NotificationScheduling = NotificationService(),
        nowProvider: @escaping () -> Date = Date.init,
        calendar: Calendar = .current
    ) {
        self.mode = mode
        _title = State(initialValue: title)
        _startTime = State(initialValue: startTime)
        _hasEndTime = State(initialValue: hasEndTime)
        _endTime = State(initialValue: endTime)
        _selectedCategory = State(initialValue: category)
        _selectedRecurrence = State(initialValue: recurrence)
        _reminderEnabled = State(initialValue: reminderEnabled)
        _reminderMinutes = State(initialValue: reminderMinutes)
        self.onSave = onSave
        self.notificationScheduler = notificationScheduler
        self.nowProvider = nowProvider
        self.calendar = calendar
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                captureSection

                configureSection
                    .padding(.top, ORSpacing.xxl)

                saveButton
                    .padding(.top, ORSpacing.xl)
            }
            .padding(.horizontal, ORSpacing.screenHorizontal)
            .padding(.top, ORSpacing.lg)
            .padding(.bottom, ORSpacing.scrollBottom)
        }
        .background(ORColors.background.ignoresSafeArea())
        .navigationTitle(navigationTitle)
        .navigationBarTitleDisplayMode(.inline)
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

    // MARK: - Capture (DR-019 Primary)

    /// Name + start time — strongest emphasis; first reading order.
    private var captureSection: some View {
        VStack(alignment: .leading, spacing: ORSpacing.md) {
            Text("리듬 이름")
                .orTypography(.caption, weight: .medium)
                .foregroundStyle(ORColors.textSecondary)
                .accessibilityAddTraits(.isHeader)

            VStack(alignment: .leading, spacing: 0) {
                TextField("예: 따뜻한 차 한잔 마시기", text: $title)
                    .orTypography(.title, weight: .semibold)
                    .foregroundStyle(ORColors.textPrimary)
                    .submitLabel(.done)
                    .focused($isTitleFocused)
                    .accessibilityLabel("리듬 이름")

                Divider()
                    .overlay(ORColors.divider)
                    .padding(.vertical, ORSpacing.md)

                timePickerRow(title: "시작 시간", selection: $startTime)
            }
            .padding(ORSpacing.cardPadding)
            .orCard()
        }
        .accessibilityElement(children: .contain)
    }

    // MARK: - Configure (DR-019 Advanced)

    /// End time, category, repeat, reminder — secondary hierarchy below Capture.
    private var configureSection: some View {
        VStack(alignment: .leading, spacing: ORSpacing.lg) {
            endTimeConfigureBlock
            categoryConfigureBlock
            recurrenceConfigureBlock
            reminderConfigureBlock
        }
        .accessibilityElement(children: .contain)
    }

    private var endTimeConfigureBlock: some View {
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
        }
        .padding(ORSpacing.cardPadding)
        .configureSurface()
    }

    private var categoryConfigureBlock: some View {
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
    }

    private var recurrenceConfigureBlock: some View {
        VStack(alignment: .leading, spacing: ORSpacing.md) {
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
    }

    private var reminderConfigureBlock: some View {
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
    }

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
                        .foregroundStyle(.white)
                        .multilineTextAlignment(.center)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, ORSpacing.md)
            .frame(minHeight: ORSpacing.primaryButtonHeight)
            .background(ORColors.primary)
            .clipShape(
                RoundedRectangle(
                    cornerRadius: ORRadius.button,
                    style: .continuous
                )
            )
        }
        .buttonStyle(.plain)
        .disabled(isSaveDisabled)
        .opacity(isTitleEmpty ? 0.45 : 1)
        .accessibilityHint(saveAccessibilityHint)
    }

    private func timePickerRow(
        title: String,
        selection: Binding<Date>
    ) -> some View {
        HStack(spacing: ORSpacing.md) {
            Text(title)
                .orTypography(.body)
                .foregroundStyle(ORColors.textPrimary)

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

    private var navigationTitle: String {
        switch mode {
        case .create:
            return "리듬 추가"
        case .edit:
            return "리듬 편집"
        }
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
                dismiss()
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
        let baselineDay = targetBaselineDay(now: now)
        let resolvedStart = date(on: baselineDay, copyingTimeFrom: startTime)
        return resolvedStart < now
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

// MARK: - Configure surface (quieter than Capture card)

private extension View {
    /// Secondary Configure band — same field tokens, reduced optical competition with Capture.
    func configureSurface() -> some View {
        background(ORColors.card.opacity(0.72))
            .clipShape(RoundedRectangle(cornerRadius: ORRadius.lg, style: .continuous))
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
