import SwiftUI

// MARK: - SUBadge

/// A SwiftUI component that displays a badge.
public struct SUBadge: View {
  // MARK: Properties

  /// A model that defines the appearance properties.
  public var model: BadgeVM

  // MARK: Initialization

  /// Initializes a new instance of `SUBadge`.
  /// - Parameter model: A model that defines the appearance properties.
  public init(model: BadgeVM) {
    self.model = model
  }

  // MARK: Body

  public var body: some View {
    Text(self.model.title)
      .font(self.model.preferredFont.font)
      .padding(.vertical, self.model.verticalPadding)
      .padding(.horizontal, self.model.horizontalPadding)
      .foregroundStyle(self.model.foregroundColor.color)
      .background(self.model.backgroundColor?.color ?? .clear)
      .clipShape(
        RoundedRectangle(cornerRadius: self.model.cornerRadius.value())
      )
  }
}
