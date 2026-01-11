import SwiftUI

struct ReflectionView: View {
    @StateObject private var viewModel: ReflectionViewModel
    let sessionData: SessionData
    let onSave: (FocusSession) -> Void
    
    struct SessionData {
        let taskType: TaskType
        let goalText: String
        let preCommitment: String
        let whyItMatters: String?
        let firstAction: String?
        let energyLevel: Int
        let difficulty: Int
        let plannedDuration: Int
        let actualDuration: Int
        let startTime: Date
        let endTime: Date
    }
    
    init(sessionData: SessionData, onSave: @escaping (FocusSession) -> Void) {
        self.sessionData = sessionData
        self.onSave = onSave
        self._viewModel = StateObject(wrappedValue: ReflectionViewModel())
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    outcomeSection
                    distractionSection
                    learningSection
                    scorePreview
                }
                .padding()
            }
            .navigationTitle("Reflection")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveSession()
                    }
                    .disabled(!viewModel.canSave)
                }
            }
        }
        .onAppear {
            viewModel.configure(
                difficulty: sessionData.difficulty,
                energyLevel: sessionData.energyLevel,
                actualMinutes: sessionData.actualDuration,
                plannedMinutes: sessionData.plannedDuration
            )
        }
    }
    
    private var outcomeSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Outcome")
                .font(.title2)
                .fontWeight(.bold)
            
            VStack(alignment: .leading, spacing: 12) {
                Text("Did you complete your goal?")
                    .font(.headline)
                
                Picker("Completion", selection: $viewModel.completionStatus) {
                    ForEach([CompletionStatus.yes, .partial, .no], id: \.self) { status in
                        Text(status.displayName).tag(status)
                    }
                }
                .pickerStyle(.segmented)
            }
            
            RatingSlider(
                title: "How hard did you push yourself?",
                value: $viewModel.effort,
                labels: ["Minimal", "", "", "", "Maximum"]
            )
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(12)
    }
    
    private var distractionSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Distractions")
                .font(.title2)
                .fontWeight(.bold)
            
            StepperControl(
                title: "Distraction count",
                value: $viewModel.distractionCount,
                range: 0...10
            )
            
            if viewModel.distractionCount > 0 {
                MultiSelectCheckbox(
                    title: "What distracted you?",
                    selectedItems: $viewModel.selectedDistractionTypes,
                    options: DistractionType.allCases
                )
            }
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(12)
    }
    
    private var learningSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Learning")
                .font(.title2)
                .fontWeight(.bold)
            
            VStack(alignment: .leading, spacing: 8) {
                Text("What did you accomplish or learn?")
                    .font(.headline)
                
                TextEditor(text: $viewModel.reflectionNote)
                    .frame(minHeight: 100)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                    )
                
                Text("\(viewModel.reflectionNote.count) characters (min: 50)")
                    .font(.caption)
                    .foregroundColor(viewModel.reflectionNote.count < 50 ? .red : .secondary)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text("If you did this session again, what would you change?")
                    .font(.headline)
                
                TextEditor(text: $viewModel.iterationNote)
                    .frame(minHeight: 80)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                    )
                
                Text("\(viewModel.iterationNote.count) characters (min: 30)")
                    .font(.caption)
                    .foregroundColor(viewModel.iterationNote.count < 30 ? .red : .secondary)
            }
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(12)
    }
    
    private var scorePreview: some View {
        Group {
            if let preview = viewModel.previewScore {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Depth Score Preview")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text("\(Int(preview.score))")
                        .font(.system(size: 48, weight: .bold))
                        .foregroundColor(Color.depthScoreColor(preview.score))
                    
                    scoreBreakdownView(breakdown: preview.breakdown)
                }
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(12)
            }
        }
    }
    
    private func scoreBreakdownView(breakdown: ScoreBreakdown) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            breakdownRow(label: "Difficulty", value: breakdown.difficulty, max: 5)
            breakdownRow(label: "Effort", value: breakdown.effort, max: 5)
            breakdownRow(label: "Energy", value: breakdown.energyLevel, max: 5)
            breakdownRow(label: "Completion", value: Int(breakdown.completionMultiplier * 5), max: 5)
            breakdownRow(label: "Time Efficiency", value: Int(breakdown.timeEfficiency * 100), max: 100, suffix: "%")
            breakdownRow(label: "Distraction Penalty", value: Int((1 - breakdown.distractionPenalty) * 100), max: 40, suffix: "%")
        }
    }
    
    private func breakdownRow(label: String, value: Int, max: Int, suffix: String = "") -> some View {
        HStack {
            Text(label)
                .font(.subheadline)
            Spacer()
            Text("\(value)\(suffix)")
                .font(.subheadline)
                .fontWeight(.medium)
        }
    }
    
    private func saveSession() {
        let (score, breakdown) = DepthScoreCalculator.calculateDepthScore(
            difficulty: sessionData.difficulty,
            effort: viewModel.effort,
            energyLevel: sessionData.energyLevel,
            completion: viewModel.completionStatus,
            actualMinutes: sessionData.actualDuration,
            plannedMinutes: sessionData.plannedDuration,
            distractionCount: viewModel.distractionCount
        )
        
        let session = FocusSession(
            startTime: sessionData.startTime,
            endTime: sessionData.endTime,
            plannedDurationMinutes: sessionData.plannedDuration,
            actualDurationMinutes: sessionData.actualDuration,
            taskType: sessionData.taskType,
            goalText: sessionData.goalText,
            preCommitment: sessionData.preCommitment,
            whyItMatters: sessionData.whyItMatters,
            firstAction: sessionData.firstAction,
            energyLevel: sessionData.energyLevel,
            difficulty: sessionData.difficulty,
            completionStatus: viewModel.completionStatus,
            effort: viewModel.effort,
            distractionCount: viewModel.distractionCount,
            distractionTypes: Array(viewModel.selectedDistractionTypes),
            reflectionNote: viewModel.reflectionNote,
            iterationNote: viewModel.iterationNote,
            depthScore: score,
            scoreBreakdown: breakdown
        )
        
        onSave(session)
    }
}
