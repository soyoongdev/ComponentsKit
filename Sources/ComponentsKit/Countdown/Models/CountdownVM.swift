import SwiftUI

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

  /// The visual style of the countdown component.
  ///
  /// Defaults to `.light`.
  public var style: CountdownStyle = .light

  /// The position of the units relative to the countdown numbers.
  ///
  /// Defaults to `.bottom`.
  public var unitsPosition: UnitsStyle = .bottom

  /// The target date until which the countdown runs.
  public var until: Date = Date().addingTimeInterval(3600 * 85)

  /// The locale used for localizing the countdown.
  public var locale: Locale = .current

  /// A dictionary containing localized representations of time units (days, hours, minutes, seconds) for various locales.
  ///
  /// This property can be used to override the default localizations for supported languages or to add
  /// localizations for unsupported languages. By default, the library provides strings for the following locales:
  /// - English ("en")
  /// - Spanish ("es")
  /// - French ("fr")
  /// - German ("de")
  /// - Chinese ("zh")
  /// - Japanese ("ja")
  /// - Russian ("ru")
  /// - Arabic ("ar")
  /// - Hindi ("hi")
  /// - Portuguese ("pt")
  public var localization: [Locale: UnitsLocalization] = [:]

  /// Initializes a new instance of `CountdownVM` with default values.
  public init() {}
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
    let preferredFontSize = self.preferredFont.uiFont.pointSize
    return preferredFontSize * 0.6
  }
  var unitFont: UniversalFont {
    return self.preferredFont.withSize(self.unitFontSize)
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
}

extension CountdownVM {
  func localizedUnit(_ unit: CountdownHelpers.Unit, length: CountdownHelpers.UnitLength) -> String {
    let localization = self.localization[self.locale]
    ?? UnitsLocalization.defaultLocalizations[self.locale]
    ?? UnitsLocalization.localizationFallback

    switch (unit, length) {
    case (.days, .long):
      return localization.days.long
    case (.days, .short):
      return localization.days.short

    case (.hours, .long):
      return localization.hours.long
    case (.hours, .short):
      return localization.hours.short

    case (.minutes, .long):
      return localization.minutes.long
    case (.minutes, .short):
      return localization.minutes.short

    case (.seconds, .long):
      return localization.seconds.long
    case (.seconds, .short):
      return localization.seconds.short
    }
  }

  func unitText(value: Int, unit: CountdownHelpers.Unit) -> NSAttributedString {
    let mainUIFont = self.preferredFont.uiFont
    let mainAttributes: [NSAttributedString.Key: Any] = [
      .font: mainUIFont,
      .foregroundColor: self.foregroundColor
    ]

    let formattedValue = String(format: "%02d", value)
    let result = NSMutableAttributedString(string: formattedValue, attributes: mainAttributes)

    switch self.unitsPosition {
    case .hidden:
      return result

    case .trailing:
      let localized = self.localizedUnit(unit, length: .short)
      let trailingStr = " " + localized
      let trailingAttributes: [NSAttributedString.Key: Any] = [
        .font: mainUIFont,
        .foregroundColor: self.foregroundColor
      ]
      result.append(NSAttributedString(string: trailingStr, attributes: trailingAttributes))
      return result

    case .bottom:
      let localized = self.localizedUnit(unit, length: .long)

      result.append(NSAttributedString(string: "\n", attributes: mainAttributes))

      let unitUIFont = self.unitFont.uiFont
      let unitAttributes: [NSAttributedString.Key: Any] = [
        .font: unitUIFont,
      ]
      result.append(NSAttributedString(string: localized, attributes: unitAttributes))
      return result
    }
  }
}
