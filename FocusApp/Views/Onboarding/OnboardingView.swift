import SwiftUI

struct OnboardingView: View {
    @State private var currentPage = 0
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    let onComplete: () -> Void
    
    var body: some View {
        TabView(selection: $currentPage) {
            OnboardingPage(
                title: "Focus on Outcomes, Not Time",
                description: "30 minutes of deep work beats 3 hours of shallow distraction",
                icon: "clock.badge.checkmark",
                color: .blue
            )
            .tag(0)
            
            OnboardingPage(
                title: "Reflection Creates Learning",
                description: "Every session ends with: What did I learn? What would I do differently?",
                icon: "arrow.triangle.2.circlepath",
                color: .green
            )
            .tag(1)
            
            OnboardingPage(
                title: "Your Depth Score",
                description: "Transparent metrics for difficulty, effort, energy, and completion",
                icon: "chart.bar.fill",
                color: .orange
            )
            .tag(2)
        }
        .tabViewStyle(.page)
        .indexViewStyle(.page(backgroundDisplayMode: .always))
        .overlay(alignment: .bottom) {
            if currentPage == 2 {
                PrimaryButton(title: "Get Started", action: {
                    hasCompletedOnboarding = true
                    onComplete()
                })
                .padding()
            }
        }
    }
}

struct OnboardingPage: View {
    let title: String
    let description: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 32) {
            Spacer()
            
            Image(systemName: icon)
                .font(.system(size: 80))
                .foregroundColor(color)
            
            Text(title)
                .font(.system(size: 32, weight: .bold))
                .multilineTextAlignment(.center)
            
            Text(description)
                .font(.title3)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Spacer()
        }
        .padding()
    }
}
