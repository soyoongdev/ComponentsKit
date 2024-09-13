import SwiftUI

struct PreviewWrapper<Content: View>: View {
  let title: String
  @ViewBuilder let content: () -> Content

  var body: some View {
    ZStack(alignment: Alignment(horizontal: .leading, vertical: .top)) {
      self.content()
        .padding(.horizontal)
        .frame(height: 120)
        .frame(maxWidth: .infinity)
        .overlay {
          RoundedRectangle(
            cornerRadius: 25
          )
          .stroke(
            LinearGradient(
              gradient: Gradient(
                colors: [.blue, .red, .green]),
              startPoint: .topLeading,
              endPoint: .bottomTrailing
            ),
            lineWidth: 1
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
