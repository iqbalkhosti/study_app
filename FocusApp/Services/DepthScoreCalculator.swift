import Foundation

struct DepthScoreCalculator {
    static func calculateDepthScore(
        difficulty: Int,
        effort: Int,
        energyLevel: Int,
        completion: CompletionStatus,
        actualMinutes: Int,
        plannedMinutes: Int,
        distractionCount: Int
    ) -> (score: Double, breakdown: ScoreBreakdown) {
        
        // Completion multiplier
        let C: Double = switch completion {
        case .yes: 1.0
        case .partial: 0.6
        case .no: 0.2
        }
        
        // Time efficiency (special handling for micro-sessions)
        let T: Double
        if actualMinutes < 15 {
            T = min(Double(actualMinutes) / 15.0, 1.0)
        } else {
            T = min(Double(actualMinutes) / Double(plannedMinutes), 1.0)
        }
        
        // Distraction penalty (max 40% penalty)
        let P = max(1.0 - (Double(distractionCount) * 0.05), 0.6)
        
        // Energy multiplier (normalized to 0.2-1.0 scale)
        let EN = Double(energyLevel) / 5.0
        
        // Final score
        let rawScore = 10.0 * Double(difficulty) * Double(effort) * EN * C * T * P
        let finalScore = min(max(rawScore, 0), 300)
        
        let breakdown = ScoreBreakdown(
            difficulty: difficulty,
            effort: effort,
            energyLevel: energyLevel,
            completionMultiplier: C,
            timeEfficiency: T,
            distractionPenalty: P,
            finalScore: finalScore
        )
        
        return (finalScore, breakdown)
    }
}
