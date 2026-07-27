//
//  SettingsDocumentView.swift
//  OneulRhythm
//

import SwiftUI

/// Plain utility document surface for Settings disclosures (Privacy, Terms, Licenses).
struct SettingsDocumentView: View {
    let title: String
    let bodyText: String

    var body: some View {
        ScrollView {
            Text(bodyText)
                .orTypography(.body)
                .foregroundStyle(ORColors.textSecondary)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, ORSpacing.screenHorizontal)
                .padding(.vertical, ORSpacing.lg)
        }
        .background(ORColors.background.ignoresSafeArea())
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
    }
}
