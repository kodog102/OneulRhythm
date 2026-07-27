//
//  TodayRhythmLiveActivityWidget.swift
//  OneulRhythmWidgets
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
            .activityBackgroundTint(ORColors.background)
            .activitySystemActionForegroundColor(ORColors.primary)
        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.leading) {
                    BreathFlowMark(size: TodayRhythmLiveActivityIslandMetrics.expandedMark)
                }
                DynamicIslandExpandedRegion(.center) {
                    TodayRhythmIslandExpandedView(
                        state: context.state,
                        now: Date()
                    )
                }
            } compactLeading: {
                BreathFlowMark(size: TodayRhythmLiveActivityIslandMetrics.compactMark)
            } compactTrailing: {
                if let title = TodayRhythmLiveActivityCopy.primaryTitle(state: context.state, now: Date()) {
                    Text(title)
                        // Platform compact slot — caption2 stays glanceable at Island scale.
                        .font(.caption2)
                        .foregroundStyle(.white)
                        .lineLimit(1)
                        .minimumScaleFactor(0.7)
                }
            } minimal: {
                BreathFlowMark(size: TodayRhythmLiveActivityIslandMetrics.minimalMark)
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
            .padding()
            .background(ORColors.background)
            .previewDisplayName("Lock Screen")

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
