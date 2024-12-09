import SwiftUI

/// Defines the possible positions for units in the countdown.
public enum UnitsPosition {
  case none
  case bottom
  case trailing
}

/// A model that defines the appearance properties for a countdown component.
public struct CountdownVM: ComponentVM {
  /// The font used for displaying the countdown numbers and units.
  public var font: UniversalFont?

  /// The color of the countdown.
  public var color: ComponentColor?

  /// The predefined size of the countdown.
  ///
  /// Defaults to `.medium`.
  public var size: ComponentSize = .medium

  /// The position of the units relative to the countdown numbers.
  ///
  /// - Default value: `.bottom`
  public var unitsPosition: UnitsPosition = .bottom

  /// The visual style of the countdown component.
  ///
  /// - Default value: `.plain`
  public var style: CountdownStyle = .light

  /// The target date until which the countdown runs.
  ///
  public var until: Date = Date().addingTimeInterval(3600)

  /// The locale used for formatting the countdown.
  public var locale: Locale = .current

  /// Localization.
  public var localization: [Locale: UnitsLocalization] = [:]

  /// Initializes a new instance of `CountdownVM` with default values.
  public init() {}

  /// Initializes a new instance of `CountdownVM` with specified parameters.
  ///
  /// - Parameters:
  ///   - until: The target date until which the countdown runs.
  ///   - locale: The locale used for formatting the countdown. Defaults to `.current`.
  ///   - localization: Localization.
  public init(until: Date, locale: Locale = .current, localization: [Locale: UnitsLocalization] = [:]) {
    self.until = until
    self.locale = locale
    self.localization = localization
  }
}

// MARK: - Shared Helpers

extension CountdownVM {
  var preferredFont: UniversalFont {
    if let font = self.font {
      return font
    }

    switch self.size {
    case .small:
      return UniversalFont.Component.small
    case .medium:
      return UniversalFont.Component.medium
    case .large:
      return UniversalFont.Component.large
    }
  }
  var unitFontSize: CGFloat {
    switch self.size {
    case .small:
      return 6
    case .medium:
      return 8
    case .large:
      return 10
    }
  }
  var backgroundColor: UniversalColor {
    if let color {
      return color.main.withOpacity(0.15)
    } else {
      return .init(
        light: .rgba(r: 244, g: 244, b: 245, a: 1.0),
        dark: .rgba(r: 39, g: 39, b: 42, a: 1.0)
      )
    }
  }
  var foregroundColor: UniversalColor {
    let foregroundColor = self.color?.main ?? .init(
      light: .rgba(r: 0, g: 0, b: 0, a: 1.0),
      dark: .rgba(r: 255, g: 255, b: 255, a: 1.0)
    )
    return foregroundColor
  }
  var height: CGFloat {
    return switch self.size {
    case .small: 45
    case .medium: 55
    case .large: 60
    }
  }
  var horizontalPadding: CGFloat {
    return switch self.size {
    case .small: 8
    case .medium: 12
    case .large: 16
    }
  }
}
