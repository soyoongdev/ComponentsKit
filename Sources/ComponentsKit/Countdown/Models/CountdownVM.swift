import SwiftUI

public enum UnitsPosition {
  case none
  case bottom
  case trailing
}

public enum CountdownStyle {
  case plain
  case light
}

public struct CountdownVM: ComponentVM {
  public var font: UniversalFont?
  public var color: ComponentColor?
  public var size: ComponentSize = .medium
  public var unitsPosition: UnitsPosition = .bottom
  public var style: CountdownStyle = .plain
  public var until: Date = Date().addingTimeInterval(3600)

  public init() {}

  public init(until: Date) {
    self.until = until
  }
}

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

  var backgroundColor: UniversalColor {
    if let color {
      return color.main.withOpacity(0.25)
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
}
