import SwiftUI

struct ScoreRevealView: View {
    let session: FocusSession
    let onDismiss: () -> Void
    
    var body: some View {
        VStack(spacing: 32) {
            Spacer()
            
            VStack(spacing: 16) {
                Text("Depth Score")
                    .font(.title)
                    .foregroundColor(.secondary)
                
                Text("\(Int(session.depthScore))")
                    .font(.system(size: 72, weight: .bold, design: .rounded))
                    .foregroundColor(Color.depthScoreColor(session.depthScore))
            }
            
            if let breakdown = session.scoreBreakdown {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Breakdown")
                        .font(.headline)
                    
                    breakdownRow(label: "Difficulty", value: breakdown.difficulty, max: 5)
                    breakdownRow(label: "Effort", value: breakdown.effort, max: 5)
                    breakdownRow(label: "Energy", value: breakdown.energyLevel, max: 5)
                    breakdownRow(label: "Completion", value: Int(breakdown.completionMultiplier * 5), max: 5)
                    breakdownRow(label: "Time Efficiency", value: Int(breakdown.timeEfficiency * 100), max: 100, suffix: "%")
                    breakdownRow(label: "Distraction Penalty", value: Int((1 - breakdown.distractionPenalty) * 100), max: 40, suffix: "%")
                }
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(16)
                .frame(maxWidth: 300)
            }
            
            Spacer()
            
            VStack(spacing: 12) {
                PrimaryButton(title: "View Dashboard", action: onDismiss)
                
                Button("Start Another Session") {
                    // This will be handled by parent
                    onDismiss()
                }
                .foregroundColor(.blue)
            }
            .padding()
        }
        .padding()
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
