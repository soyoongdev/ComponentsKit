import Foundation

public struct CardVM: ComponentVM {
  /// The background color of the card's content area.
  public var backgroundColor: UniversalColor?

  /// The padding applied to the card's content area.
  ///
  /// Defaults to a padding value of `16` for all sides.
  public var contentPaddings: Paddings = .init(padding: 16)

  /// The corner radius of the card.
  ///
  /// Defaults to `.medium`.
  public var cornerRadius: ContainerRadius = .medium

  public var shadow: Shadow = .medium

  public init() {}
}

// MARK: - Helpers

extension CardVM {
  var preferredBackgroundColor: UniversalColor {
    return self.backgroundColor ?? .background
  }
}
