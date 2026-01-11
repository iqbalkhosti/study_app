import Foundation
import SwiftUI

@MainActor
class WeeklyReviewViewModel: ObservableObject {
    @Published var successPattern: String = ""
    @Published var nextWeekOptimization: String = ""
    @Published var topSessions: [FocusSession] = []
    
    private let sessionRepository: SessionRepository
    private let reviewRepository: ReviewRepository
    private let weekStartDate: Date
    
    init(sessionRepository: SessionRepository, reviewRepository: ReviewRepository, weekStartDate: Date) {
        self.sessionRepository = sessionRepository
        self.reviewRepository = reviewRepository
        self.weekStartDate = weekStartDate
        loadTopSessions()
    }
    
    private func loadTopSessions() {
        let weekEnd = weekStartDate.endOfWeek()
        let weekSessions = sessionRepository.fetchSessions(in: DateInterval(start: weekStartDate, end: weekEnd))
        topSessions = Array(weekSessions.sorted { $0.depthScore > $1.depthScore }.prefix(3))
    }
    
    var canSave: Bool {
        successPattern.trimmingCharacters(in: .whitespacesAndNewlines).count >= 100 &&
        nextWeekOptimization.trimmingCharacters(in: .whitespacesAndNewlines).count >= 100
    }
    
    func saveReview() {
        let weekEnd = weekStartDate.endOfWeek()
        let weekSessions = sessionRepository.fetchSessions(in: DateInterval(start: weekStartDate, end: weekEnd))
        let totalDepth = weekSessions.map(\.depthScore).reduce(0, +)
        
        let review = WeeklyReview(
            weekStartDate: weekStartDate,
            weekEndDate: weekEnd,
            topSessions: topSessions.map(\.id),
            successPattern: successPattern,
            nextWeekOptimization: nextWeekOptimization,
            totalDepthScore: totalDepth,
            sessionCount: weekSessions.count
        )
        
        reviewRepository.saveReview(review)
    }
}
