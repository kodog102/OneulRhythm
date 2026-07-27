//
//  ORTypography.swift
//  OneulRhythm
//

import SwiftUI

enum ORTypography {
    enum Style {
        case largeTitle
        case title
        case body
        case caption
    }

    static func font(for style: Style, weight: Font.Weight? = nil) -> Font {
        switch style {
        case .largeTitle:
            return .system(.largeTitle, design: .rounded, weight: weight ?? .semibold)
        case .title:
            return .system(.title2, design: .rounded, weight: weight ?? .semibold)
        case .body:
            return .system(.body, design: .default, weight: weight ?? .regular)
        case .caption:
            return .system(.subheadline, design: .default, weight: weight ?? .regular)
        }
    }

    static func defaultWeight(for style: Style) -> Font.Weight {
        switch style {
        case .largeTitle: .semibold
        case .title: .semibold
        case .body: .regular
        case .caption: .regular
        }
    }

    static func lineSpacing(for style: Style) -> CGFloat {
        switch style {
        case .largeTitle: 7
        case .title: 4
        case .body: 3
        case .caption: 2
        }
    }

    static func tracking(for style: Style) -> CGFloat {
        switch style {
        case .caption: 0.2
        default: 0
        }
    }
}

extension View {
    func orTypography(_ style: ORTypography.Style, weight: Font.Weight? = nil) -> some View {
        let resolvedWeight = weight ?? ORTypography.defaultWeight(for: style)
        let tracking = ORTypography.tracking(for: style)
        return font(ORTypography.font(for: style, weight: resolvedWeight))
            .lineSpacing(ORTypography.lineSpacing(for: style))
            .kerning(tracking)
    }
}

#Preview("Typography") {
    VStack(alignment: .leading, spacing: ORSpacing.lg) {
        Text("오늘 당신의 리듬은\n어떤가요")
            .orTypography(.largeTitle)
        Text("따뜻한 차 한잔 마시기")
            .orTypography(.title)
        Text("오늘의 흐름이 차분하게 이어지고 있어요")
            .orTypography(.body)
        Text("오전 7:30 - 7:45")
            .orTypography(.caption)
    }
    .foregroundStyle(ORColors.textPrimary)
    .padding()
    .background(ORColors.background)
}
