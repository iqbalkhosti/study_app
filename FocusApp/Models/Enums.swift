import Foundation

enum TaskType: String, Codable, CaseIterable {
    case coding
    case problemSolving
    case reading
    case writing
    case memorization
    
    var displayName: String {
        switch self {
        case .coding: return "Coding"
        case .problemSolving: return "Problem-solving"
        case .reading: return "Reading"
        case .writing: return "Writing"
        case .memorization: return "Memorization"
        }
    }
    
    var icon: String {
        switch self {
        case .coding: return "curlybraces"
        case .problemSolving: return "puzzlepiece"
        case .reading: return "book"
        case .writing: return "pencil"
        case .memorization: return "brain"
        }
    }
}

enum CompletionStatus: String, Codable {
    case yes
    case partial
    case no
    
    var displayName: String {
        switch self {
        case .yes: return "Yes"
        case .partial: return "Partial"
        case .no: return "No"
        }
    }
}

enum DistractionType: String, Codable, CaseIterable {
    case phone
    case wanderingThoughts
    case externalInterruptions
    case didntUnderstand
    case other
    
    var displayName: String {
        switch self {
        case .phone: return "Phone/notifications"
        case .wanderingThoughts: return "Wandering thoughts"
        case .externalInterruptions: return "External interruptions"
        case .didntUnderstand: return "Didn't understand material"
        case .other: return "Other"
        }
    }
}
