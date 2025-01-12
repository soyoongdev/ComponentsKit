import SwiftUI

/// A model that defines the appearance properties for a badge component.
public struct BadgeVM: ComponentVM {
  /// The text displayed on the badge.
  public var title: String = ""

  /// The color of the badge.
  public var color: ComponentColor?

  /// The visual style of the badge.
  ///
  /// Can be either `.filled` or `.light`.
  /// Defaults to `.filled`.
  public var style: Style = .filled

  /// The font used for the badge's text.
  ///
  /// Defaults to `.smButton`.
  public var font: UniversalFont? = .smButton

  /// The corner radius of the badge.
  ///
  /// Defaults to `.medium`.
  public var cornerRadius: ComponentRadius = .medium

  /// Vertical padding for the badge.
  ///
  /// Defaults to `8`.
  public var verticalPadding: CGFloat = 8

  /// Horizontal padding for the badge.
  ///
  /// Defaults to `10`.
  public var horizontalPadding: CGFloat = 10

  /// Initializes a new instance of `BadgeVM` with default values.
  public init() {}
}

// MARK: Helpers

extension BadgeVM {
  /// Returns the background color of the badge based on its style.
  var backgroundColor: UniversalColor? {
    switch self.style {
    case .filled:
      let color = self.color?.main ?? .content2
      return color.enabled(true) // Badges are always "enabled"
    case .light:
      let color = self.color?.background ?? .content1
      return color.enabled(true)
    }
  }

  /// Returns the foreground color of the badge based on its style.
  var foregroundColor: UniversalColor {
    switch self.style {
    case .filled:
      return (self.color?.contrast ?? .foreground).enabled(true)
    case .light:
      return (self.color?.main ?? .foreground).enabled(true)
    }
  }

  /// Returns the preferred font for the badge text.
  var preferredFont: UniversalFont {
    if let font {
      return font
    }
    return .smButton
  }
}
