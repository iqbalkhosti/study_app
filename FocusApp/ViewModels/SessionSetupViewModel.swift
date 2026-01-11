import Foundation
import SwiftUI

@MainActor
class SessionSetupViewModel: ObservableObject {
    @Published var taskType: TaskType = .coding
    @Published var goalText: String = ""
    @Published var preCommitment: String = ""
    @Published var whyItMatters: String = ""
    @Published var energyLevel: Int = 3
    @Published var difficulty: Int = 3
    @Published var plannedDuration: Int = 25
    @Published var showWhyItMatters: Bool = false
    
    var canProceed: Bool {
        !goalText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !preCommitment.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        preCommitment.count <= 30
    }
    
    func reset() {
        taskType = .coding
        goalText = ""
        preCommitment = ""
        whyItMatters = ""
        energyLevel = 3
        difficulty = 3
        plannedDuration = 25
        showWhyItMatters = false
    }
}
