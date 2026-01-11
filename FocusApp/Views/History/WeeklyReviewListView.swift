import SwiftUI

struct WeeklyReviewListView: View {
    @State private var reviews: [WeeklyReview] = []
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        List {
            ForEach(reviews, id: \.id) { review in
                NavigationLink {
                    WeeklyReviewDetailView(review: review)
                } label: {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Week of \(review.weekStartDate, style: .date)")
                            .font(.headline)
                        Text("\(review.sessionCount) sessions • \(Int(review.totalDepthScore)) depth score")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
        .navigationTitle("Weekly Reviews")
        .onAppear {
            loadReviews()
        }
    }
    
    private func loadReviews() {
        let repository = ReviewRepository(modelContext: modelContext)
        reviews = repository.fetchAllReviews()
    }
}

struct WeeklyReviewDetailView: View {
    let review: WeeklyReview
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Week of \(review.weekStartDate, style: .date)")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text("\(review.sessionCount) sessions • \(Int(review.totalDepthScore)) total depth score")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                VStack(alignment: .leading, spacing: 12) {
                    Text("Success Pattern")
                        .font(.headline)
                    Text(review.successPattern)
                        .font(.body)
                }
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(12)
                
                VStack(alignment: .leading, spacing: 12) {
                    Text("Next Week Optimization")
                        .font(.headline)
                    Text(review.nextWeekOptimization)
                        .font(.body)
                }
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(12)
            }
            .padding()
        }
        .navigationTitle("Review")
        .navigationBarTitleDisplayMode(.inline)
    }
}
