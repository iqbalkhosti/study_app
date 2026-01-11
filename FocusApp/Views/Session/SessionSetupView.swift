import SwiftUI

struct SessionSetupView: View {
    @StateObject private var viewModel = SessionSetupViewModel()
    @State private var currentStep = 1
    @Environment(\.dismiss) private var dismiss
    
    var onComplete: (SessionSetupData) -> Void
    
    struct SessionSetupData {
        let taskType: TaskType
        let goalText: String
        let preCommitment: String
        let whyItMatters: String?
        let energyLevel: Int
        let difficulty: Int
        let plannedDuration: Int
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                if currentStep == 1 {
                    taskAndGoalStep
                } else {
                    sessionConfigStep
                }
            }
            .navigationTitle("New Session")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private var taskAndGoalStep: some View {
        ScrollView {
            VStack(spacing: 24) {
                TaskTypePicker(selectedType: $viewModel.taskType)
                    .padding(.top)
                
                VStack(alignment: .leading, spacing: 12) {
                    Text("What will you accomplish?")
                        .font(.headline)
                    
                    TextField("Enter your micro-goal", text: $viewModel.goalText, axis: .vertical)
                        .textFieldStyle(.roundedBorder)
                        .lineLimit(3...5)
                }
                .padding(.horizontal)
                
                VStack(alignment: .leading, spacing: 12) {
                    Text("What specifically will you accomplish?")
                        .font(.headline)
                    
                    TextField("Pre-commitment (30 words max)", text: $viewModel.preCommitment, axis: .vertical)
                        .textFieldStyle(.roundedBorder)
                        .lineLimit(2...4)
                    
                    Text("\(viewModel.preCommitment.count)/30")
                        .font(.caption)
                        .foregroundColor(viewModel.preCommitment.count > 30 ? .red : .secondary)
                }
                .padding(.horizontal)
                
                VStack(alignment: .leading, spacing: 12) {
                    Button(action: {
                        withAnimation {
                            viewModel.showWhyItMatters.toggle()
                        }
                    }) {
                        HStack {
                            Text("Why does this matter? (Optional)")
                                .font(.headline)
                            Spacer()
                            Image(systemName: viewModel.showWhyItMatters ? "chevron.up" : "chevron.down")
                        }
                    }
                    
                    if viewModel.showWhyItMatters {
                        TextField("Why does completing this goal matter to you?", text: $viewModel.whyItMatters, axis: .vertical)
                            .textFieldStyle(.roundedBorder)
                            .lineLimit(2...4)
                    }
                }
                .padding(.horizontal)
                
                PrimaryButton(title: "Next", action: {
                    withAnimation {
                        currentStep = 2
                    }
                })
                .disabled(!viewModel.canProceed)
                .padding()
            }
        }
    }
    
    private var sessionConfigStep: some View {
        ScrollView {
            VStack(spacing: 24) {
                DurationPicker(selectedDuration: $viewModel.plannedDuration)
                    .padding(.top)
                
                RatingSlider(
                    title: "Difficulty",
                    value: $viewModel.difficulty,
                    labels: ["Easy", "", "", "", "Hard"]
                )
                
                RatingSlider(
                    title: "Energy Level",
                    value: $viewModel.energyLevel,
                    labels: ["Exhausted", "", "", "", "Energized"]
                )
                
                PrimaryButton(title: "Start Session", action: {
                    let data = SessionSetupData(
                        taskType: viewModel.taskType,
                        goalText: viewModel.goalText,
                        preCommitment: viewModel.preCommitment,
                        whyItMatters: viewModel.whyItMatters?.isEmpty == false ? viewModel.whyItMatters : nil,
                        energyLevel: viewModel.energyLevel,
                        difficulty: viewModel.difficulty,
                        plannedDuration: viewModel.plannedDuration
                    )
                    onComplete(data)
                })
                .padding()
            }
        }
    }
}
