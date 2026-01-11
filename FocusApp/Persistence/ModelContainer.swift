import SwiftData
import SwiftUI

@MainActor
class AppModelContainer {
    static let shared: AppModelContainer = AppModelContainer()
    
    let container: ModelContainer
    
    private init() {
        let schema = Schema([
            FocusSession.self,
            WeeklyReview.self
        ])
        
        let modelConfiguration = ModelConfiguration(schema: schema)
        
        do {
            container = try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }
}
