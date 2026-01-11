import SwiftUI

extension Color {
    static func depthScoreColor(_ score: Double) -> Color {
        if score < 50 {
            return .red
        } else if score < 150 {
            return .yellow
        } else {
            return .green
        }
    }
    
    static let appPrimary = Color.blue
    static let appSecondary = Color.gray
    static let appBackground = Color(.systemBackground)
    static let appCardBackground = Color(.secondarySystemBackground)
}
