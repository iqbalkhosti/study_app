import SwiftUI

struct SessionCard: View {
    let session: FocusSession
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: session.taskTypeEnum.icon)
                .font(.title2)
                .foregroundColor(.blue)
                .frame(width: 40)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(session.goalText)
                    .font(.headline)
                    .lineLimit(1)
                
                HStack {
                    Text("\(session.actualDurationMinutes) min")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Text("•")
                        .foregroundColor(.secondary)
                    
                    Text(session.startTime, style: .time)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
            
            VStack(alignment: .trailing) {
                Text("\(Int(session.depthScore))")
                    .font(.headline)
                    .foregroundColor(Color.depthScoreColor(session.depthScore))
                
                Text("Depth")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(12)
    }
}
