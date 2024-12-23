import Foundation

public struct CardVM: ComponentVM {
  /// The padding applied to the card's content area.
  ///
  /// Defaults to a padding value of `16` for all sides.
  public var contentPaddings: Paddings = .init(padding: 16)

  /// The corner radius of the card.
  ///
  /// Defaults to `.medium`.
  public var cornerRadius: ContainerRadius = .medium

  public init() {}
}
