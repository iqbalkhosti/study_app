import Foundation
import SwiftData

@MainActor
class ReviewRepository {
    private let modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    func saveReview(_ review: WeeklyReview) {
        modelContext.insert(review)
        try? modelContext.save()
    }
    
    func fetchAllReviews() -> [WeeklyReview] {
        let descriptor = FetchDescriptor<WeeklyReview>(
            sortBy: [SortDescriptor(\.weekStartDate, order: .reverse)]
        )
        return (try? modelContext.fetch(descriptor)) ?? []
    }
    
    func fetchReview(for weekStartDate: Date) -> WeeklyReview? {
        let calendar = Calendar.current
        let weekEndDate = calendar.date(byAdding: .day, value: 7, to: weekStartDate)!
        
        let descriptor = FetchDescriptor<WeeklyReview>(
            predicate: #Predicate<WeeklyReview> { review in
                review.weekStartDate >= weekStartDate && review.weekStartDate < weekEndDate
            }
        )
        return try? modelContext.fetch(descriptor).first
    }
}
