import ComponentsKit
import SwiftUI

struct PreviewWrapper<Content: View>: View {
  let title: String
  @ViewBuilder let content: () -> Content

  var body: some View {
    ZStack(alignment: Alignment(horizontal: .leading, vertical: .top)) {
      self.content()
        .padding(.all)
        .frame(height: 150)
        .frame(maxWidth: .infinity)
        .overlay {
          RoundedRectangle(
            cornerRadius: 25
          )
          .stroke(
            LinearGradient(
              gradient: Gradient(
                colors: [
                  UniversalColor.blue.color,
                  UniversalColor.purple.color,
                ]
              ),
              startPoint: .topLeading,
              endPoint: .bottomTrailing
            ),
            lineWidth: 2
          )
        }
        .padding(.top, 20)

      Text(self.title)
        .padding(.horizontal)
        .background(Color(.systemBackground))
        .font(.system(size: 30, weight: .bold))
        .padding(.leading, 30)
    }
    .padding(.horizontal)
  }
}

// MARK: - Colors

extension UniversalColor {
  fileprivate static let blue: Self = .themed(
    light: .hex("#3684F8"),
    dark: .hex("#0058DB")
  )
  fileprivate static let purple: Self = .themed(
    light: .hex("#A920FD"),
    dark: .hex("#7800C1")
  )
}
