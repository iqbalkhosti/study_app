import Foundation
import SwiftData

@Model
final class WeeklyReview {
    var id: UUID
    var weekStartDate: Date
    var weekEndDate: Date
    var topSessions: [String] // UUIDs as strings for SwiftData
    var successPattern: String
    var nextWeekOptimization: String
    var totalDepthScore: Double
    var sessionCount: Int
    
    init(
        id: UUID = UUID(),
        weekStartDate: Date,
        weekEndDate: Date,
        topSessions: [UUID],
        successPattern: String,
        nextWeekOptimization: String,
        totalDepthScore: Double,
        sessionCount: Int
    ) {
        self.id = id
        self.weekStartDate = weekStartDate
        self.weekEndDate = weekEndDate
        self.topSessions = topSessions.map { $0.uuidString }
        self.successPattern = successPattern
        self.nextWeekOptimization = nextWeekOptimization
        self.totalDepthScore = totalDepthScore
        self.sessionCount = sessionCount
    }
    
    var topSessionUUIDs: [UUID] {
        topSessions.compactMap { UUID(uuidString: $0) }
    }
}
