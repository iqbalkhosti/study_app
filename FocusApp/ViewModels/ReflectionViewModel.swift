import Foundation
import SwiftUI

@MainActor
class ReflectionViewModel: ObservableObject {
    @Published var completionStatus: CompletionStatus = .yes
    @Published var effort: Int = 3
    @Published var distractionCount: Int = 0
    @Published var selectedDistractionTypes: Set<DistractionType> = []
    @Published var reflectionNote: String = ""
    @Published var iterationNote: String = ""
    
    var previewScore: (score: Double, breakdown: ScoreBreakdown)? {
        guard !reflectionNote.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
              !iterationNote.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return nil
        }
        
        return DepthScoreCalculator.calculateDepthScore(
            difficulty: difficulty,
            effort: effort,
            energyLevel: energyLevel,
            completion: completionStatus,
            actualMinutes: actualMinutes,
            plannedMinutes: plannedMinutes,
            distractionCount: distractionCount
        )
    }
    
    var canSave: Bool {
        reflectionNote.trimmingCharacters(in: .whitespacesAndNewlines).count >= 50 &&
        iterationNote.trimmingCharacters(in: .whitespacesAndNewlines).count >= 30
    }
    
    // These come from the session setup
    var difficulty: Int = 3
    var energyLevel: Int = 3
    var actualMinutes: Int = 25
    var plannedMinutes: Int = 25
    
    func configure(difficulty: Int, energyLevel: Int, actualMinutes: Int, plannedMinutes: Int) {
        self.difficulty = difficulty
        self.energyLevel = energyLevel
        self.actualMinutes = actualMinutes
        self.plannedMinutes = plannedMinutes
    }
}
