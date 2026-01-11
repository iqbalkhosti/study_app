import SwiftUI
import SwiftData

@main
struct FocusApp: App {
    @StateObject private var appState = AppState()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appState)
                .modelContainer(AppModelContainer.shared.container)
        }
    }
}

@MainActor
class AppState: ObservableObject {
    @Published var hasCompletedOnboarding = UserDefaults.standard.bool(forKey: "hasCompletedOnboarding")
    @Published var currentSessionFlow: SessionFlow?
    
    struct SessionFlow {
        let setupData: SessionSetupView.SessionSetupData
        var warmUpCompleted: Bool = false
        var timerCompleted: Bool = false
    }
}

struct ContentView: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.modelContext) private var modelContext
    @State private var selectedTab = 0
    
    var body: some View {
        Group {
            if !appState.hasCompletedOnboarding {
                OnboardingView {
                    appState.hasCompletedOnboarding = true
                }
            } else {
                TabView(selection: $selectedTab) {
                    DashboardView(sessionRepository: SessionRepository(modelContext: modelContext))
                        .tabItem {
                            Label("Focus", systemImage: "target")
                        }
                        .tag(0)
                    
                    HistoryView(sessionRepository: SessionRepository(modelContext: modelContext))
                        .tabItem {
                            Label("History", systemImage: "clock")
                        }
                        .tag(1)
                    
                    SettingsView(sessionRepository: SessionRepository(modelContext: modelContext))
                        .tabItem {
                            Label("Settings", systemImage: "gearshape")
                        }
                        .tag(2)
                }
            }
        }
        .onAppear {
            NotificationManager.shared.requestAuthorization()
            checkWeeklyReview()
        }
    }
    
    private func checkWeeklyReview() {
        let calendar = Calendar.current
        let now = Date()
        let weekday = calendar.component(.weekday, from: now)
        let hour = calendar.component(.hour, from: now)
        
        // Check if it's Sunday and after 8 PM
        if weekday == 1 && hour >= 20 {
            let sessionRepository = SessionRepository(modelContext: modelContext)
            let weekStart = now.startOfWeek()
            let weekEnd = weekStart.endOfWeek()
            let weekSessions = sessionRepository.fetchSessions(in: DateInterval(start: weekStart, end: weekEnd))
            
            if weekSessions.count >= 3 {
                // Show weekly review prompt
                // This would typically be handled by a notification or modal
            }
        }
    }
}
