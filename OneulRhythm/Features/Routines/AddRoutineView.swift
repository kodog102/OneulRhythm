//
//  AddRoutineView.swift
//  OneulRhythm
//

import SwiftUI

struct AddRoutineView: View {
    @Environment(\.dismiss) private var dismiss

    @State private var title: String
    @State private var startTime: Date
    @State private var hasEndTime: Bool
    @State private var endTime: Date
    @State private var selectedCategory: RoutineCategory
    @State private var reminderEnabled: Bool
    @State private var reminderMinutes: Int
    @State private var isSaving = false
    @State private var isShowingSaveError = false
    @State private var isShowingPastTimeConfirmation = false

    private let onSave: (RoutineCreationInput) throws -> Void
    private let nowProvider: () -> Date
    private let calendar: Calendar

    private let categoryOptions = [
        CategoryOption(title: "아침", category: .morning),
        CategoryOption(title: "집중", category: .focus),
        CategoryOption(title: "움직임", category: .movement),
        CategoryOption(title: "휴식", category: .rest),
        CategoryOption(title: "저녁", category: .evening)
    ]
    private let reminderOptions = [5, 10, 15, 30]

    init(
        title: String = "",
        startTime: Date = Date(),
        hasEndTime: Bool = false,
        endTime: Date = Date().addingTimeInterval(30 * 60),
        category: RoutineCategory = .morning,
        reminderEnabled: Bool = false,
        reminderMinutes: Int = 10,
        onSave: @escaping (RoutineCreationInput) throws -> Void = { _ in },
        nowProvider: @escaping () -> Date = Date.init,
        calendar: Calendar = .current
    ) {
        _title = State(initialValue: title)
        _startTime = State(initialValue: startTime)
        _hasEndTime = State(initialValue: hasEndTime)
        _endTime = State(initialValue: endTime)
        _selectedCategory = State(initialValue: category)
        _reminderEnabled = State(initialValue: reminderEnabled)
        _reminderMinutes = State(initialValue: reminderMinutes)
        self.onSave = onSave
        self.nowProvider = nowProvider
        self.calendar = calendar
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: ORSpacing.sectionGap) {
                titleSection
                timeSection
                categorySection
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

    private var reminderSection: some View {
        formSection(title: "알림") {
            VStack(alignment: .leading, spacing: ORSpacing.md) {
                Toggle("시작 전에 알려주기", isOn: $reminderEnabled)
                    .orTypography(.body)
                    .foregroundStyle(ORColors.textPrimary)
                    .tint(ORColors.primary)

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

        if isSelectedStartTimeInPastToday() {
            isShowingPastTimeConfirmation = true
            return
        }

        saveRoutine(for: .today)
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
            reminderMinutes: reminderEnabled ? reminderMinutes : nil
        )

        isSaving = true
        defer { isSaving = false }

        do {
            try onSave(input)
            dismiss()
        } catch {
            isShowingSaveError = true
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
