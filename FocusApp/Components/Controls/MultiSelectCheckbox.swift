import SwiftUI

struct MultiSelectCheckbox: View {
    let title: String
    @Binding var selectedItems: Set<DistractionType>
    let options: [DistractionType]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.headline)
            
            ForEach(options, id: \.self) { option in
                Button(action: {
                    if selectedItems.contains(option) {
                        selectedItems.remove(option)
                    } else {
                        selectedItems.insert(option)
                    }
                }) {
                    HStack {
                        Image(systemName: selectedItems.contains(option) ? "checkmark.square.fill" : "square")
                            .foregroundColor(selectedItems.contains(option) ? .blue : .gray)
                        Text(option.displayName)
                            .foregroundColor(.primary)
                        Spacer()
                    }
                    .padding(.vertical, 8)
                }
            }
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(12)
    }
}
