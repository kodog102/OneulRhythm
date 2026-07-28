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
    /// Filter tabs — presentation-layer filtering only (Sprint 20-2 / 20-3).
    @State private var selectedFilterTab: MyRhythmsFilterTab = .all
    @ScaledMetric(relativeTo: .body) private var categoryGlyphSize: CGFloat = 40
    @ScaledMetric(relativeTo: .body) private var filterTabHeight: CGFloat = 36
    @ScaledMetric(relativeTo: .title) private var heroTitleSize: CGFloat = 32

    private let onSaveRoutine: (RoutineCreationInput) throws -> Void
    private let onUpdateRoutine: (RoutineCreationInput) throws -> Void
    private let onRoutinesChanged: () -> Void
    /// Pops Management (and Editor) back to Today after a successful *create* from My Rhythms.
    private let onReturnToTodayAfterSave: () -> Void
    private let nowProvider: () -> Date
    private let dayPolicy: CalendarDayPolicy
    private let calendar: Calendar

    private static let minimumRowHeight: CGFloat = 84
    private static let contentMotionDuration: TimeInterval = 0.25
    private static let filterMotionDuration: TimeInterval = 0.22
    private static let bottomCTAHeight: CGFloat = ORTodaySurface.ctaHeight

    init(
        repository: RoutineRepository,
        recurringRhythmRepository: RecurringRhythmRepository,
        onSaveRoutine: @escaping (RoutineCreationInput) throws -> Void,
        onUpdateRoutine: @escaping (RoutineCreationInput) throws -> Void,
        onDeleteRoutine: @escaping (UUID) throws -> Void,
        onRoutinesChanged: @escaping () -> Void = {},
        onReturnToTodayAfterSave: @escaping () -> Void = {},
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
        self.onReturnToTodayAfterSave = onReturnToTodayAfterSave
        self.nowProvider = nowProvider
        self.dayPolicy = dayPolicy
        self.calendar = dayPolicy.calendar
    }

    var body: some View {
        Group {
            if viewModel.isLoading && viewModel.isEmpty {
                managementScrollCanvas { loadingState }
            } else if let loadErrorMessage = viewModel.loadErrorMessage,
                      viewModel.isEmpty {
                managementScrollCanvas { errorState(message: loadErrorMessage) }
            } else {
                itemList
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .background {
            // Today is the atmosphere source of truth — identical shared component / defaults.
            ORAtmosphereBackground()
        }
        .orNavigationStandard()
        .safeAreaInset(edge: .bottom, spacing: 0) {
            if showsBottomCreateCTA {
                createRhythmCTA
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
                onSaveSuccess: {
                    // Create from My Rhythms still returns to Today (Sprint 19-2H).
                    onReturnToTodayAfterSave()
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
        .animation(contentAnimation, value: selectedFilterTab)
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
            "리듬을 삭제하지 못했어요",
            isPresented: mutationErrorBinding
        ) {
            Button("확인", role: .cancel) {}
        } message: {
            Text(viewModel.mutationErrorMessage ?? "잠시 후 다시 시도해주세요.")
        }
    }

    private var showsBottomCreateCTA: Bool {
        if viewModel.isLoading && viewModel.isEmpty { return false }
        if viewModel.loadErrorMessage != nil && viewModel.isEmpty { return false }
        return true
    }

    private var allItems: [ManagementRhythmItem] {
        viewModel.catalog.recurring + viewModel.catalog.oneTime
    }

    /// Presentation-only filter over the loaded catalog (no repository changes).
    private var filteredItems: [ManagementRhythmItem] {
        switch selectedFilterTab {
        case .all:
            return allItems
        case .recurring:
            return viewModel.catalog.recurring
        case .oneTime:
            return viewModel.catalog.oneTime
        }
    }

    private var contentAnimation: Animation? {
        reduceMotion ? nil : .easeInOut(duration: Self.contentMotionDuration)
    }

    private var filterAnimation: Animation? {
        reduceMotion ? nil : .easeInOut(duration: Self.filterMotionDuration)
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
            // Edit from My Rhythms — omit onSaveSuccess so the editor dismisses
            // back to My Rhythms (explicit presentation return; not Today).
            nowProvider: nowProvider,
            calendar: calendar
        )
    }

    // MARK: - Chrome

    private var createRhythmCTA: some View {
        Button {
            isAddingRoutine = true
        } label: {
            Text("리듬 만들기")
                .font(ORTodayTypography.cta)
                .tracking(ORTodayTypography.ctaTracking)
                .foregroundStyle(Color.white)
                .frame(maxWidth: .infinity)
                .frame(height: Self.bottomCTAHeight)
                .background(
                    RoundedRectangle(cornerRadius: ORRadius.button, style: .continuous)
                        .fill(ORTodaySurface.ctaFill)
                )
                .compositingGroup()
                .shadow(color: ORTodaySurface.ctaFill.opacity(0.32), radius: 16, x: 0, y: 8)
                .shadow(color: ORTodaySurface.ctaFill.opacity(0.16), radius: 4, x: 0, y: 2)
                .contentShape(Rectangle())
        }
        .buttonStyle(MyRhythmsCalmPressButtonStyle(reduceMotion: reduceMotion))
        .padding(.horizontal, ORSpacing.screenHorizontal)
        .padding(.top, ORSpacing.sm)
        .padding(.bottom, ORSpacing.sm)
        .accessibilityLabel("리듬 만들기")
        .accessibilityHint("새 리듬을 만듭니다")
    }

    private func managementScrollCanvas<Content: View>(
        @ViewBuilder content: () -> Content
    ) -> some View {
        ScrollView {
            VStack(alignment: .leading, spacing: ORSpacing.lg) {
                heroHeader
                filterTabs
                content()
            }
            .padding(.horizontal, ORSpacing.screenHorizontal)
            .padding(.top, ORSpacing.xs)
            .padding(.bottom, ORSpacing.xl)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .scrollIndicators(.hidden)
    }

    private var heroHeader: some View {
        VStack(alignment: .leading, spacing: ORSpacing.xs) {
            Text("내 리듬")
                .font(.system(size: heroTitleSize, weight: .bold, design: .default))
                .foregroundStyle(ORTodayTypography.displayInk)
                .fixedSize(horizontal: false, vertical: true)
                .accessibilityAddTraits(.isHeader)

            Text("나만의 리듬들을 관리해보세요.")
                .font(ORTodayTypography.date)
                .tracking(ORTodayTypography.dateTracking)
                .foregroundStyle(ORTodayTypography.supportingInk)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .accessibilityElement(children: .combine)
    }

    private var filterTabs: some View {
        HStack(spacing: ORSpacing.xs) {
            ForEach(MyRhythmsFilterTab.allCases) { tab in
                filterTabButton(tab)
            }
            Spacer(minLength: 0)
        }
        .accessibilityElement(children: .contain)
        .accessibilityLabel("리듬 필터")
    }

    private func filterTabButton(_ tab: MyRhythmsFilterTab) -> some View {
        let isSelected = selectedFilterTab == tab
        return Button {
            guard selectedFilterTab != tab else { return }
            withAnimation(filterAnimation) {
                selectedFilterTab = tab
            }
        } label: {
            Text(tab.title)
                .font(.system(size: 14, weight: isSelected ? .semibold : .medium))
                .foregroundStyle(
                    isSelected
                        ? ORTodayTypography.displayInk
                        : ORTodayTypography.quietInk
                )
                .padding(.horizontal, ORSpacing.md)
                .frame(height: filterTabHeight)
                .background {
                    Capsule(style: .continuous)
                        .fill(
                            isSelected
                                ? Color.white.opacity(0.88)
                                : Color.white.opacity(0.42)
                        )
                        .overlay(
                            Capsule(style: .continuous)
                                .strokeBorder(
                                    isSelected
                                        ? ORTodaySurface.ctaFill.opacity(0.35)
                                        : Color.black.opacity(0.04),
                                    lineWidth: 1
                                )
                        )
                        .shadow(
                            color: isSelected
                                ? ORTodaySurface.warmShadow.opacity(0.10)
                                : .clear,
                            radius: isSelected ? 8 : 0,
                            x: 0,
                            y: isSelected ? 3 : 0
                        )
                }
        }
        .buttonStyle(.plain)
        .accessibilityAddTraits(isSelected ? [.isSelected] : [])
        .accessibilityLabel(tab.title)
        .accessibilityHint(isSelected ? "선택됨" : "이 필터로 목록을 봅니다")
    }

    // MARK: - States

    private var loadingState: some View {
        HStack(spacing: ORSpacing.md) {
            ProgressView()
                .tint(ORColors.primary)
            Text("리듬을 불러오는 중이에요")
                .orTypography(.body)
                .foregroundStyle(ORColors.textSecondary)
        }
        .padding(.top, ORSpacing.md)
    }

    private func errorState(message: String) -> some View {
        Text(message)
            .orTypography(.body)
            .foregroundStyle(ORColors.textSecondary)
            .padding(.top, ORSpacing.md)
    }

    private var filterEmptyState: some View {
        let copy = emptyCopy(for: selectedFilterTab, catalogIsEmpty: viewModel.isEmpty)
        return VStack(spacing: ORSpacing.sm) {
            Spacer(minLength: ORSpacing.xxl)

            Image(systemName: "leaf.fill")
                .font(.system(size: 26, weight: .regular))
                .foregroundStyle(ORTodaySurface.ctaFill.opacity(0.75))
                .padding(.bottom, ORSpacing.xxs)
                .accessibilityHidden(true)

            Text(copy.title)
                .font(ORTodayTypography.secondaryValue)
                .tracking(ORTodayTypography.secondaryValueTracking)
                .foregroundStyle(ORTodayTypography.displayInk)
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
                .accessibilityAddTraits(.isHeader)

            if let subtitle = copy.subtitle {
                Text(subtitle)
                    .font(ORTodayTypography.meta)
                    .tracking(ORTodayTypography.metaTracking)
                    .foregroundStyle(ORTodayTypography.supportingInk)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.top, ORSpacing.xxs)
            }

            Spacer(minLength: ORSpacing.xxxl)
        }
        .frame(maxWidth: .infinity, minHeight: 280)
        .accessibilityElement(children: .combine)
    }

    private func emptyCopy(
        for tab: MyRhythmsFilterTab,
        catalogIsEmpty: Bool
    ) -> (title: String, subtitle: String?) {
        switch tab {
        case .all:
            return (
                "아직 만든 리듬이 없어요.",
                catalogIsEmpty ? "리듬을 만들면 여기에 표시됩니다." : nil
            )
        case .recurring:
            return ("반복 리듬이 없어요.", nil)
        case .oneTime:
            return ("원타임 리듬이 없어요.", nil)
        }
    }

    // MARK: - List

    private var itemList: some View {
        List {
            Section {
                heroHeader
                    .listRowInsets(
                        EdgeInsets(
                            top: ORSpacing.xs,
                            leading: ORSpacing.screenHorizontal,
                            bottom: ORSpacing.sm,
                            trailing: ORSpacing.screenHorizontal
                        )
                    )
                    .listRowBackground(Color.clear)
                    .listRowSeparator(.hidden)

                filterTabs
                    .listRowInsets(
                        EdgeInsets(
                            top: 0,
                            leading: ORSpacing.screenHorizontal,
                            bottom: ORSpacing.sm,
                            trailing: ORSpacing.screenHorizontal
                        )
                    )
                    .listRowBackground(Color.clear)
                    .listRowSeparator(.hidden)
            }

            Section {
                if filteredItems.isEmpty {
                    filterEmptyState
                        .listRowInsets(
                            EdgeInsets(
                                top: ORSpacing.sm,
                                leading: ORSpacing.screenHorizontal,
                                bottom: ORSpacing.sm,
                                trailing: ORSpacing.screenHorizontal
                            )
                        )
                        .listRowBackground(Color.clear)
                        .listRowSeparator(.hidden)
                        .transition(.opacity.combined(with: .move(edge: .bottom)))
                } else {
                    ForEach(Array(filteredItems.enumerated()), id: \.element.id) { index, item in
                        managementRow(item)
                            .listRowInsets(
                                EdgeInsets(
                                    top: 6,
                                    leading: ORSpacing.screenHorizontal,
                                    bottom: 6,
                                    trailing: ORSpacing.screenHorizontal
                                )
                            )
                            .listRowBackground(Color.clear)
                            .listRowSeparator(.hidden)
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
                            .accessibilitySortPriority(Double(filteredItems.count - index))
                            .transition(.opacity)
                    }
                }
            }
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
        .listSectionSpacing(0)
        .scrollIndicators(.hidden)
        .environment(\.defaultMinListRowHeight, Self.minimumRowHeight)
    }

    private func managementRow(_ item: ManagementRhythmItem) -> some View {
        let now = nowProvider()
        let scheduleLine = scheduleLine(for: item, now: now)
        let timeText = startTimeText(for: item)
        let reminderText = reminderLine(for: item)
        let typeBadge = typePresentation(for: item)
        let accessibilityFragments = item.accessibilityScheduleFragments(
            referenceDay: now,
            now: now,
            dayPolicy: dayPolicy
        )

        return Button {
            editingItemID = item.id
        } label: {
            HStack(alignment: .center, spacing: ORSpacing.sm) {
                categoryGlyph(for: item.category)

                VStack(alignment: .leading, spacing: 6) {
                    Text(item.title)
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundStyle(ORTodayTypography.displayInk)
                        .multilineTextAlignment(.leading)
                        .lineLimit(2)
                        .minimumScaleFactor(0.9)
                        .fixedSize(horizontal: false, vertical: true)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    Text(scheduleLine)
                        .font(ORTodayTypography.meta)
                        .tracking(ORTodayTypography.metaTracking)
                        .foregroundStyle(ORTodayTypography.supportingInk)
                        .multilineTextAlignment(.leading)
                        .lineLimit(1)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    if let reminderText {
                        HStack(spacing: ORSpacing.xxs) {
                            Image(systemName: "bell.fill")
                                .font(.system(size: 10, weight: .medium))
                            Text(reminderText)
                                .font(ORTodayTypography.meta)
                        }
                        .foregroundStyle(ORTodayTypography.quietInk)
                    }
                }

                VStack(alignment: .trailing, spacing: 6) {
                    Text(timeText)
                        .font(.system(size: 14, weight: .medium, design: .rounded))
                        .foregroundStyle(ORTodayTypography.supportingInk)
                        .monospacedDigit()

                    HStack(spacing: ORSpacing.xxs) {
                        Circle()
                            .fill(typeBadge.dot)
                            .frame(width: 6, height: 6)
                        Text(typeBadge.title)
                            .font(.system(size: 12, weight: .medium))
                            .foregroundStyle(ORTodayTypography.supportingInk)
                    }
                }
                .frame(minWidth: 52, alignment: .trailing)

                Image(systemName: "chevron.right")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(ORTodayTypography.quietInk)
                    .frame(width: 12, alignment: .center)
                    .accessibilityHidden(true)
            }
            .padding(.vertical, 14)
            .padding(.horizontal, ORSpacing.md)
            .frame(maxWidth: .infinity, minHeight: Self.minimumRowHeight, alignment: .leading)
            .background {
                rhythmCardChrome
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(
            accessibilityLabel(
                title: item.title,
                fragments: accessibilityFragments + [typeBadge.title]
            )
        )
        .accessibilityAddTraits(.isButton)
        .accessibilityHint("편집하려면 탭하세요")
    }

    private var rhythmCardChrome: some View {
        RoundedRectangle(cornerRadius: ORRadius.md, style: .continuous)
            .fill(Color.white.opacity(0.92))
            .overlay(
                RoundedRectangle(cornerRadius: ORRadius.md, style: .continuous)
                    .strokeBorder(Color.black.opacity(0.04), lineWidth: 1)
            )
            .shadow(color: ORTodaySurface.warmShadow.opacity(0.10), radius: 10, x: 0, y: 4)
    }

    private func categoryGlyph(for category: RoutineCategory) -> some View {
        let style = ORRhythmCategoryStyle.style(forRawValue: category.rawValue)
        return Image(systemName: style.symbolName)
            .font(.system(size: 15, weight: .semibold))
            .foregroundStyle(style.foreground)
            .frame(width: categoryGlyphSize, height: categoryGlyphSize)
            .background(
                Circle()
                    .fill(style.background)
            )
            .accessibilityHidden(true)
    }

    private func scheduleLine(for item: ManagementRhythmItem, now: Date) -> String {
        switch item {
        case .recurring(let rhythm):
            return MyRhythmsScheduleCopy.recurring(rhythm.recurrence)
        case .oneTime(let routine):
            return MyRhythmsScheduleCopy.oneTimeDate(
                startTime: routine.startTime,
                now: now,
                dayPolicy: dayPolicy
            )
        }
    }

    private func startTimeText(for item: ManagementRhythmItem) -> String {
        let start = item.displayStartTime(referenceDay: nowProvider(), calendar: calendar)
        return start.formatted(MyRhythmsScheduleCopy.compactTimeFormat)
    }

    private func reminderLine(for item: ManagementRhythmItem) -> String? {
        guard let minutes = item.reminderMinutes else { return nil }
        return "\(minutes)분 전"
    }

    /// Rhythm *type* only — never state labels such as "활성".
    private func typePresentation(
        for item: ManagementRhythmItem
    ) -> (title: String, dot: Color) {
        switch item {
        case .recurring:
            return ("반복", ORTodaySurface.ctaFill)
        case .oneTime:
            return (
                "원타임",
                Color(red: 0.86, green: 0.58, blue: 0.38)
            )
        }
    }

    private func accessibilityLabel(title: String, fragments: [String]) -> String {
        ([title] + fragments).joined(separator: ", ")
    }
}

// MARK: - Filter Tabs

private enum MyRhythmsFilterTab: String, CaseIterable, Identifiable {
    case all
    case recurring
    case oneTime

    var id: String { rawValue }

    var title: String {
        switch self {
        case .all: return "전체"
        case .recurring: return "반복"
        case .oneTime: return "원타임"
        }
    }
}

// MARK: - Calm Press

private struct MyRhythmsCalmPressButtonStyle: ButtonStyle {
    let reduceMotion: Bool

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed && !reduceMotion ? 0.985 : 1)
            .opacity(configuration.isPressed ? 0.92 : 1)
            .animation(
                reduceMotion ? nil : .easeOut(duration: 0.16),
                value: configuration.isPressed
            )
    }
}

// MARK: - Presentation Helpers

private enum MyRhythmsScheduleCopy {
    static let compactTimeFormat = Date.FormatStyle()
        .hour(.twoDigits(amPM: .omitted))
        .minute(.twoDigits)
        .locale(Locale(identifier: "ko_KR"))

    static func recurring(_ rule: RecurrenceRule) -> String {
        switch rule {
        case .daily:
            return "매일"
        case .weekdays:
            return "매주 평일"
        case .weekends:
            return "매주 주말"
        }
    }

    static func oneTimeDate(
        startTime: Date,
        now: Date,
        dayPolicy: CalendarDayPolicy
    ) -> String {
        let today = dayPolicy.day(for: now)
        let routineDay = dayPolicy.day(for: startTime)
        if routineDay == today {
            return "오늘"
        }

        var format = Date.FormatStyle()
            .month(.abbreviated)
            .day()
            .locale(Locale(identifier: "ko_KR"))
        format.calendar = dayPolicy.calendar
        return startTime.formatted(format)
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
