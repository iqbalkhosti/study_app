import Foundation

struct StreakCalculator {
    static func calculateStreaks(sessions: [FocusSession]) -> Streak {
        guard !sessions.isEmpty else {
            return Streak(
                currentHighDepthStreak: 0,
                bestHighDepthStreak: 0,
                currentCompletionStreak: 0,
                bestCompletionStreak: 0
            )
        }
        
        let sortedByDate = sessions.sorted { $0.startTime < $1.startTime }
        let calendar = Calendar.current
        let grouped = Dictionary(grouping: sortedByDate) { session in
            calendar.startOfDay(for: session.startTime)
        }
        
        let sortedDays = grouped.keys.sorted()
        
        // High-Depth Streak: Days with total depth ≥100
        let (currentHD, bestHD) = calculateStreak(
            sortedDays: sortedDays,
            grouped: grouped,
            condition: { sessions in
                sessions.map(\.depthScore).reduce(0, +) >= 100
            }
        )
        
        // Completion Streak: Days with at least one "Yes"
        let (currentCS, bestCS) = calculateStreak(
            sortedDays: sortedDays,
            grouped: grouped,
            condition: { sessions in
                sessions.contains { $0.completionStatusEnum == .yes }
            }
        )
        
        return Streak(
            currentHighDepthStreak: currentHD,
            bestHighDepthStreak: bestHD,
            currentCompletionStreak: currentCS,
            bestCompletionStreak: bestCS
        )
    }
    
    private static func calculateStreak(
        sortedDays: [Date],
        grouped: [Date: [FocusSession]],
        condition: ([FocusSession]) -> Bool
    ) -> (current: Int, best: Int) {
        var currentStreak = 0
        var bestStreak = 0
        var tempStreak = 0
        
        let today = Calendar.current.startOfDay(for: Date())
        
        for day in sortedDays.reversed() {
            guard let daySessions = grouped[day] else { continue }
            
            if condition(daySessions) {
                tempStreak += 1
                bestStreak = max(bestStreak, tempStreak)
                
                // Check if this is part of current streak (today or consecutive days)
                if day <= today {
                    let daysDiff = Calendar.current.dateComponents([.day], from: day, to: today).day ?? 0
                    if daysDiff == currentStreak {
                        currentStreak += 1
                    } else if daysDiff == 0 {
                        currentStreak = 1
                    } else {
                        currentStreak = 0
                    }
                }
            } else {
                tempStreak = 0
                if day <= today {
                    let daysDiff = Calendar.current.dateComponents([.day], from: day, to: today).day ?? 0
                    if daysDiff > 0 {
                        currentStreak = 0
                    }
                }
            }
        }
        
        return (currentStreak, bestStreak)
    }
}
