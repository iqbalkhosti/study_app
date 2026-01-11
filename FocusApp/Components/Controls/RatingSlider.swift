import SwiftUI

struct RatingSlider: View {
    let title: String
    @Binding var value: Int
    let range: ClosedRange<Int>
    let labels: [String]?
    
    init(title: String, value: Binding<Int>, range: ClosedRange<Int> = 1...5, labels: [String]? = nil) {
        self.title = title
        self._value = value
        self.range = range
        self.labels = labels
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(title)
                    .font(.headline)
                Spacer()
                Text("\(value)")
                    .font(.headline)
                    .foregroundColor(.blue)
            }
            
            Slider(value: Binding(
                get: { Double(value) },
                set: { value = Int($0) }
            ), in: Double(range.lowerBound)...Double(range.upperBound), step: 1)
            
            if let labels = labels, labels.count == range.count {
                HStack {
                    ForEach(Array(range.enumerated()), id: \.element) { index, _ in
                        Text(labels[index])
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .frame(maxWidth: .infinity)
                    }
                }
            }
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(12)
    }
}
