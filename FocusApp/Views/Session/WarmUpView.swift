import SwiftUI

struct WarmUpView: View {
    @StateObject private var viewModel = WarmUpViewModel()
    let goalText: String
    let onComplete: (String?) -> Void
    
    var body: some View {
        VStack(spacing: 32) {
            Spacer()
            
            VStack(spacing: 16) {
                Text("Your Goal")
                    .font(.headline)
                    .foregroundColor(.secondary)
                
                Text(goalText)
                    .font(.title2)
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.center)
                    .padding()
            }
            
            VStack(spacing: 16) {
                Text("What's the first concrete action you'll take?")
                    .font(.headline)
                    .multilineTextAlignment(.center)
                
                TextField("Optional (20 words max)", text: $viewModel.firstAction, axis: .vertical)
                    .textFieldStyle(.roundedBorder)
                    .lineLimit(2...4)
                    .padding(.horizontal)
            }
            
            if viewModel.timeRemaining > 0 {
                Text("\(viewModel.timeRemaining)")
                    .font(.system(size: 48, weight: .bold))
                    .foregroundColor(.blue)
            }
            
            Spacer()
            
            PrimaryButton(title: "Begin Session", action: {
                viewModel.stopTimer()
                let action = viewModel.firstAction.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? nil : viewModel.firstAction
                onComplete(action)
            })
            .padding()
        }
        .onAppear {
            viewModel.startTimer()
        }
        .onDisappear {
            viewModel.stopTimer()
        }
    }
}
