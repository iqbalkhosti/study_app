import SwiftUI

struct StepperControl: View {
    let title: String
    @Binding var value: Int
    let range: ClosedRange<Int>
    
    var body: some View {
        HStack {
            Text(title)
                .font(.headline)
            Spacer()
            HStack(spacing: 16) {
                Button(action: {
                    if value > range.lowerBound {
                        value -= 1
                    }
                }) {
                    Image(systemName: "minus.circle.fill")
                        .font(.title2)
                        .foregroundColor(value > range.lowerBound ? .blue : .gray)
                }
                .disabled(value <= range.lowerBound)
                
                Text("\(value)")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .frame(minWidth: 40)
                
                Button(action: {
                    if value < range.upperBound {
                        value += 1
                    }
                }) {
                    Image(systemName: "plus.circle.fill")
                        .font(.title2)
                        .foregroundColor(value < range.upperBound ? .blue : .gray)
                }
                .disabled(value >= range.upperBound)
            }
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(12)
    }
}
