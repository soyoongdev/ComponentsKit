import Foundation

/// A model that defines the appearance properties for a divider component.
public struct DividerVM: ComponentVM {
  /// The orientation of the divider (horizontal or vertical).
  ///
  /// Defaults to `.horizontal`.
  public var orientation: DividerOrientation = .horizontal

  /// The color of the divider.
  ///
  /// Defaults to `Palette.Base.divider`.
  public var color: UniversalColor = Palette.Base.divider

  /// The predefined size of the divider, which affects its thickness.
  ///
  /// Defaults to `.medium`.
  public var size: ComponentSize = .medium

  /// Initializes a new instance of `DividerVM` with default values.
  public init() {}
}

// MARK: - Shared Helpers

extension DividerVM {
  var lineSize: CGFloat {
    switch self.size {
    case .small:
      return 0.5
    case .medium:
      return 1.0
    case .large:
      return 2.0
    }
  }

  func shouldUpdateLayout(_ oldModel: Self) -> Bool {
    return self.orientation != oldModel.orientation
    || self.size != oldModel.size
  }
}
