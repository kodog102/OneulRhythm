//
//  RoutineManagementView.swift
//  OneulRhythm
//

import SwiftUI

struct RoutineManagementView: View {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @StateObject private var viewModel: RoutineManagementViewModel
    @State private var isAddingRoutine = false
    @State private var editingItemID: UUID?
    @State private var itemPendingDeletion: ManagementRhythmItem?

    private let onSaveRoutine: (RoutineCreationInput) throws -> Void
    private let onUpdateRoutine: (RoutineCreationInput) throws -> Void
    private let onRoutinesChanged: () -> Void
    private let nowProvider: () -> Date
    private let dayPolicy: CalendarDayPolicy
    private let calendar: Calendar

    private static let recurringSectionTitle = "반복되는 리듬"
    private static let oneTimeSectionTitle = "예정된 리듬"

    private static let minimumRowHeight: CGFloat = 72
    private static let contentMotionDuration: TimeInterval = 0.25

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
        self.dayPolicy = dayPolicy
        self.calendar = dayPolicy.calendar
    }

    var body: some View {
        Group {
            if viewModel.isLoading && viewModel.isEmpty {
                loadingState
            } else if let loadErrorMessage = viewModel.loadErrorMessage,
                      viewModel.isEmpty {
                errorState(message: loadErrorMessage)
            } else if viewModel.isEmpty {
                emptyState
            } else {
                itemList
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .background(ORColors.background.ignoresSafeArea())
        .navigationTitle("내 리듬")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    isAddingRoutine = true
                } label: {
                    Image(systemName: "plus")
                        .foregroundStyle(ORColors.primary)
                        .frame(width: 44, height: 44)
                        .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                .accessibilityLabel("새 리듬 만들기")
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
        .animation(contentAnimation, value: viewModel.isEmpty)
        .animation(contentAnimation, value: viewModel.catalog.contentIdentity)
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

    private var contentAnimation: Animation? {
        reduceMotion ? nil : .easeInOut(duration: Self.contentMotionDuration)
    }

    private var editingItem: ManagementRhythmItem? {
        guard let editingItemID else { return nil }
        return viewModel.item(id: editingItemID)
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
        VStack(alignment: .leading, spacing: ORSpacing.xs) {
            Text("아직 만든 리듬이 없어요.")
                .orTypography(.title)
                .foregroundStyle(ORColors.textPrimary)
                .fixedSize(horizontal: false, vertical: true)
                .accessibilityAddTraits(.isHeader)

            Text("+ 버튼으로 첫 리듬을 만들어보세요.")
                .orTypography(.body)
                .foregroundStyle(ORColors.textSecondary)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.top, ORSpacing.xxs)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, ORSpacing.screenHorizontal)
        .padding(.top, ORSpacing.xl)
        .accessibilityElement(children: .combine)
    }

    private var itemList: some View {
        List {
            if !viewModel.catalog.recurring.isEmpty {
                managementSection(
                    title: Self.recurringSectionTitle,
                    items: viewModel.catalog.recurring
                )
            }

            if !viewModel.catalog.oneTime.isEmpty {
                managementSection(
                    title: Self.oneTimeSectionTitle,
                    items: viewModel.catalog.oneTime
                )
            }
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
        .listSectionSpacing(ORSpacing.sectionGap)
        .contentMargins(.top, ORSpacing.xxs, for: .scrollContent)
        .environment(\.defaultMinListRowHeight, Self.minimumRowHeight)
    }

    private func managementSection(
        title: String,
        items: [ManagementRhythmItem]
    ) -> some View {
        Section {
            ForEach(Array(items.enumerated()), id: \.element.id) { index, item in
                managementRow(item)
                    .listRowInsets(
                        EdgeInsets(
                            top: 0,
                            leading: ORSpacing.screenHorizontal,
                            bottom: 0,
                            trailing: ORSpacing.screenHorizontal
                        )
                    )
                    .listRowBackground(
                        ManagementSectionRowBackground(
                            isFirst: index == 0,
                            isLast: index == items.count - 1
                        )
                    )
                    .listRowSeparator(
                        index == items.count - 1 ? .hidden : .visible,
                        edges: .bottom
                    )
                    .listRowSeparatorTint(ORColors.divider)
                    .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                        Button(role: .destructive) {
                            itemPendingDeletion = item
                        } label: {
                            Text("삭제")
                        }
                    }
                    .contextMenu {
                        Button(role: .destructive) {
                            itemPendingDeletion = item
                        } label: {
                            Label("삭제", systemImage: "trash")
                        }
                    }
            }
        } header: {
            ORSectionLabel(text: title)
                .textCase(nil)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, ORSpacing.screenHorizontal)
                .padding(.bottom, ORSpacing.xxs)
                .accessibilityAddTraits(.isHeader)
        }
    }

    private func managementRow(_ item: ManagementRhythmItem) -> some View {
        let now = nowProvider()
        let scheduleSummary = item.formattedScheduleSummary(
            referenceDay: now,
            now: now,
            dayPolicy: dayPolicy
        )
        let accessibilityFragments = item.accessibilityScheduleFragments(
            referenceDay: now,
            now: now,
            dayPolicy: dayPolicy
        )

        return Button {
            editingItemID = item.id
        } label: {
            HStack(alignment: .center, spacing: ORSpacing.sm) {
                VStack(alignment: .leading, spacing: ORSpacing.xxs) {
                    Text(item.title)
                        .orTypography(.body, weight: .medium)
                        .foregroundStyle(ORColors.textPrimary)
                        .multilineTextAlignment(.leading)
                        .fixedSize(horizontal: false, vertical: true)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    Text(scheduleSummary)
                        .orTypography(.caption)
                        .foregroundStyle(ORColors.textSecondary)
                        .multilineTextAlignment(.leading)
                        .fixedSize(horizontal: false, vertical: true)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }

                Image(systemName: "chevron.right")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(ORColors.textTertiary)
                    .accessibilityHidden(true)
            }
            .padding(.vertical, ORSpacing.sm)
            .padding(.horizontal, ORSpacing.md)
            .frame(maxWidth: .infinity, minHeight: Self.minimumRowHeight, alignment: .leading)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(accessibilityLabel(title: item.title, fragments: accessibilityFragments))
        .accessibilityAddTraits(.isButton)
        .accessibilityHint("편집하려면 탭하세요")
    }

    private func accessibilityLabel(title: String, fragments: [String]) -> String {
        ([title] + fragments).joined(separator: ", ")
    }
}

// MARK: - Section Surface

/// Card-token section surface for List rows without a parallel card style.
///
/// Uses `ORColors.card`, `ORRadius.lg`, and a single section-level shadow on
/// the first row only so multi-row groups stay connected.
private struct ManagementSectionRowBackground: View {
    let isFirst: Bool
    let isLast: Bool

    var body: some View {
        let shape = UnevenRoundedRectangle(
            topLeadingRadius: isFirst ? ORRadius.lg : 0,
            bottomLeadingRadius: isLast ? ORRadius.lg : 0,
            bottomTrailingRadius: isLast ? ORRadius.lg : 0,
            topTrailingRadius: isFirst ? ORRadius.lg : 0,
            style: .continuous
        )

        return shape
            .fill(ORColors.card)
            .shadow(
                color: isFirst ? ORColors.cardShadow : .clear,
                radius: isFirst ? 10 : 0,
                x: 0,
                y: isFirst ? 4 : 0
            )
    }
}

// MARK: - Previews

#Preview("Recurring only") {
    ManagementPreviewHost(
        routines: [],
        recurring: [
            ManagementPreviewData.recurring(
                title: "아침 독서",
                startMinutes: 7 * 60 + 30,
                recurrence: .daily
            ),
            ManagementPreviewData.recurring(
                title: "저녁 산책",
                startMinutes: 20 * 60,
                recurrence: .weekdays
            )
        ]
    )
}

