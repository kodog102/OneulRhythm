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
        Section("알림") {
            Toggle(isOn: $viewModel.remindersEnabled) {
                Text("리마인더")
            }
            .tint(ORColors.primary)
            .accessibilityLabel("리마인더")

            Button {
                viewModel.openSystemNotificationSettings()
            } label: {
                HStack {
                    Text("시스템 알림 설정")
                        .foregroundStyle(ORColors.textPrimary)
                    Spacer()
                    Text(viewModel.systemNotificationStatusText)
                        .foregroundStyle(ORColors.textSecondary)
                    Image(systemName: "chevron.right")
                        .font(.footnote.weight(.semibold))
                        .foregroundStyle(ORColors.textTertiary)
                        .accessibilityHidden(true)
                }
            }
            .buttonStyle(.plain)
            .accessibilityLabel("시스템 알림 설정")
            .accessibilityValue(viewModel.systemNotificationStatusText)
            .accessibilityHint("시스템 설정에서 알림을 변경합니다")
        }
    }

    // MARK: - 지원

    private var supportSection: some View {
        Section("지원") {
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
        }
    }

    // MARK: - 정보

    private var aboutSection: some View {
        Section("정보") {
            HStack {
                Text("버전")
                Spacer()
                Text(viewModel.appVersion)
                    .foregroundStyle(ORColors.textSecondary)
            }
            .accessibilityElement(children: .ignore)
            .accessibilityLabel("버전, \(viewModel.appVersion)")

            NavigationLink {
                SettingsDocumentView(
                    title: "개인정보 처리방침",
                    bodyText: SettingsDocumentCopy.privacyPlaceholder
                )
            } label: {
                Text("개인정보 처리방침")
            }
            .accessibilityHint("문서를 엽니다")

            NavigationLink {
                SettingsDocumentView(
                    title: "이용약관",
                    bodyText: SettingsDocumentCopy.termsPlaceholder
                )
            } label: {
                Text("이용약관")
            }
            .accessibilityHint("문서를 엽니다")

            NavigationLink {
                SettingsDocumentView(
                    title: "오픈 소스 라이선스",
                    bodyText: SettingsDocumentCopy.licensesPlaceholder
                )
            } label: {
                Text("오픈 소스 라이선스")
            }
            .accessibilityHint("문서를 엽니다")
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
                    .foregroundStyle(ORColors.textPrimary)
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.footnote.weight(.semibold))
                    .foregroundStyle(ORColors.textTertiary)
                    .accessibilityHidden(true)
            }
        }
        .accessibilityLabel(title)
        .accessibilityHint(hint)
        .buttonStyle(.plain)
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
