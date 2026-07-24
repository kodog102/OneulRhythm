//
//  AddRoutineView.swift
//  OneulRhythm
//

import SwiftUI
import UIKit

struct AddRoutineView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.openURL) private var openURL

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
            VStack(alignment: .leading, spacing: ORSpacing.sectionGap) {
                titleSection
                timeSection
                categorySection
                recurrenceSection
                reminderSection
                saveButton
            }
            .padding(.horizontal, ORSpacing.screenHorizontal)
            .padding(.top, ORSpacing.lg)
            .padding(.bottom, ORSpacing.scrollBottom)
        }
        .background(ORColors.background.ignoresSafeArea())
        .navigationTitle("리듬 추가")
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
                saveRoutine(for: .today)
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
    }

    private var titleSection: some View {
        formSection(title: "리듬 이름") {
            TextField("예: 따뜻한 차 한잔 마시기", text: $title)
                .orTypography(.body)
                .foregroundStyle(ORColors.textPrimary)
                .submitLabel(.done)
                .padding(ORSpacing.cardPadding)
                .orCard()
        }
    }

    private var timeSection: some View {
        formSection(title: "시간") {
            VStack(spacing: ORSpacing.md) {
                timePickerRow(title: "시작 시간", selection: $startTime)

                Divider()
                    .overlay(ORColors.divider)

                Toggle("종료 시간 설정", isOn: $hasEndTime)
                    .orTypography(.body)
                    .foregroundStyle(ORColors.textPrimary)
                    .tint(ORColors.primary)

                if hasEndTime {
                    Divider()
                        .overlay(ORColors.divider)

                    timePickerRow(title: "종료 시간", selection: $endTime)
                }
            }
            .padding(ORSpacing.cardPadding)
            .orCard()
        }
    }

    private var categorySection: some View {
        formSection(title: "카테고리") {
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
            .padding(ORSpacing.cardPadding)
            .orCard()
        }
    }

    private var recurrenceSection: some View {
        formSection(title: "반복") {
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
            .padding(ORSpacing.cardPadding)
            .orCard()
        }
    }

    private var reminderSection: some View {
        formSection(title: "알림") {
            VStack(alignment: .leading, spacing: ORSpacing.md) {
                Toggle("시작 전에 알려주기", isOn: $reminderEnabled)
                    .orTypography(.body)
                    .foregroundStyle(ORColors.textPrimary)
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
            .orCard()
        }
    }

    private var saveButton: some View {
        Button(action: handleSaveTapped) {
            Group {
                if isSaving {
                    ProgressView()
                        .tint(.white)
                        .accessibilityLabel("저장 중")
                } else {
                    Text("리듬 저장하기")
                        .orTypography(.body, weight: .semibold)
                        .foregroundStyle(.white)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: ORSpacing.primaryButtonHeight)
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
    }

    private func formSection<Content: View>(
        title: String,
        @ViewBuilder content: () -> Content
    ) -> some View {
        VStack(alignment: .leading, spacing: ORSpacing.md) {
            ORSectionLabel(text: title)
            content()
        }
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
        if selectedRecurrence == nil, isSelectedStartTimeInPastToday() {
            isShowingPastTimeConfirmation = true
            return
        }

        saveRoutine(for: .today)
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
        let targetDay: Date
        switch dayChoice {
        case .today:
            targetDay = now
        case .tomorrow:
            guard let tomorrow = calendar.date(byAdding: .day, value: 1, to: now) else {
                isShowingSaveError = true
                return
            }
            targetDay = tomorrow
        }

        let resolvedStart = date(on: targetDay, copyingTimeFrom: startTime)
        let resolvedEnd = hasEndTime
            ? date(on: targetDay, copyingTimeFrom: endTime)
            : nil

        let input = RoutineCreationInput(
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

    private func isSelectedStartTimeInPastToday() -> Bool {
        let now = nowProvider()
        let todayStart = date(on: now, copyingTimeFrom: startTime)
        return todayStart < now
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

private enum PastTimeDayChoice {
    case today
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
