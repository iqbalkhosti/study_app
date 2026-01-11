import SwiftUI

struct WeeklyReviewView: View {
    @StateObject private var viewModel: WeeklyReviewViewModel
    @Environment(\.dismiss) private var dismiss
    
    init(sessionRepository: SessionRepository, reviewRepository: ReviewRepository, weekStartDate: Date) {
        self._viewModel = StateObject(wrappedValue: WeeklyReviewViewModel(
            sessionRepository: sessionRepository,
            reviewRepository: reviewRepository,
            weekStartDate: weekStartDate
        ))
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    headerSection
                    topSessionsSection
                    reflectionSection
                }
                .padding()
            }
            .navigationTitle("Weekly Review")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        viewModel.saveReview()
                        dismiss()
                    }
                    .disabled(!viewModel.canSave)
                }
            }
        }
    }
    
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Week of \(viewModel.weekStartDate, style: .date)")
                .font(.title2)
                .fontWeight(.bold)
            
            Text("Reflect on your top sessions and set intentions for next week")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
    }
    
    private var topSessionsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Top 3 Sessions")
                .font(.headline)
            
            ForEach(viewModel.topSessions, id: \.id) { session in
                HStack {
                    Image(systemName: session.taskTypeEnum.icon)
                        .foregroundColor(.blue)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(session.goalText)
                            .font(.subheadline)
                            .lineLimit(1)
                        Text("\(Int(session.depthScore)) depth score")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                }
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(8)
            }
        }
    }
    
    private var reflectionSection: some View {
        VStack(alignment: .leading, spacing: 24) {
            VStack(alignment: .leading, spacing: 8) {
                Text("What pattern made these sessions successful?")
                    .font(.headline)
                
                TextEditor(text: $viewModel.successPattern)
                    .frame(minHeight: 120)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                    )
                
                Text("\(viewModel.successPattern.count) characters (min: 100)")
                    .font(.caption)
                    .foregroundColor(viewModel.successPattern.count < 100 ? .red : .secondary)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text("What will you optimize next week?")
                    .font(.headline)
                
                TextEditor(text: $viewModel.nextWeekOptimization)
                    .frame(minHeight: 120)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                    )
                
                Text("\(viewModel.nextWeekOptimization.count) characters (min: 100)")
                    .font(.caption)
                    .foregroundColor(viewModel.nextWeekOptimization.count < 100 ? .red : .secondary)
            }
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(12)
    }
}
