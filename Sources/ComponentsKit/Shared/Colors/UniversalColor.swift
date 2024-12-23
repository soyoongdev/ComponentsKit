import SwiftUI
import UIKit

/// A structure that represents an universal color that can be used in both UIKit and SwiftUI,
/// with light and dark theme variants.
public struct UniversalColor: Hashable {
  // MARK: - ColorRepresentable

  /// An enumeration that defines the possible representations of a color.
  public enum ColorRepresentable: Hashable {
    /// A color defined by its RGBA components.
    ///
    /// - Parameters:
    ///   - r: The red component (0–255).
    ///   - g: The green component (0–255).
    ///   - b: The blue component (0–255).
    ///   - a: The alpha (opacity) component (0.0–1.0).
    case rgba(r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat)

    /// A color represented by a `UIColor` instance.
    case uiColor(UIColor)

    /// A color represented by a SwiftUI `Color` instance.
    case color(Color)

    /// Creates a `ColorRepresentable` instance from a hexadecimal string.
    ///
    /// - Parameter value: A hex string representing the color (e.g., `"#FFFFFF"` or `"FFFFFF"`).
    /// - Returns: A `ColorRepresentable` instance with the corresponding RGBA values.
    /// - Note: This method assumes the input string has exactly six hexadecimal characters.
    /// - Warning: This method will trigger an assertion failure if the input is invalid.
    public static func hex(_ value: String) -> Self {
      let start: String.Index
      if value.hasPrefix("#") {
        start = value.index(value.startIndex, offsetBy: 1)
      } else {
        start = value.startIndex
      }

      let hexColor = String(value[start...])
      let scanner = Scanner(string: hexColor)
      var hexNumber: UInt64 = 0

      if hexColor.count == 6 && scanner.scanHexInt64(&hexNumber) {
        let r = CGFloat((hexNumber & 0x00ff0000) >> 16)
        let g = CGFloat((hexNumber & 0x0000ff00) >> 8)
        let b = CGFloat(hexNumber & 0x000000ff)

        return .rgba(r: r, g: g, b: b, a: 1.0)
      } else {
        assertionFailure(
          "Unable to initialize color from the provided hex value: \(value)"
        )
        return .rgba(r: 0, g: 0, b: 0, a: 1.0)
      }
    }

    /// Returns a new `ColorRepresentable` with the specified opacity.
    ///
    /// - Parameter alpha: The desired opacity (0.0–1.0).
    /// - Returns: A `ColorRepresentable` instance with the adjusted opacity.
    fileprivate func withOpacity(_ alpha: CGFloat) -> Self {
      switch self {
      case .rgba(let r, let g, let b, _):
        return .rgba(r: r, g: g, b: b, a: alpha)
      case .uiColor(let uiColor):
        return .uiColor(uiColor.withAlphaComponent(alpha))
      case .color(let color):
        return .color(color.opacity(alpha))
      }
    }

    /// Converts the `ColorRepresentable` to a `UIColor` instance.
    fileprivate var uiColor: UIColor {
      switch self {
      case .rgba(let red, let green, let blue, let alpha):
        return UIColor(
          red: red / 255,
          green: green / 255,
          blue: blue / 255,
          alpha: alpha
        )
      case .uiColor(let uiColor):
        return uiColor
      case .color(let color):
        return UIColor(color)
      }
    }
  }

  // MARK: - Properties

  /// The color used in light mode.
  let light: ColorRepresentable

  /// The color used in dark mode.
  let dark: ColorRepresentable

  // MARK: - Initialization

  /// Creates a `UniversalColor` with distinct light and dark mode colors.
  ///
  /// - Parameters:
  ///   - light: The color to use in light mode.
  ///   - dark: The color to use in dark mode.
  /// - Returns: A new `UniversalColor` instance.
  public static func themed(
    light: ColorRepresentable,
    dark: ColorRepresentable
  ) -> Self {
    return Self(light: light, dark: dark)
  }

  /// Creates a `UniversalColor` with a single color used for both light and dark modes.
  ///
  /// - Parameter universal: The universal color to use.
  /// - Returns: A new `UniversalColor` instance.
  public static func universal(_ universal: ColorRepresentable) -> Self {
    return Self(light: universal, dark: universal)
  }

  // MARK: - Methods

  /// Returns a new `UniversalColor` with the specified opacity.
  ///
  /// - Parameter alpha: The desired opacity (0.0–1.0).
  /// - Returns: A new `UniversalColor` instance with the adjusted opacity.
  public func withOpacity(_ alpha: CGFloat) -> Self {
    return .init(
      light: self.light.withOpacity(alpha),
      dark: self.dark.withOpacity(alpha)
    )
  }

  /// Returns a disabled version of the color based on a global opacity configuration.
  ///
  /// - Parameter isEnabled: A Boolean value indicating whether the color should be enabled.
  /// - Returns: A new `UniversalColor` instance with reduced opacity if `isEnabled` is `false`.
  public func enabled(_ isEnabled: Bool) -> Self {
    return isEnabled
    ? self
    : self.withOpacity(ComponentsKitConfig.shared.layout.disabledOpacity)
  }

  // MARK: - Colors

  /// Returns the `UIColor` representation of the color.
  public var uiColor: UIColor {
    return UIColor { trait in
      switch trait.userInterfaceStyle {
      case.light:
        return self.light.uiColor
      case .dark:
        return self.dark.uiColor
      default:
        return self.light.uiColor
      }
    }
  }

  /// Returns the `Color` representation of the color.
  public var color: Color {
    return Color(self.uiColor)
  }

  /// Returns the `CGColor` representation of the color.
  public var cgColor: CGColor {
    return self.uiColor.cgColor
  }
}
