import Foundation
import SwiftUI

@MainActor
class WarmUpViewModel: ObservableObject {
    @Published var firstAction: String = ""
    @Published var timeRemaining: Int = 30
    @Published var canSkip: Bool = false
    
    private var timer: Timer?
    
    func startTimer() {
        canSkip = true
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            if self.timeRemaining > 0 {
                self.timeRemaining -= 1
            } else {
                self.timer?.invalidate()
            }
        }
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    deinit {
        timer?.invalidate()
    }
}
