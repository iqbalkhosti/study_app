import Foundation
import SwiftUI

@MainActor
class SettingsViewModel: ObservableObject {
    @Published var notificationsEnabled: Bool = true
    
    private let sessionRepository: SessionRepository
    
    init(sessionRepository: SessionRepository) {
        self.sessionRepository = sessionRepository
    }
    
    func exportCSV() -> String {
        let sessions = sessionRepository.fetchAllSessions()
        return ExportService.exportToCSV(sessions: sessions)
    }
    
    func resetAllData(modelContext: ModelContext) {
        let sessions = sessionRepository.fetchAllSessions()
        for session in sessions {
            modelContext.delete(session)
        }
        try? modelContext.save()
    }
}
