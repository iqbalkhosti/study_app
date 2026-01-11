import Foundation
import SwiftData

@MainActor
class SessionRepository {
    private let modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    func saveSession(_ session: FocusSession) {
        modelContext.insert(session)
        try? modelContext.save()
    }
    
    func fetchAllSessions() -> [FocusSession] {
        let descriptor = FetchDescriptor<FocusSession>(
            sortBy: [SortDescriptor(\.startTime, order: .reverse)]
        )
        return (try? modelContext.fetch(descriptor)) ?? []
    }
    
    func fetchSessions(in dateRange: DateInterval) -> [FocusSession] {
        let descriptor = FetchDescriptor<FocusSession>(
            predicate: #Predicate<FocusSession> { session in
                session.startTime >= dateRange.start && session.startTime <= dateRange.end
            },
            sortBy: [SortDescriptor(\.startTime, order: .reverse)]
        )
        return (try? modelContext.fetch(descriptor)) ?? []
    }
    
    func fetchSessions(for date: Date) -> [FocusSession] {
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: date)
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!
        
        return fetchSessions(in: DateInterval(start: startOfDay, end: endOfDay))
    }
    
    func fetchSession(by id: UUID) -> FocusSession? {
        let descriptor = FetchDescriptor<FocusSession>(
            predicate: #Predicate<FocusSession> { session in
                session.id == id
            }
        )
        return try? modelContext.fetch(descriptor).first
    }
    
    func deleteSession(_ session: FocusSession) {
        modelContext.delete(session)
        try? modelContext.save()
    }
    
    func deleteSessionsOlderThan(days: Int) {
        let cutoffDate = Calendar.current.date(byAdding: .day, value: -days, to: Date())!
        let descriptor = FetchDescriptor<FocusSession>(
            predicate: #Predicate<FocusSession> { session in
                session.startTime < cutoffDate
            }
        )
        
        if let sessions = try? modelContext.fetch(descriptor) {
            for session in sessions {
                modelContext.delete(session)
            }
            try? modelContext.save()
        }
    }
}
