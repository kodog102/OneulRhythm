//
//  TodayView.swift
//  OneulRhythm
//

import SwiftUI

struct TodayView: View {
    @StateObject private var viewModel: TodayViewModel
    @State private var isAddRoutinePresented = false

    init(viewModel: TodayViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    init() {
        self.init(viewModel: TodayViewModel())
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: ORSpacing.sectionGap) {
                    header

                    RoutineCardView(
                        routine: viewModel.currentRoutine,
                        onComplete: viewModel.completeCurrentRoutine,
                        onSnooze: viewModel.snoozeCurrentRoutine
                    )
                    RoutineCardView(routine: viewModel.nextRoutine)

                    TodayProgressView(
                        title: "오늘의 흐름",
                        description: "오늘의 흐름이 차분하게 이어지고 있어요",
                        completedCount: 2,
                        totalCount: 5
                    )

                    AddRoutineCardView(
                        title: "리듬 추가하기",
                        action: { isAddRoutinePresented = true }
                    )
                }
                .padding(.horizontal, ORSpacing.screenHorizontal)
                .padding(.bottom, ORSpacing.scrollBottom)
            }
            .safeAreaPadding(.top, ORSpacing.screenTop)
            .background(ORColors.background.ignoresSafeArea())
            .navigationDestination(isPresented: $isAddRoutinePresented) {
                AddRoutineView()
            }
        }
    }

    private var header: some View {
        Text("오늘 당신의 리듬은\n어떤가요")
            .orTypography(.largeTitle)
            .foregroundStyle(ORColors.textPrimary)
            .padding(.bottom, ORSpacing.xs)
    }
}

#Preview {
    TodayView()
}

#Preview("Completed") {
    TodayView(
        viewModel: TodayViewModel(
            currentRoutine: MockRoutineData.currentRoutine.updatingStatus(.completed)
        )
    )
}
