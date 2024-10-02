import SwiftUI
import SwiftComponents

struct PreviewWrapper<Content: View>: View {
  let title: String
  @ViewBuilder let content: () -> Content

  @Environment(\.colorScheme) private var colorScheme

  var body: some View {
    ZStack(alignment: Alignment(horizontal: .leading, vertical: .top)) {
      self.content()
        .padding(.all)
        .frame(height: 120)
        .frame(maxWidth: .infinity)
        .overlay {
          RoundedRectangle(
            cornerRadius: 25
          )
          .stroke(
            LinearGradient(
              gradient: Gradient(
                colors: [
                  Palette.Brand.blue.color(for: self.colorScheme),
                  Palette.Brand.purple.color(for: self.colorScheme)
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