#Preview("One-time only") {
    ManagementPreviewHost(
        routines: [
            ManagementPreviewData.oneTime(
                title: "병원 방문",
                startTime: ManagementPreviewData.today(hour: 14, minute: 0)
            ),
            ManagementPreviewData.oneTime(
                title: "친구 약속",
                startTime: ManagementPreviewData.tomorrow(hour: 11, minute: 30)
            )
        ],
        recurring: []
    )
}

#Preview("Mixed") {
    ManagementPreviewHost(
        routines: [
            ManagementPreviewData.oneTime(
                title: "도서관",
                startTime: ManagementPreviewData.today(hour: 16, minute: 0)
            )
        ],
        recurring: [
            ManagementPreviewData.recurring(
                title: "아침 스트레칭",
                startMinutes: 7 * 60,
                recurrence: .daily
            ),
            ManagementPreviewData.recurring(
                title: "주말 산책",
                startMinutes: 10 * 60,
                recurrence: .weekends
            )
        ]
    )
}

#Preview("Single item") {
    ManagementPreviewHost(
        routines: [],
        recurring: [
            ManagementPreviewData.recurring(
                title: "따뜻한 차 한잔",
                startMinutes: 7 * 60 + 30,
                recurrence: .daily
            )
        ]
    )
}

#Preview("Many items") {
    ManagementPreviewHost(
        routines: (0..<4).map { index in
            ManagementPreviewData.oneTime(
                title: "예정 \(index + 1)",
                startTime: ManagementPreviewData.today(hour: 12 + index, minute: 0)
            )
        },
        recurring: (0..<8).map { index in
            ManagementPreviewData.recurring(
                title: "반복 리듬 \(index + 1)",
                startMinutes: (6 + index) * 60,
                recurrence: index.isMultiple(of: 2) ? .daily : .weekdays
            )
        }
    )
}

