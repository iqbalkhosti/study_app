import Foundation
import SwiftUI

@MainActor
class HistoryViewModel: ObservableObject {
    @Published var sessions: [FocusSession] = []
    @Published var selectedSession: FocusSession?
    
    private let sessionRepository: SessionRepository
    
    init(sessionRepository: SessionRepository) {
        self.sessionRepository = sessionRepository
        loadSessions()
    }
    
    func loadSessions() {
        sessions = sessionRepository.fetchAllSessions()
    }
    
    var groupedSessions: [(date: Date, sessions: [FocusSession])] {
        let calendar = Calendar.current
        let grouped = Dictionary(grouping: sessions) { session in
            calendar.startOfDay(for: session.startTime)
        }
        
        return grouped.map { (date: $0.key, sessions: $0.value) }
            .sorted { $0.date > $1.date }
    }
}
