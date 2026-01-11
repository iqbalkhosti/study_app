import SwiftUI

struct SessionDetailView: View {
    let session: FocusSession
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    headerSection
                    setupSection
                    reflectionSection
                    scoreBreakdownSection
                }
                .padding()
            }
            .navigationTitle("Session Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: session.taskTypeEnum.icon)
                    .font(.title)
                    .foregroundColor(.blue)
                
                VStack(alignment: .leading) {
                    Text(session.taskTypeEnum.displayName)
                        .font(.headline)
                    Text(session.startTime, style: .date)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                VStack(alignment: .trailing) {
                    Text("\(Int(session.depthScore))")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(Color.depthScoreColor(session.depthScore))
                    Text("Depth Score")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            Text(session.goalText)
                .font(.title3)
                .fontWeight(.medium)
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(12)
    }
    
    private var setupSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Setup")
                .font(.title2)
                .fontWeight(.bold)
            
            DetailRow(label: "Duration", value: "\(session.actualDurationMinutes) min")
            DetailRow(label: "Difficulty", value: "\(session.difficulty)/5")
            DetailRow(label: "Energy Level", value: "\(session.energyLevel)/5")
            
            if let preCommitment = session.preCommitment {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Pre-commitment")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Text(preCommitment)
                        .font(.body)
                }
            }
            
            if let whyItMatters = session.whyItMatters {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Why this mattered")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Text(whyItMatters)
                        .font(.body)
                }
            }
            
            if let firstAction = session.firstAction {
                VStack(alignment: .leading, spacing: 4) {
                    Text("First action")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Text(firstAction)
                        .font(.body)
                }
            }
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(12)
    }
    
    private var reflectionSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Reflection")
                .font(.title2)
                .fontWeight(.bold)
            
            DetailRow(label: "Completion", value: session.completionStatusEnum.displayName)
            DetailRow(label: "Effort", value: "\(session.effort)/5")
            DetailRow(label: "Distractions", value: "\(session.distractionCount)")
            
            if !session.distractionTypesEnum.isEmpty {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Distraction types")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    ForEach(session.distractionTypesEnum, id: \.self) { type in
                        Text("• \(type.displayName)")
                            .font(.body)
                    }
                }
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text("What did you accomplish or learn?")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Text(session.reflectionNote)
                    .font(.body)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text("What would you change?")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Text(session.iterationNote)
                    .font(.body)
            }
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(12)
    }
    
    @State private var showBreakdown = false
    
    private var scoreBreakdownSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Button(action: {
                withAnimation {
                    showBreakdown.toggle()
                }
            }) {
                HStack {
                    Text("Score Breakdown")
                        .font(.title2)
                        .fontWeight(.bold)
                    Spacer()
                    Image(systemName: showBreakdown ? "chevron.up" : "chevron.down")
                }
            }
            
            if showBreakdown, let breakdown = session.scoreBreakdown {
                VStack(alignment: .leading, spacing: 8) {
                    breakdownRow(label: "Difficulty", value: breakdown.difficulty, max: 5)
                    breakdownRow(label: "Effort", value: breakdown.effort, max: 5)
                    breakdownRow(label: "Energy", value: breakdown.energyLevel, max: 5)
                    breakdownRow(label: "Completion", value: Int(breakdown.completionMultiplier * 5), max: 5)
                    breakdownRow(label: "Time Efficiency", value: Int(breakdown.timeEfficiency * 100), max: 100, suffix: "%")
                    breakdownRow(label: "Distraction Penalty", value: Int((1 - breakdown.distractionPenalty) * 100), max: 40, suffix: "%")
                    
                    Divider()
                    
                    HStack {
                        Text("Final Score")
                            .font(.headline)
                        Spacer()
                        Text("\(Int(breakdown.finalScore))")
                            .font(.headline)
                            .fontWeight(.bold)
                    }
                }
                .padding(.top)
            }
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(12)
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
}

struct DetailRow: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Text(label)
                .font(.subheadline)
                .foregroundColor(.secondary)
            Spacer()
            Text(value)
                .font(.subheadline)
                .fontWeight(.medium)
        }
    }
}
