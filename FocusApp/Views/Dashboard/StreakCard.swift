import SwiftUI

struct StreakCard: View {
    let streak: Streak
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Streaks")
                .font(.title2)
                .fontWeight(.bold)
            
            if streak.currentHighDepthStreak > 0 {
                StreakRow(
                    title: "High-Depth Streak",
                    current: streak.currentHighDepthStreak,
                    best: streak.bestHighDepthStreak,
                    icon: "flame.fill",
                    color: .orange
                )
            }
            
            if streak.currentCompletionStreak > 0 {
                StreakRow(
                    title: "Completion Streak",
                    current: streak.currentCompletionStreak,
                    best: streak.bestCompletionStreak,
                    icon: "checkmark.circle.fill",
                    color: .green
                )
            }
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(16)
    }
}

struct StreakRow: View {
    let title: String
    let current: Int
    let best: Int
    let icon: String
    let color: Color
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(color)
                .font(.title3)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                
                HStack(spacing: 12) {
                    Text("Current: \(current)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    Text("Best: \(best)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
        }
    }
}
