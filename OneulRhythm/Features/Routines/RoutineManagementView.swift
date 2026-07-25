//
//  RoutineManagementView.swift
//  OneulRhythm
//

import SwiftUI

struct RoutineManagementView: View {
    @StateObject private var viewModel: RoutineManagementViewModel
    @State private var isAddingRoutine = false
    @State private var editingItemID: UUID?
    @State private var itemPendingDeletion: ManagementRhythmItem?

    private let onSaveRoutine: (RoutineCreationInput) throws -> Void
    private let onUpdateRoutine: (RoutineCreationInput) throws -> Void
    private let onRoutinesChanged: () -> Void
    private let nowProvider: () -> Date
    private let calendar: Calendar

    init(
        repository: RoutineRepository,
        recurringRhythmRepository: RecurringRhythmRepository,
        onSaveRoutine: @escaping (RoutineCreationInput) throws -> Void,
        onUpdateRoutine: @escaping (RoutineCreationInput) throws -> Void,
        onDeleteRoutine: @escaping (UUID) throws -> Void,
        onRoutinesChanged: @escaping () -> Void = {},
        nowProvider: @escaping () -> Date = Date.init,
        dayPolicy: CalendarDayPolicy = CalendarDayPolicy()
    ) {
        _viewModel = StateObject(
            wrappedValue: RoutineManagementViewModel(
                repository: repository,
                recurringRhythmRepository: recurringRhythmRepository,
                dayPolicy: dayPolicy,
                nowProvider: nowProvider,
                onDeleteRoutine: onDeleteRoutine
            )
        )
        self.onSaveRoutine = onSaveRoutine
        self.onUpdateRoutine = onUpdateRoutine
        self.onRoutinesChanged = onRoutinesChanged
        self.nowProvider = nowProvider
        self.calendar = dayPolicy.calendar
    }

