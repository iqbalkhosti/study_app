import SwiftUI

struct TaskTypePicker: View {
    @Binding var selectedType: TaskType
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(TaskType.allCases, id: \.self) { type in
                    Button(action: {
                        selectedType = type
                    }) {
                        VStack(spacing: 8) {
                            Image(systemName: type.icon)
                                .font(.system(size: 32))
                            Text(type.displayName)
                                .font(.caption)
                        }
                        .frame(width: 100, height: 100)
                        .background(selectedType == type ? Color.blue : Color(.secondarySystemBackground))
                        .foregroundColor(selectedType == type ? .white : .primary)
                        .cornerRadius(12)
                    }
                }
            }
            .padding(.horizontal)
        }
    }
}
