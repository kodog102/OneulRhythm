//
//  SettingsView.swift
//  OneulRhythm
//
//  Settings North Star — Sprint 21-1 / 21-2.
//  Visual Source of Truth: Docs/Visual/NorthStars/Settings/Settings-NorthStar-v1.png
//
//  Atmosphere matches Today (shared ORAtmosphereBackground defaults).
//  Quiet Hours suppresses reminder notifications only.
//

import SwiftUI

/// Quiet support utility — Settings UI Specification / DR-020 / North Star visual.
struct SettingsView: View {
    @Environment(\.scenePhase) private var scenePhase
    @StateObject private var viewModel: SettingsViewModel
    @ScaledMetric(relativeTo: .title) private var heroTitleSize: CGFloat = 32

    private static let rowMinHeight: CGFloat = 56

    init() {
        _viewModel = StateObject(
            wrappedValue: SettingsViewModel(
                preferenceStore: AppReminderPreferenceStore(),
                quietHoursStore: QuietHoursPreferenceStore(),
                notificationScheduling: NotificationService()
            )
        )
    }

    /// Test / preview injection.
    init(viewModel: SettingsViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: ORSpacing.lg) {
                heroHeader
                    .padding(.top, ORSpacing.sm)
                    .padding(.bottom, ORSpacing.xs)

                settingsSection(title: "알림") {
                    reminderRow
                    settingsDivider
                    quietHoursRow
                    if viewModel.quietHoursEnabled {
                        settingsDivider
                        quietHoursStartRow
                        settingsDivider
                        quietHoursEndRow
                    }
                    settingsDivider
                    systemNotificationRow
                }

                settingsSection(title: "지원") {
                    disclosureRow(
                        title: "피드백",
                        symbol: "envelope",
                        hint: "메일을 엽니다"
                    ) {
                        viewModel.openFeedbackMail()
                    }
                    settingsDivider
                    disclosureRow(
                        title: "문의",
                        symbol: "bubble.left.and.bubble.right",
                        hint: "메일을 엽니다"
                    ) {
                        viewModel.openContactMail()
                    }
                }

                settingsSection(title: "정보") {
                    versionRow
                    settingsDivider
                    documentLink(
                        title: "개인정보 처리방침",
                        symbol: "hand.raised",
                        documentTitle: "개인정보 처리방침",
                        bodyText: SettingsDocumentCopy.privacyPlaceholder
                    )
                    settingsDivider
                    documentLink(
                        title: "이용약관",
                        symbol: "doc.text",
                        documentTitle: "이용약관",
                        bodyText: SettingsDocumentCopy.termsPlaceholder
                    )
                    settingsDivider
                    documentLink(
                        title: "오픈 소스 라이선스",
                        symbol: "chevron.left.forwardslash.chevron.right",
                        documentTitle: "오픈 소스 라이선스",
                        bodyText: SettingsDocumentCopy.licensesPlaceholder
                    )
                }
            }
            .padding(.horizontal, ORSpacing.screenHorizontal)
            .padding(.top, ORSpacing.xs)
            .padding(.bottom, ORSpacing.scrollBottom)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .scrollIndicators(.hidden)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .background {
            // Today is the atmosphere source of truth — identical shared component / defaults.
            ORAtmosphereBackground()
        }
        .orNavigationStandard()
        .task {
            await viewModel.refreshAuthorizationStatus()
        }
        .onChange(of: scenePhase) { _, phase in
            guard phase == .active else { return }
            Task {
                await viewModel.refreshAuthorizationStatus()
            }
        }
        .animation(.easeInOut(duration: 0.22), value: viewModel.quietHoursEnabled)
    }

    // MARK: - Hero

    private var heroHeader: some View {
        VStack(alignment: .leading, spacing: ORSpacing.xs) {
            Text("설정")
                .font(.system(size: heroTitleSize, weight: .bold, design: .default))
                .foregroundStyle(ORTodayTypography.displayInk)
                .fixedSize(horizontal: false, vertical: true)
                .accessibilityAddTraits(.isHeader)

            Text("오늘리듬을 나에게 맞게 설정하세요.")
                .font(ORTodayTypography.date)
                .tracking(ORTodayTypography.dateTracking)
                .foregroundStyle(ORTodayTypography.supportingInk)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .accessibilityElement(children: .combine)
    }

    // MARK: - 알림

    private var reminderRow: some View {
        Toggle(isOn: $viewModel.remindersEnabled) {
            settingsLabel(title: "리마인더", symbol: "bell")
        }
        .tint(ORTodaySurface.ctaFill)
        .frame(minHeight: Self.rowMinHeight)
        .accessibilityLabel("리마인더")
        .accessibilityHint("앱 리마인더 알림을 켜거나 끕니다")
    }

    private var quietHoursRow: some View {
        Toggle(isOn: $viewModel.quietHoursEnabled) {
            settingsLabel(title: "조용한 시간", symbol: "moon")
        }
        .tint(ORTodaySurface.ctaFill)
        .frame(minHeight: Self.rowMinHeight)
        .accessibilityLabel("조용한 시간")
        .accessibilityHint("설정한 시간 동안 리마인더 알림만 잠시 멈춥니다")
    }

    private var quietHoursStartRow: some View {
        DatePicker(
            selection: $viewModel.quietHoursStart,
            displayedComponents: .hourAndMinute
        ) {
            settingsLabel(title: "시작", symbol: "clock")
        }
        .tint(ORTodaySurface.ctaFill)
        .frame(minHeight: Self.rowMinHeight)
        .accessibilityLabel("조용한 시간 시작")
    }

    private var quietHoursEndRow: some View {
        DatePicker(
            selection: $viewModel.quietHoursEnd,
            displayedComponents: .hourAndMinute
        ) {
            settingsLabel(title: "종료", symbol: "clock")
        }
        .tint(ORTodaySurface.ctaFill)
        .frame(minHeight: Self.rowMinHeight)
        .accessibilityLabel("조용한 시간 종료")
    }

    private var systemNotificationRow: some View {
        Button {
            viewModel.openSystemNotificationSettings()
        } label: {
            HStack(spacing: ORSpacing.sm) {
                settingsLabel(title: "시스템 알림 설정", symbol: "gearshape")
                Spacer(minLength: ORSpacing.xs)
                Text(viewModel.systemNotificationStatusText)
                    .font(ORTodayTypography.meta)
                    .tracking(ORTodayTypography.metaTracking)
                    .foregroundStyle(ORTodayTypography.supportingInk)
                disclosureChevron
            }
            .frame(minHeight: Self.rowMinHeight)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityLabel("시스템 알림 설정")
        .accessibilityValue(viewModel.systemNotificationStatusText)
        .accessibilityHint("시스템 설정에서 알림을 변경합니다")
    }

    // MARK: - 정보

    private var versionRow: some View {
        HStack(spacing: ORSpacing.sm) {
            settingsLabel(title: "버전", symbol: "info.circle")
            Spacer(minLength: ORSpacing.xs)
            Text(viewModel.appVersion)
                .font(ORTodayTypography.meta)
                .tracking(ORTodayTypography.metaTracking)
                .foregroundStyle(ORTodayTypography.supportingInk)
        }
        .frame(minHeight: Self.rowMinHeight)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("버전, \(viewModel.appVersion)")
    }

    // MARK: - Shared rows

    private func disclosureRow(
        title: String,
        symbol: String,
        hint: String,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            HStack(spacing: ORSpacing.sm) {
                settingsLabel(title: title, symbol: symbol)
                Spacer(minLength: ORSpacing.xs)
                disclosureChevron
            }
            .frame(minHeight: Self.rowMinHeight)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityLabel(title)
        .accessibilityHint(hint)
    }

    private func documentLink(
        title: String,
        symbol: String,
        documentTitle: String,
        bodyText: String
    ) -> some View {
        NavigationLink {
            SettingsDocumentView(title: documentTitle, bodyText: bodyText)
        } label: {
            HStack(spacing: ORSpacing.sm) {
                settingsLabel(title: title, symbol: symbol)
                Spacer(minLength: ORSpacing.xs)
                disclosureChevron
            }
            .frame(minHeight: Self.rowMinHeight)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityHint("문서를 엽니다")
    }

    private func settingsLabel(title: String, symbol: String) -> some View {
        HStack(spacing: ORSpacing.sm) {
            Image(systemName: symbol)
                .font(.system(size: 15, weight: .medium))
                .foregroundStyle(ORTodaySurface.ctaFill)
                .frame(width: 24, height: 24)
                .accessibilityHidden(true)

            Text(title)
                .font(.system(size: 16, weight: .medium))
                .foregroundStyle(ORTodayTypography.displayInk)
                .multilineTextAlignment(.leading)
        }
    }

    private var disclosureChevron: some View {
        Image(systemName: "chevron.right")
            .font(.system(size: 12, weight: .semibold))
            .foregroundStyle(ORTodayTypography.quietInk)
            .accessibilityHidden(true)
    }

    private var settingsDivider: some View {
        Rectangle()
            .fill(Color.black.opacity(0.04))
            .frame(height: 1)
            .padding(.leading, 40)
    }

    // MARK: - Section chrome

    private func settingsSection<Content: View>(
        title: String,
        @ViewBuilder content: () -> Content
    ) -> some View {
        VStack(alignment: .leading, spacing: ORSpacing.sm) {
            ORSectionLabel(text: title)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, ORSpacing.xxs)

            VStack(spacing: 0) {
                content()
            }
            .padding(.horizontal, ORSpacing.md)
            .background { sectionCardChrome }
        }
    }

    private var sectionCardChrome: some View {
        RoundedRectangle(cornerRadius: ORRadius.lg, style: .continuous)
            .fill(Color.white.opacity(0.95))
            .overlay(
                RoundedRectangle(cornerRadius: ORRadius.lg, style: .continuous)
                    .strokeBorder(Color.black.opacity(0.04), lineWidth: 1)
            )
            .shadow(color: ORTodaySurface.warmShadow.opacity(0.10), radius: 16, x: 0, y: 4)
    }
}

private enum SettingsDocumentCopy {
    static let privacyPlaceholder = """
    개인정보 처리방침 문서가 준비되는 동안 이 화면은 자리를 남겨 둡니다.

    자세한 내용은 이후 업데이트에서 제공됩니다.
    """

    static let termsPlaceholder = """
    이용약관 문서가 준비되는 동안 이 화면은 자리를 남겨 둡니다.

    자세한 내용은 이후 업데이트에서 제공됩니다.
    """

    static let licensesPlaceholder = """
    오픈 소스 라이선스 목록이 준비되는 동안 이 화면은 자리를 남겨 둡니다.

    사용된 라이브러리와 라이선스 전문은 이후 업데이트에서 제공됩니다.
    """
}

#Preview("Settings") {
    NavigationStack {
        SettingsView()
    }
}
