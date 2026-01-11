import SwiftUI

struct TodaySummaryCard: View {
    let stats: (minutes: Int, depthScore: Double, sessionCount: Int, completionRate: Double)
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Today")
                .font(.title2)
                .fontWeight(.bold)
            
            HStack(spacing: 20) {
                StatItem(
                    value: "\(stats.minutes)",
                    label: "Minutes",
                    icon: "clock"
                )
                
                StatItem(
                    value: "\(Int(stats.depthScore))",
                    label: "Depth Score",
                    icon: "chart.bar"
                )
                
                StatItem(
                    value: "\(stats.sessionCount)",
                    label: "Sessions",
                    icon: "square.stack"
                )
                
                StatItem(
                    value: "\(Int(stats.completionRate * 100))%",
                    label: "Complete",
                    icon: "checkmark.circle"
                )
            }
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(16)
    }
}

struct StatItem: View {
    let value: String
    let label: String
    let icon: String
    
    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(.blue)
            
            Text(value)
                .font(.title3)
                .fontWeight(.bold)
            
            Text(label)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
    }
}