#Preview("Empty") {
    ManagementPreviewHost(routines: [], recurring: [])
}

#Preview("Long title") {
    ManagementPreviewHost(
        routines: [
            ManagementPreviewData.oneTime(
                title: "아주 길고 자세한 오늘의 특별 일정 이름인데도 자연스럽게 줄바꿈되어야 해요",
                startTime: ManagementPreviewData.today(hour: 15, minute: 0)
            )
        ],
        recurring: [
            ManagementPreviewData.recurring(
                title: "아침부터 저녁까지 이어지는 아주 긴 반복 리듬 제목도 잘려 보이지 않아야 합니다",
                startMinutes: 8 * 60,
                recurrence: .daily
            )
        ]
    )
}

#Preview("Large Dynamic Type") {
    ManagementPreviewHost(
        routines: [
            ManagementPreviewData.oneTime(
                title: "병원",
                startTime: ManagementPreviewData.today(hour: 14, minute: 0)
            )
        ],
        recurring: [
            ManagementPreviewData.recurring(
                title: "아침 독서",
                startMinutes: 7 * 60 + 30,
                recurrence: .daily
            )
        ]
    )
    .environment(\.sizeCategory, .accessibilityExtraExtraExtraLarge)
}

#Preview("Small iPhone") {
    ManagementPreviewHost(
        routines: [
            ManagementPreviewData.oneTime(
                title: "약속",
                startTime: ManagementPreviewData.tomorrow(hour: 19, minute: 0)
            )
        ],
        recurring: [
            ManagementPreviewData.recurring(
                title: "아침 스트레칭",
                startMinutes: 7 * 60,
                recurrence: .daily
            ),
            ManagementPreviewData.recurring(
                title: "저녁 정리",
                startMinutes: 21 * 60,
                recurrence: .weekdays
            )
        ]
    )
}

#Preview("Dark Mode") {
    ManagementPreviewHost(
        routines: [
            ManagementPreviewData.oneTime(
                title: "저녁 모임",
                startTime: ManagementPreviewData.today(hour: 19, minute: 0)
            )
        ],
        recurring: [
            ManagementPreviewData.recurring(
                title: "아침 독서",
                startMinutes: 7 * 60 + 30,
                recurrence: .daily
            )
        ]
    )
    .preferredColorScheme(.dark)
}

// MARK: - Preview Support

private enum ManagementPreviewData {
    static let calendar: Calendar = {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(identifier: "Asia/Seoul")!
        return calendar
    }()

    static let now: Date = {
        var components = DateComponents()
        components.year = 2026
        components.month = 7
        components.day = 26
        components.hour = 10
        components.minute = 0
        return calendar.date(from: components)!
    }()

    static func today(hour: Int, minute: Int) -> Date {
        calendar.date(bySettingHour: hour, minute: minute, second: 0, of: now) ?? now
    }

    static func tomorrow(hour: Int, minute: Int) -> Date {
        let day = calendar.date(byAdding: .day, value: 1, to: now) ?? now
        return calendar.date(bySettingHour: hour, minute: minute, second: 0, of: day) ?? day
    }

    static func recurring(
        title: String,
        startMinutes: Int,
        recurrence: RecurrenceRule
    ) -> RecurringRhythmEntity {
        RecurringRhythmEntity(
            title: title,
            category: .morning,
            startMinutes: startMinutes,
            durationMinutes: 30,
            recurrence: recurrence,
            startDate: calendar.startOfDay(for: now),
            isActive: true
        )
    }

    static func oneTime(title: String, startTime: Date) -> RoutineEntity {
        RoutineEntity(
            routine: Routine(
                title: title,
                startTime: startTime,
                endTime: startTime.addingTimeInterval(30 * 60),
                category: .focus,
                status: .upcoming
            )
        )
    }
}

private struct ManagementPreviewHost: View {
    let routines: [RoutineEntity]
    let recurring: [RecurringRhythmEntity]

    var body: some View {
        NavigationStack {
            RoutineManagementView(
                repository: PreviewManagementRoutineRepository(entities: routines),
                recurringRhythmRepository: PreviewManagementRecurringRepository(
                    definitions: recurring
                ),
                onSaveRoutine: { _ in },
                onUpdateRoutine: { _ in },
                onDeleteRoutine: { _ in },
                nowProvider: { ManagementPreviewData.now },
                dayPolicy: CalendarDayPolicy(calendar: ManagementPreviewData.calendar)
            )
        }
        .background(ORColors.background)
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
    private let definitions: [RecurringRhythmEntity]

    init(definitions: [RecurringRhythmEntity] = []) {
        self.definitions = definitions
    }

    func insert(_ definition: RecurringRhythmEntity) throws {}
    func fetchActive() throws -> [RecurringRhythmEntity] {
        definitions.filter(\.isActive)
    }
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