    var body: some View {
        Group {
            if viewModel.isLoading && viewModel.items.isEmpty {
                loadingState
            } else if let loadErrorMessage = viewModel.loadErrorMessage,
                      viewModel.items.isEmpty {
                errorState(message: loadErrorMessage)
            } else if viewModel.items.isEmpty {
                emptyState
            } else {
                itemList
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .background(ORColors.background.ignoresSafeArea())
        .navigationTitle("리듬 관리")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    isAddingRoutine = true
                } label: {
                    Image(systemName: "plus")
                        .foregroundStyle(ORColors.primary)
                }
                .accessibilityLabel("리듬 추가")
            }
        }
        .navigationDestination(isPresented: $isAddingRoutine) {
            AddRoutineView(
                mode: .create,
                onSave: { input in
                    try onSaveRoutine(input)
                    viewModel.loadItems()
                    onRoutinesChanged()
                },
                nowProvider: nowProvider
            )
        }
        .navigationDestination(isPresented: editingDestinationBinding) {
            if let editingItem {
                editDestination(for: editingItem)
            } else {
                EmptyView()
            }
        }
        .onAppear {
            viewModel.loadItems()
        }
        .alert(
            "리듬을 삭제할까요?",
            isPresented: deletionConfirmBinding
        ) {
            Button("삭제", role: .destructive) {
                if let itemPendingDeletion {
                    viewModel.deleteItem(itemPendingDeletion)
                    onRoutinesChanged()
                }
                itemPendingDeletion = nil
            }
            Button("취소", role: .cancel) {
                itemPendingDeletion = nil
            }
        } message: {
            Text("삭제한 리듬은 되돌릴 수 없어요.")
        }
        .alert(
            "리듬을 변경하지 못했어요",
            isPresented: mutationErrorBinding
        ) {
            Button("확인", role: .cancel) {}
        } message: {
            Text(viewModel.mutationErrorMessage ?? "잠시 후 다시 시도해주세요.")
        }
    }

    private var editingItem: ManagementRhythmItem? {
        guard let editingItemID else { return nil }
        return viewModel.items.first { $0.id == editingItemID }
    }

    private var editingDestinationBinding: Binding<Bool> {
        Binding(
            get: { editingItemID != nil },
            set: { isPresented in
                if !isPresented {
                    editingItemID = nil
                }
            }
        )
    }

    private var deletionConfirmBinding: Binding<Bool> {
        Binding(
            get: { itemPendingDeletion != nil },
            set: { isPresented in
                if !isPresented {
                    itemPendingDeletion = nil
                }
            }
        )
    }

    private var mutationErrorBinding: Binding<Bool> {
        Binding(
            get: { viewModel.mutationErrorMessage != nil },
            set: { isPresented in
                if !isPresented {
                    viewModel.mutationErrorMessage = nil
                }
            }
        )
    }

    @ViewBuilder
    private func editDestination(for item: ManagementRhythmItem) -> some View {
        let referenceDay = nowProvider()
        let startTime = item.displayStartTime(referenceDay: referenceDay, calendar: calendar)
        let endTime = item.displayEndTime(referenceDay: referenceDay, calendar: calendar)
            ?? startTime.addingTimeInterval(30 * 60)

        AddRoutineView(
            mode: .edit(
                routineID: item.id,
                originalStartTime: startTime
            ),
            title: item.title,
            startTime: startTime,
            hasEndTime: item.displayEndTime(referenceDay: referenceDay, calendar: calendar) != nil,
            endTime: endTime,
            category: item.category,
            recurrence: item.recurrence,
            reminderEnabled: item.reminderMinutes != nil,
            reminderMinutes: item.reminderMinutes ?? 10,
            onSave: { input in
                try onUpdateRoutine(input)
                viewModel.loadItems()
                onRoutinesChanged()
            },
            nowProvider: nowProvider,
            calendar: calendar
        )
    }

    private var loadingState: some View {
        HStack(spacing: ORSpacing.md) {
            ProgressView()
                .tint(ORColors.primary)
            Text("리듬을 불러오는 중이에요")
                .orTypography(.body)
                .foregroundStyle(ORColors.textSecondary)
        }
        .padding(.horizontal, ORSpacing.screenHorizontal)
        .padding(.top, ORSpacing.xl)
    }

    private func errorState(message: String) -> some View {
        Text(message)
            .orTypography(.body)
            .foregroundStyle(ORColors.textSecondary)
            .padding(.horizontal, ORSpacing.screenHorizontal)
            .padding(.top, ORSpacing.xl)
    }

    private var emptyState: some View {
        VStack(alignment: .leading, spacing: ORSpacing.md) {
            Text("아직 만든 리듬이 없어요.")
                .orTypography(.title)
                .foregroundStyle(ORColors.textPrimary)

            Text("오른쪽 위의 ➕로 첫 리듬을 만들어보세요.")
                .orTypography(.body)
                .foregroundStyle(ORColors.textSecondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, ORSpacing.screenHorizontal)
        .padding(.top, ORSpacing.xl)
    }

    private var itemList: some View {
        List {
            ForEach(viewModel.items) { item in
                Button {
                    editingItemID = item.id
                } label: {
                    itemRow(item)
                }
                .buttonStyle(.plain)
                .listRowBackground(ORColors.background)
                .listRowSeparatorTint(ORColors.divider)
                .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                    Button(role: .destructive) {
                        itemPendingDeletion = item
                    } label: {
                        Text("삭제")
                    }
                }
            }
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
    }

    private func itemRow(_ item: ManagementRhythmItem) -> some View {
        let referenceDay = nowProvider()

        return VStack(alignment: .leading, spacing: ORSpacing.xxs) {
            Text(item.title)
                .orTypography(.body, weight: .medium)
                .foregroundStyle(ORColors.textPrimary)
                .frame(maxWidth: .infinity, alignment: .leading)

            Text(item.formattedTime(referenceDay: referenceDay, calendar: calendar))
                .orTypography(.caption)
                .foregroundStyle(ORColors.textSecondary)

            if item.isRecurring {
                Text("반복")
                    .orTypography(.caption)
                    .foregroundStyle(ORColors.textTertiary)
            }
        }
        .padding(.vertical, ORSpacing.xs)
        .accessibilityElement(children: .combine)
        .accessibilityHint("편집하려면 탭하세요")
    }
}

#Preview {
    NavigationStack {
        RoutineManagementView(
            repository: PreviewManagementRoutineRepository(
                entities: [
                    RoutineEntity(routine: MockRoutineData.currentRoutine),
                    RoutineEntity(routine: MockRoutineData.nextRoutine)
                ]
            ),
            recurringRhythmRepository: PreviewManagementRecurringRepository(),
            onSaveRoutine: { _ in },
            onUpdateRoutine: { _ in },
            onDeleteRoutine: { _ in }
        )
    }
}

@MainActor
private final class PreviewManagementRoutineRepository: RoutineRepository {
    private var entities: [RoutineEntity]

    init(entities: [RoutineEntity] = []) {
        self.entities = entities
    }

    func fetchRoutines() throws -> [RoutineEntity] { entities }
    func insert(_ input: RoutineCreationInput) throws {}
    func insert(_ routine: RoutineEntity) throws { entities.append(routine) }
    func update(_ input: RoutineCreationInput) throws {}
    func clearRecurrenceMetadata(id: UUID) throws {}
    func updateStatus(id: UUID, status: RoutineStatus) throws {}
    func delete(_ routine: RoutineEntity) throws {
        entities.removeAll { $0.id == routine.id }
    }
    func delete(id: UUID) throws {
        entities.removeAll { $0.id == id }
    }
    func hasOccurrence(
        recurringRhythmID: UUID,
        occurrenceDate: Date
    ) throws -> Bool {
        false
    }
}

@MainActor
private final class PreviewManagementRecurringRepository: RecurringRhythmRepository {
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
