import SwiftUI
import Charts

struct WeeklyChartCard: View {
    let data: [(date: Date, score: Double)]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Weekly Depth Score")
                .font(.title2)
                .fontWeight(.bold)
            
            if data.isEmpty {
                Text("No data for this week")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.vertical, 40)
            } else {
                Chart {
                    ForEach(Array(data.enumerated()), id: \.offset) { index, item in
                        BarMark(
                            x: .value("Day", dayLabel(for: item.date)),
                            y: .value("Score", item.score)
                        )
                        .foregroundStyle(Color.blue.gradient)
                    }
                }
                .frame(height: 200)
            }
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(16)
    }
    
    private func dayLabel(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE"
        return formatter.string(from: date)
    }
}
