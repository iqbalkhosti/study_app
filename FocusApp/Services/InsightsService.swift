import Foundation

struct Insight {
    let title: String
    let description: String
    let type: InsightType
}

enum InsightType {
    case bestTimeOfDay
    case energyImpact
    case distractionPatterns
    case taskTypePerformance
}

struct InsightsService {
    static func generateInsights(from sessions: [FocusSession]) -> [Insight] {
        var insights: [Insight] = []
        
        // Best Time of Day
        if let timeInsight = bestTimeOfDayInsight(sessions: sessions) {
            insights.append(timeInsight)
        }
        
        // Energy Impact
        if let energyInsight = energyImpactInsight(sessions: sessions) {
            insights.append(energyInsight)
        }
        
        // Distraction Patterns
        if let distractionInsight = distractionPatternInsight(sessions: sessions) {
            insights.append(distractionInsight)
        }
        
        // Task Type Performance
        if let taskInsight = taskTypePerformanceInsight(sessions: sessions) {
            insights.append(taskInsight)
        }
        
        // Return max 2 insights, prioritizing actionable ones
        return Array(insights.prefix(2))
    }
    
    private static func bestTimeOfDayInsight(sessions: [FocusSession]) -> Insight? {
        guard sessions.count >= 10 else { return nil }
        
        let calendar = Calendar.current
        var timeBuckets: [Int: [FocusSession]] = [:]
        
        for session in sessions {
            let hour = calendar.component(.hour, from: session.startTime)
            let bucket = hour / 2 // 2-hour buckets
            timeBuckets[bucket, default: []].append(session)
        }
        
        var bestBucket: Int?
        var bestAverage: Double = 0
        var bestCount = 0
        
        for (bucket, bucketSessions) in timeBuckets {
            guard bucketSessions.count >= 3 else { continue }
            let average = bucketSessions.map(\.depthScore).reduce(0, +) / Double(bucketSessions.count)
            if average > bestAverage {
                bestAverage = average
                bestBucket = bucket
                bestCount = bucketSessions.count
            }
        }
        
        guard let bucket = bestBucket else { return nil }
        
        let startHour = bucket * 2
        let endHour = startHour + 2
        let timeRange = "\(startHour):00-\(endHour):00"
        
        return Insight(
            title: "Best Time of Day",
            description: "You achieve highest depth between \(timeRange) (avg: \(Int(bestAverage)))",
            type: .bestTimeOfDay
        )
    }
    
    private static func energyImpactInsight(sessions: [FocusSession]) -> Insight? {
        guard sessions.count >= 8 else { return nil }
        
        let highEnergy = sessions.filter { $0.energyLevel >= 4 }
        let lowEnergy = sessions.filter { $0.energyLevel < 4 }
        
        guard !highEnergy.isEmpty && !lowEnergy.isEmpty else { return nil }
        
        let highAvg = highEnergy.map(\.depthScore).reduce(0, +) / Double(highEnergy.count)
        let lowAvg = lowEnergy.map(\.depthScore).reduce(0, +) / Double(lowEnergy.count)
        
        guard highAvg > 0 && lowAvg > 0 else { return nil }
        
        let percentIncrease = ((highAvg - lowAvg) / lowAvg) * 100
        
        guard percentIncrease >= 20 else { return nil }
        
        return Insight(
            title: "Energy Impact",
            description: "Starting with energy ≥4 increases your Depth Score by \(Int(percentIncrease))%",
            type: .energyImpact
        )
    }
    
    private static func distractionPatternInsight(sessions: [FocusSession]) -> Insight? {
        let sessionsWithDistractions = sessions.filter { $0.distractionCount > 0 }
        guard sessionsWithDistractions.count >= 5 else { return nil }
        
        var distractionCounts: [DistractionType: Int] = [:]
        
        for session in sessionsWithDistractions {
            for type in session.distractionTypesEnum {
                distractionCounts[type, default: 0] += 1
            }
        }
        
        let totalDistractions = distractionCounts.values.reduce(0, +)
        guard totalDistractions > 0 else { return nil }
        
        let topDistraction = distractionCounts.max { $0.value < $1.value }
        guard let top = topDistraction else { return nil }
        
        let percentage = (Double(top.value) / Double(totalDistractions)) * 100
        guard percentage >= 40 else { return nil }
        
        return Insight(
            title: "Distraction Patterns",
            description: "\(top.key.displayName) cause \(Int(percentage))% of your distractions",
            type: .distractionPatterns
        )
    }
    
    private static func taskTypePerformanceInsight(sessions: [FocusSession]) -> Insight? {
        var typeSessions: [TaskType: [FocusSession]] = [:]
        
        for session in sessions {
            let type = session.taskTypeEnum
            typeSessions[type, default: []].append(session)
        }
        
        var bestType: TaskType?
        var bestAverage: Double = 0
        
        for (type, typeSessions) in typeSessions {
            guard typeSessions.count >= 3 else { continue }
            let average = typeSessions.map(\.depthScore).reduce(0, +) / Double(typeSessions.count)
            if average > bestAverage {
                bestAverage = average
                bestType = type
            }
        }
        
        guard let type = bestType else { return nil }
        
        return Insight(
            title: "Task Type Performance",
            description: "Your strongest task type: \(type.displayName) (avg: \(Int(bestAverage)))",
            type: .taskTypePerformance
        )
    }
}
