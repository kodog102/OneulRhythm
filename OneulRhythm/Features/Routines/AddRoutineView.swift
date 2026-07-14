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

    private let onSave: (RoutineCreationInput) throws -> Void

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
        onSave: @escaping (RoutineCreationInput) throws -> Void = { _ in }
    ) {
        _title = State(initialValue: title)
        _startTime = State(initialValue: startTime)
        _hasEndTime = State(initialValue: hasEndTime)
        _endTime = State(initialValue: endTime)
        _selectedCategory = State(initialValue: category)
        _reminderEnabled = State(initialValue: reminderEnabled)
        _reminderMinutes = State(initialValue: reminderMinutes)
        self.onSave = onSave
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
        Button(action: saveRoutine) {
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

    private func saveRoutine() {
        guard !isSaving else { return }

        let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedTitle.isEmpty else { return }

        let input = RoutineCreationInput(
            title: trimmedTitle,
            startTime: startTime,
            endTime: hasEndTime ? endTime : nil,
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
}

private struct CategoryOption: Identifiable {
    let title: String
    let category: RoutineCategory

    var id: String { title }
}

#Preview("빈 양식") {
    NavigationStack {
        AddRoutineView()
    }
}

#Preview("입력된 양식") {
    NavigationStack {
        AddRoutineView(
            title: "따뜻한 차 한잔 마시기",
            hasEndTime: true,
            category: .morning,
            reminderEnabled: true,
            reminderMinutes: 10
        )
    }
}
