import SwiftUI

struct TimerView: View {
    @StateObject private var viewModel: TimerViewModel
    @State private var showEndConfirmation = false
    let onComplete: () -> Void
    
    init(durationMinutes: Int, onComplete: @escaping () -> Void) {
        let timerVM = TimerViewModel(durationMinutes: durationMinutes)
        self._viewModel = StateObject(wrappedValue: timerVM)
        self.onComplete = onComplete
    }
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack {
                if viewModel.isOnBreak {
                    breakView
                } else {
                    timerView
                }
            }
        }
        .alert("End Session Early?", isPresented: $showEndConfirmation) {
            Button("Cancel", role: .cancel) {}
            Button("End Session", role: .destructive) {
                viewModel.stop()
                onComplete()
            }
        } message: {
            Text("Are you sure you want to end this session early?")
        }
        .overlay(alignment: .top) {
            if viewModel.showBreakPrompt {
                breakPromptBanner
            }
        }
    }
    
    private var timerView: some View {
        VStack(spacing: 40) {
            Spacer()
            
            Text(timeString(from: viewModel.timeRemaining))
                .font(.system(size: 72, weight: .bold, design: .rounded))
                .foregroundColor(.white)
                .monospacedDigit()
            
            Spacer()
            
            HStack(spacing: 40) {
                Button(action: {
                    if viewModel.isPaused {
                        viewModel.resume()
                    } else {
                        viewModel.pause()
                    }
                }) {
                    Image(systemName: viewModel.isPaused ? "play.circle.fill" : "pause.circle.fill")
                        .font(.system(size: 44))
                        .foregroundColor(.white)
                }
                
                Button(action: {
                    showEndConfirmation = true
                }) {
                    Image(systemName: "stop.circle.fill")
                        .font(.system(size: 44))
                        .foregroundColor(.red)
                }
            }
            .padding(.bottom, 60)
        }
        .onAppear {
            viewModel.start()
        }
    }
    
    private var breakView: some View {
        VStack(spacing: 20) {
            Text("Break Time")
                .font(.title)
                .foregroundColor(.white)
            
            Text("30 seconds")
                .font(.headline)
                .foregroundColor(.white.opacity(0.7))
        }
    }
    
    private var breakPromptBanner: some View {
        VStack(spacing: 12) {
            Text("Quick 30-second stretch break? (Optional)")
                .font(.headline)
                .foregroundColor(.primary)
            
            HStack(spacing: 16) {
                Button("Continue") {
                    viewModel.continueWithoutBreak()
                }
                .buttonStyle(.bordered)
                
                Button("Take Break") {
                    viewModel.takeBreak()
                }
                .buttonStyle(.borderedProminent)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(radius: 10)
        .padding()
    }
    
    private func timeString(from timeInterval: TimeInterval) -> String {
        let minutes = Int(timeInterval) / 60
        let seconds = Int(timeInterval) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}
