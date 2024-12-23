import SwiftUI

public struct SUCard<Content: View>: View {
  let model: CardVM

  @ViewBuilder private let content: () -> Content

  public init(model: CardVM, content: @escaping () -> Content) {
    self.model = model
    self.content = content
  }

  public var body: some View {
    self.content()
      .padding(self.model.contentPaddings.edgeInsets)
      .background(self.model.preferredBackgroundColor.color)
      .background(UniversalColor.background.color)
      .cornerRadius(self.model.cornerRadius.value)
      .overlay(
        RoundedRectangle(cornerRadius: self.model.cornerRadius.value)
          .stroke(UniversalColor.divider.color, lineWidth: 1.0)
      )
      .shadow(self.model.shadow)
  }
}

extension View {
  func shadow(_ shadow: Shadow) -> some View {
    self.shadow(
      color: shadow.color.color,
      radius: shadow.radius,
      x: shadow.offset.width,
      y: shadow.offset.height
    )
  }
}
