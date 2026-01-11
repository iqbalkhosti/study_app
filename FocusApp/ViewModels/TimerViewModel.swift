import Foundation
import SwiftUI

@MainActor
class TimerViewModel: ObservableObject {
    @Published var timeRemaining: TimeInterval
    @Published var isRunning: Bool = false
    @Published var isPaused: Bool = false
    @Published var showBreakPrompt: Bool = false
    @Published var isOnBreak: Bool = false
    
    private var timer: Timer?
    private let totalDuration: TimeInterval
    private let breakThreshold: TimeInterval = 25 * 60 // 25 minutes
    private var breakStartTime: Date?
    
    let startTime: Date
    
    init(durationMinutes: Int) {
        self.totalDuration = TimeInterval(durationMinutes * 60)
        self.timeRemaining = self.totalDuration
        self.startTime = Date()
    }
    
    func start() {
        isRunning = true
        isPaused = false
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            
            if self.isOnBreak {
                // Handle break countdown
                if let breakStart = self.breakStartTime {
                    let breakElapsed = Date().timeIntervalSince(breakStart)
                    if breakElapsed >= 30 {
                        self.endBreak()
                    }
                }
            } else {
                // Normal timer countdown
                if self.timeRemaining > 0 {
                    self.timeRemaining -= 1
                    
                    // Check for break prompt (only for sessions >45min, at 25min mark)
                    if self.totalDuration > 45 * 60 && 
                       self.timeRemaining <= (self.totalDuration - self.breakThreshold) &&
                       !self.showBreakPrompt {
                        self.showBreakPrompt = true
                    }
                } else {
                    self.stop()
                }
            }
        }
    }
    
    func pause() {
        isPaused = true
        isRunning = false
        timer?.invalidate()
    }
    
    func resume() {
        isRunning = true
        isPaused = false
        start()
    }
    
    func takeBreak() {
        showBreakPrompt = false
        isOnBreak = true
        breakStartTime = Date()
    }
    
    func continueWithoutBreak() {
        showBreakPrompt = false
    }
    
    private func endBreak() {
        isOnBreak = false
        breakStartTime = nil
    }
    
    func stop() {
        isRunning = false
        isPaused = false
        timer?.invalidate()
        timer = nil
    }
    
    var elapsedTime: TimeInterval {
        Date().timeIntervalSince(startTime)
    }
    
    var actualDurationMinutes: Int {
        max(1, Int(elapsedTime / 60))
    }
    
    deinit {
        timer?.invalidate()
    }
}
