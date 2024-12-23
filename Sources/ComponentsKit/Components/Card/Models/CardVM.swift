import Foundation

/// A model that defines the appearance properties for a card component.
public struct CardVM: ComponentVM {
  /// The background color of the card.
  public var backgroundColor: UniversalColor?

  /// The padding applied to the card's content area.
  ///
  /// Defaults to a padding value of `16` for all sides.
  public var contentPaddings: Paddings = .init(padding: 16)

  /// The corner radius of the card.
  ///
  /// Defaults to `.medium`.
  public var cornerRadius: ContainerRadius = .medium

  /// The shadow of the card.
  ///
  /// Defaults to `.medium`.
  public var shadow: Shadow = .medium

  /// Initializes a new instance of `CardVM` with default values.
  public init() {}
}

// MARK: - Helpers

extension CardVM {
  var preferredBackgroundColor: UniversalColor {
    return self.backgroundColor ?? .background
  }
}
