import SwiftUI

/// A SwiftUI component that serves as a container for provided content.
///
/// - Example:
/// ```swift
/// SUCard(
///   model: .init(),
///   content: {
///     Text("This is the content of the card.")
///   }
/// )
/// ```
public struct SUCard<Content: View>: View {
  // MARK: - Properties

  /// A model that defines the appearance properties.
  public let model: CardVM

  @ViewBuilder private let content: () -> Content

  // MARK: - Initialization

  /// Initializer.
  ///
  /// - Parameters:
  ///   - model: A model that defines the appearance properties.
  ///   - content: The content that is displayed in the card.
  public init(
    model: CardVM = .init(),
    content: @escaping () -> Content
  ) {
    self.model = model
    self.content = content
  }

  // MARK: - Body

  public var body: some View {
    self.content()
      .padding(self.model.contentPaddings.edgeInsets)
      .background(self.model.preferredBackgroundColor.color)
      .cornerRadius(self.model.cornerRadius.value)
      .overlay(
        RoundedRectangle(cornerRadius: self.model.cornerRadius.value)
          .stroke(UniversalColor.divider.color, lineWidth: self.model.borderWidth.value)
      )
      .shadow(self.model.shadow)
  }
}
