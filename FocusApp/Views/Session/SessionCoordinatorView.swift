import SwiftUI

struct SessionCoordinatorView: View {
    @State private var currentStep: SessionStep = .setup
    @State private var setupData: SessionSetupView.SessionSetupData?
    @State private var firstAction: String?
    @State private var timerStartTime: Date?
    @State private var timerEndTime: Date?
    @State private var actualDuration: Int = 0
    @State private var savedSession: FocusSession?
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    enum SessionStep {
        case setup
        case warmUp
        case timer
        case reflection
        case scoreReveal
    }
    
    var body: some View {
        Group {
            switch currentStep {
            case .setup:
                SessionSetupView { data in
                    setupData = data
                    currentStep = .warmUp
                }
                
            case .warmUp:
                if let setupData = setupData {
                    WarmUpView(goalText: setupData.goalText) { action in
                        firstAction = action
                        timerStartTime = Date()
                        currentStep = .timer
                    }
                }
                
            case .timer:
                if let setupData = setupData {
                    TimerView(durationMinutes: setupData.plannedDuration) {
                        timerEndTime = Date()
                        if let start = timerStartTime, let end = timerEndTime {
                            let durationSeconds = end.timeIntervalSince(start)
                            actualDuration = max(1, Int(durationSeconds / 60))
                        }
                        currentStep = .reflection
                    }
                }
                
            case .reflection:
                if let setupData = setupData,
                   let startTime = timerStartTime,
                   let endTime = timerEndTime {
                    ReflectionView(
                        sessionData: ReflectionView.SessionData(
                            taskType: setupData.taskType,
                            goalText: setupData.goalText,
                            preCommitment: setupData.preCommitment,
                            whyItMatters: setupData.whyItMatters,
                            firstAction: firstAction,
                            energyLevel: setupData.energyLevel,
                            difficulty: setupData.difficulty,
                            plannedDuration: setupData.plannedDuration,
                            actualDuration: actualDuration,
                            startTime: startTime,
                            endTime: endTime
                        )
                    ) { session in
                        savedSession = session
                        saveSession(session)
                        currentStep = .scoreReveal
                    }
                }
                
            case .scoreReveal:
                if let session = savedSession {
                    ScoreRevealView(session: session) {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private func saveSession(_ session: FocusSession) {
        let repository = SessionRepository(modelContext: modelContext)
        repository.saveSession(session)
    }
}
