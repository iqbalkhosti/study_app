import SwiftUI
import Charts

struct DashboardView: View {
    @StateObject private var viewModel: DashboardViewModel
    @State private var showSessionSetup = false
    @State private var sessionNavigationPath = NavigationPath()
    
    init(sessionRepository: SessionRepository) {
        self._viewModel = StateObject(wrappedValue: DashboardViewModel(sessionRepository: sessionRepository))
    }
    
    var body: some View {
        NavigationStack(path: $sessionNavigationPath) {
            ScrollView {
                VStack(spacing: 24) {
                    TodaySummaryCard(stats: viewModel.todayStats)
                    
                    WeeklyChartCard(data: viewModel.weeklyDepthData)
                    
                    if viewModel.streak.currentHighDepthStreak > 0 || viewModel.streak.currentCompletionStreak > 0 {
                        StreakCard(streak: viewModel.streak)
                    }
                    
                    ForEach(viewModel.insights, id: \.type) { insight in
                        InsightCard(insight: insight)
                    }
                    
                    PrimaryButton(title: "Start Session", action: {
                        showSessionSetup = true
                    })
                    .padding()
                }
                .padding()
            }
            .navigationTitle("Focus")
            .refreshable {
                viewModel.loadData()
            }
            .fullScreenCover(isPresented: $showSessionSetup) {
                SessionCoordinatorView()
            }
        }
    }
}
