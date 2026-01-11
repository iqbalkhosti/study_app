import Foundation

struct ScoreBreakdown: Codable {
    var difficulty: Int
    var effort: Int
    var energyLevel: Int
    var completionMultiplier: Double
    var timeEfficiency: Double
    var distractionPenalty: Double
    var finalScore: Double
}
