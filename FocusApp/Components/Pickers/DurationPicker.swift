import SwiftUI

struct DurationPicker: View {
    @Binding var selectedDuration: Int
    let standardDurations = [25, 45, 60, 90]
    @State private var isCustom = false
    @State private var customMinutes = 30
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Duration")
                .font(.headline)
            
            HStack(spacing: 12) {
                ForEach(standardDurations, id: \.self) { duration in
                    Button(action: {
                        selectedDuration = duration
                        isCustom = false
                    }) {
                        Text("\(duration) min")
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(selectedDuration == duration && !isCustom ? Color.blue : Color(.secondarySystemBackground))
                            .foregroundColor(selectedDuration == duration && !isCustom ? .white : .primary)
                            .cornerRadius(8)
                    }
                }
            }
            
            Button(action: {
                isCustom = true
            }) {
                HStack {
                    Text("Custom")
                        .font(.subheadline)
                        .fontWeight(.medium)
                    Spacer()
                    if isCustom {
                        Stepper("", value: $customMinutes, in: 5...180, step: 5)
                            .labelsHidden()
                        Text("\(customMinutes) min")
                            .font(.subheadline)
                    }
                }
                .padding()
                .background(isCustom ? Color.blue.opacity(0.1) : Color(.secondarySystemBackground))
                .cornerRadius(8)
            }
            .onChange(of: customMinutes) { _, newValue in
                if isCustom {
                    selectedDuration = newValue
                }
            }
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(12)
    }
}
