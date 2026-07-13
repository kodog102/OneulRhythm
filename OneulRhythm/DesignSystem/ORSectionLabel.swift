//
//  ORSectionLabel.swift
//  OneulRhythm
//

import SwiftUI

struct ORSectionLabel: View {
    let text: String

    var body: some View {
        Text(text)
            .orTypography(.caption, weight: .medium)
            .foregroundStyle(ORColors.textSecondary)
    }
}

#Preview {
    ORSectionLabel(text: "현재 리듬")
        .padding()
        .background(ORColors.background)
}
