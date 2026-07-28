//
//  ORNavigationStandard.swift
//  OneulRhythm
//
//  Project navigation standard (Sprint 19-2G).
//  Transparent bar — landscape continues behind; system Back stays visible.
//

import SwiftUI

extension View {
    /// OneulRhythm navigation chrome for push screens.
    ///
    /// - Transparent navigation background (no cream / material bar)
    /// - No separator or navigation shadow
    /// - System Back remains visible; content lays out below the bar
    /// - Empty inline title by default (callers may set a title when needed)
    func orNavigationStandard(title: String = "") -> some View {
        self
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(.hidden, for: .navigationBar)
            .toolbarBackgroundVisibility(.hidden, for: .navigationBar)
    }
}
