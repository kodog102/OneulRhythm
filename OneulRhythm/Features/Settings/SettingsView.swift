//
//  SettingsView.swift
//  OneulRhythm
//

import SwiftUI

/// Quiet support utility — Settings UI Specification / DR-020.
struct SettingsView: View {
    @Environment(\.scenePhase) private var scenePhase
    @StateObject private var viewModel: SettingsViewModel

    init() {
        _viewModel = StateObject(
            wrappedValue: SettingsViewModel(
                preferenceStore: AppReminderPreferenceStore(),
                notificationScheduling: NotificationService()
            )
        )
    }

    /// Test / preview injection.
    init(viewModel: SettingsViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        List {
            notificationsSection
            supportSection
            aboutSection
        }
        .listStyle(.insetGrouped)
        .scrollContentBackground(.hidden)
        .listRowSeparatorTint(ORColors.divider)
        .background(ORColors.background.ignoresSafeArea())
        .navigationTitle("설정")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.refreshAuthorizationStatus()
        }
        .onChange(of: scenePhase) { _, phase in
            guard phase == .active else { return }
            Task {
                await viewModel.refreshAuthorizationStatus()
            }
        }
    }

    // MARK: - 알림

    private var notificationsSection: some View {
        Section {
            Toggle(isOn: $viewModel.remindersEnabled) {
                Text("리마인더")
                    .orTypography(.body)
                    .foregroundStyle(ORColors.textPrimary)
            }
            .tint(ORColors.primary)
            .listRowBackground(ORColors.card)
            .accessibilityLabel("리마인더")

            Button {
                viewModel.openSystemNotificationSettings()
            } label: {
                HStack {
                    Text("시스템 알림 설정")
                        .orTypography(.body)
                        .foregroundStyle(ORColors.textPrimary)
                    Spacer()
                    Text(viewModel.systemNotificationStatusText)
                        .orTypography(.caption)
                        .foregroundStyle(ORColors.textSecondary)
                    disclosureChevron
                }
            }
            .buttonStyle(.plain)
            .listRowBackground(ORColors.card)
            .accessibilityLabel("시스템 알림 설정")
            .accessibilityValue(viewModel.systemNotificationStatusText)
            .accessibilityHint("시스템 설정에서 알림을 변경합니다")
        } header: {
            settingsSectionHeader("알림")
        }
    }

    // MARK: - 지원

    private var supportSection: some View {
        Section {
            disclosureRow(
                title: "피드백",
                hint: "메일을 엽니다"
            ) {
                viewModel.openFeedbackMail()
            }

            disclosureRow(
                title: "문의",
                hint: "메일을 엽니다"
            ) {
                viewModel.openContactMail()
            }
        } header: {
            settingsSectionHeader("지원")
        }
    }

    // MARK: - 정보

    private var aboutSection: some View {
        Section {
            HStack {
                Text("버전")
                    .orTypography(.body)
                    .foregroundStyle(ORColors.textPrimary)
                Spacer()
                Text(viewModel.appVersion)
                    .orTypography(.caption)
                    .foregroundStyle(ORColors.textSecondary)
            }
            .listRowBackground(ORColors.card)
            .accessibilityElement(children: .ignore)
            .accessibilityLabel("버전, \(viewModel.appVersion)")

            NavigationLink {
                SettingsDocumentView(
                    title: "개인정보 처리방침",
                    bodyText: SettingsDocumentCopy.privacyPlaceholder
                )
            } label: {
                Text("개인정보 처리방침")
                    .orTypography(.body)
                    .foregroundStyle(ORColors.textPrimary)
            }
            .listRowBackground(ORColors.card)
            .accessibilityHint("문서를 엽니다")

            NavigationLink {
                SettingsDocumentView(
                    title: "이용약관",
                    bodyText: SettingsDocumentCopy.termsPlaceholder
                )
            } label: {
                Text("이용약관")
                    .orTypography(.body)
                    .foregroundStyle(ORColors.textPrimary)
            }
            .listRowBackground(ORColors.card)
            .accessibilityHint("문서를 엽니다")

            NavigationLink {
                SettingsDocumentView(
                    title: "오픈 소스 라이선스",
                    bodyText: SettingsDocumentCopy.licensesPlaceholder
                )
            } label: {
                Text("오픈 소스 라이선스")
                    .orTypography(.body)
                    .foregroundStyle(ORColors.textPrimary)
            }
            .listRowBackground(ORColors.card)
            .accessibilityHint("문서를 엽니다")
        } header: {
            settingsSectionHeader("정보")
        }
    }

    private func disclosureRow(
        title: String,
        hint: String,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            HStack {
                Text(title)
                    .orTypography(.body)
                    .foregroundStyle(ORColors.textPrimary)
                Spacer()
                disclosureChevron
            }
        }
        .accessibilityLabel(title)
        .accessibilityHint(hint)
        .buttonStyle(.plain)
        .listRowBackground(ORColors.card)
    }

    private func settingsSectionHeader(_ title: String) -> some View {
        ORSectionLabel(text: title)
            .textCase(nil)
            .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var disclosureChevron: some View {
        Image(systemName: "chevron.right")
            .font(ORTypography.font(for: .caption, weight: .semibold))
            .foregroundStyle(ORColors.textTertiary)
            .accessibilityHidden(true)
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
