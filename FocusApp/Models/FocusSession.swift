import Foundation
import SwiftData

@Model
final class FocusSession {
    var id: UUID
    var startTime: Date
    var endTime: Date
    var plannedDurationMinutes: Int
    var actualDurationMinutes: Int
    
    // Setup
    var taskType: String // TaskType as String for SwiftData
    var goalText: String
    var preCommitment: String?
    var whyItMatters: String?
    var firstAction: String?
    var energyLevel: Int // 1-5
    var difficulty: Int // 1-5
    
    // Reflection
    var completionStatus: String // CompletionStatus as String
    var effort: Int // 1-5
    var distractionCount: Int
    var distractionTypes: [String] // [DistractionType] as [String]
    var reflectionNote: String
    var iterationNote: String
    
    // Score
    var depthScore: Double
    var scoreBreakdownData: Data? // ScoreBreakdown as Data
    
    init(
        id: UUID = UUID(),
        startTime: Date,
        endTime: Date,
        plannedDurationMinutes: Int,
        actualDurationMinutes: Int,
        taskType: TaskType,
        goalText: String,
        preCommitment: String? = nil,
        whyItMatters: String? = nil,
        firstAction: String? = nil,
        energyLevel: Int,
        difficulty: Int,
        completionStatus: CompletionStatus,
        effort: Int,
        distractionCount: Int,
        distractionTypes: [DistractionType],
        reflectionNote: String,
        iterationNote: String,
        depthScore: Double,
        scoreBreakdown: ScoreBreakdown
    ) {
        self.id = id
        self.startTime = startTime
        self.endTime = endTime
        self.plannedDurationMinutes = plannedDurationMinutes
        self.actualDurationMinutes = actualDurationMinutes
        self.taskType = taskType.rawValue
        self.goalText = goalText
        self.preCommitment = preCommitment
        self.whyItMatters = whyItMatters
        self.firstAction = firstAction
        self.energyLevel = energyLevel
        self.difficulty = difficulty
        self.completionStatus = completionStatus.rawValue
        self.effort = effort
        self.distractionCount = distractionCount
        self.distractionTypes = distractionTypes.map { $0.rawValue }
        self.reflectionNote = reflectionNote
        self.iterationNote = iterationNote
        self.depthScore = depthScore
        self.scoreBreakdownData = try? JSONEncoder().encode(scoreBreakdown)
    }
    
    // Computed properties for easier access
    var taskTypeEnum: TaskType {
        TaskType(rawValue: taskType) ?? .coding
    }
    
    var completionStatusEnum: CompletionStatus {
        CompletionStatus(rawValue: completionStatus) ?? .no
    }
    
    var distractionTypesEnum: [DistractionType] {
        distractionTypes.compactMap { DistractionType(rawValue: $0) }
    }
    
    var scoreBreakdown: ScoreBreakdown? {
        guard let data = scoreBreakdownData else { return nil }
        return try? JSONDecoder().decode(ScoreBreakdown.self, from: data)
    }
    
    var isHighDepth: Bool {
        depthScore >= 150
    }
}
