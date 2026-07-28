//
//  TodayRhythmLiveActivityWidget.swift
//  OneulRhythmWidgets
//
//  Live Activity ActivityKit configuration — Sprint 21-4 category identity.
//  Visual Source of Truth: Docs/Visual/NorthStars/LiveActivity/LiveActivity-NorthStar-v1.png
//

import ActivityKit
import SwiftUI
import WidgetKit

struct TodayRhythmLiveActivityWidget: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: TodayRhythmActivityAttributes.self) { context in
            TodayRhythmLockScreenView(
                state: context.state,
                now: Date()
            )
            .activityBackgroundTint(TodayRhythmLiveActivityPalette.expandedField.opacity(0.85))
            .activitySystemActionForegroundColor(
                LiveActivityStateAccent.resolve(
                    state: context.state,
                    now: Date()
                ).color
            )
        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.leading) {
                    TodayRhythmIslandCategoryMark(
                        state: context.state,
                        now: Date(),
                        size: TodayRhythmLiveActivityIslandMetrics.expandedMark
                    )
                    .padding(.leading, 2)
                }
                DynamicIslandExpandedRegion(.center) {
                    TodayRhythmIslandExpandedView(
                        state: context.state,
                        now: Date()
                    )
                }
                DynamicIslandExpandedRegion(.trailing) {
                    EmptyView()
                }
            } compactLeading: {
                TodayRhythmIslandCategoryMark(
                    state: context.state,
                    now: Date(),
                    size: TodayRhythmLiveActivityIslandMetrics.compactMark
                )
            } compactTrailing: {
                TodayRhythmIslandCompactTrailingView(
                    state: context.state,
                    now: Date()
                )
            } minimal: {
                TodayRhythmIslandCategoryMark(
                    state: context.state,
                    now: Date(),
                    size: TodayRhythmLiveActivityIslandMetrics.minimalMark
                )
            }
        }
    }
}

#if DEBUG
struct TodayRhythmLiveActivityWidget_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            TodayRhythmLockScreenView(
                state: .previewActive,
                now: Date()
            )
            .frame(height: 88)
            .padding()
            .background(Color.black)
            .previewDisplayName("Expanded")

            TodayRhythmNotificationCompactView(
                state: .previewActive,
                now: Date()
            )
            .frame(height: 64)
            .padding()
            .background(Color.gray.opacity(0.2))
            .previewDisplayName("Notification Compact")

            TodayRhythmStandByView(
                state: .previewActive,
                now: Date()
            )
            .frame(width: 520, height: 120)
            .padding()
            .background(Color.black)
            .previewDisplayName("StandBy")

            TodayRhythmIslandExpandedView(
                state: .previewActive,
                now: Date()
            )
            .padding()
            .background(Color.black)
            .previewDisplayName("Dynamic Island Expanded")
        }
    }
}
#endif
