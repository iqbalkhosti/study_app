import Foundation
import UIKit

struct ExportService {
    static func exportToCSV(sessions: [FocusSession]) -> String {
        var csv = "Date,Start Time,End Time,Task Type,Goal,Difficulty,Effort,Energy,Completion,Duration (min),Distractions,Depth Score,Reflection,Iteration Note\n"
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm:ss"
        
        for session in sessions {
            let date = dateFormatter.string(from: session.startTime)
            let startTime = timeFormatter.string(from: session.startTime)
            let endTime = timeFormatter.string(from: session.endTime)
            
            let goal = session.goalText.replacingOccurrences(of: ",", with: ";")
            let reflection = session.reflectionNote.replacingOccurrences(of: ",", with: ";")
            let iteration = session.iterationNote.replacingOccurrences(of: ",", with: ";")
            
            csv += "\(date),\(startTime),\(endTime),\(session.taskTypeEnum.displayName),\(goal),\(session.difficulty),\(session.effort),\(session.energyLevel),\(session.completionStatusEnum.displayName),\(session.actualDurationMinutes),\(session.distractionCount),\(Int(session.depthScore)),\(reflection),\(iteration)\n"
        }
        
        return csv
    }
    
    static func createWeeklySummaryImage(weekStart: Date, sessions: [FocusSession]) -> UIImage? {
        // This would create a visual summary image
        // For MVP, we'll return nil and implement later if needed
        return nil
    }
}
