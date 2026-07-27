//
//  WarmLightAppearanceTests.swift
//  OneulRhythmTests
//
//  Verifies DR-021 Warm Light Appearance ownership at the app target.
//

import XCTest
@testable import OneulRhythm

final class WarmLightAppearanceTests: XCTestCase {
    func testAppInfoPlistDeclaresLightUserInterfaceStyle() {
        let style = Bundle.main.object(forInfoDictionaryKey: "UIUserInterfaceStyle") as? String
        XCTAssertEqual(
            style,
            "Light",
            "OneulRhythm must declare UIUserInterfaceStyle=Light (DR-021 Warm Light Appearance)."
        )
    }

    func testDesignSystemColorsAreNonAdaptiveRGB() {
        // Fixed sRGB tokens — not Asset Catalog appearances — keep Warm Light stable.
        XCTAssertNotNil(ORColors.background)
        XCTAssertNotNil(ORColors.card)
        XCTAssertNotNil(ORColors.primary)
        XCTAssertNotNil(ORColors.textPrimary)
        XCTAssertNotNil(ORColors.textSecondary)
    }
}
