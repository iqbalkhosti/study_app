import Foundation
import SwiftUI

@MainActor
class DashboardViewModel: ObservableObject {
    @Published var todaySessions: [FocusSession] = []
    @Published var weeklySessions: [FocusSession] = []
    @Published var allSessions: [FocusSession] = []
    @Published var insights: [Insight] = []
    @Published var streak: Streak = Streak(currentHighDepthStreak: 0, bestHighDepthStreak: 0, currentCompletionStreak: 0, bestCompletionStreak: 0)
    
    private let sessionRepository: SessionRepository
    
    init(sessionRepository: SessionRepository) {
        self.sessionRepository = sessionRepository
        loadData()
    }
    
    func loadData() {
        allSessions = sessionRepository.fetchAllSessions()
        todaySessions = sessionRepository.fetchSessions(for: Date())
        
        let calendar = Calendar.current
        let weekStart = Date().startOfWeek()
        let weekEnd = weekStart.endOfWeek()
        weeklySessions = sessionRepository.fetchSessions(in: DateInterval(start: weekStart, end: weekEnd))
        
        insights = InsightsService.generateInsights(from: allSessions)
        streak = StreakCalculator.calculateStreaks(sessions: allSessions)
    }
    
    var todayStats: (minutes: Int, depthScore: Double, sessionCount: Int, completionRate: Double) {
        let minutes = todaySessions.map(\.actualDurationMinutes).reduce(0, +)
        let depthScore = todaySessions.map(\.depthScore).reduce(0, +)
        let sessionCount = todaySessions.count
        let completed = todaySessions.filter { $0.completionStatusEnum == .yes }.count
        let completionRate = sessionCount > 0 ? Double(completed) / Double(sessionCount) : 0.0
        
        return (minutes, depthScore, sessionCount, completionRate)
    }
    
    var weeklyDepthData: [(date: Date, score: Double)] {
        let calendar = Calendar.current
        var data: [(Date, Double)] = []
        
        for i in 0..<7 {
            if let date = calendar.date(byAdding: .day, value: -i, to: Date()) {
                let daySessions = sessionRepository.fetchSessions(for: date)
                let totalScore = daySessions.map(\.depthScore).reduce(0, +)
                data.append((date, totalScore))
            }
        }
        
        return data.reversed()
    }
}
