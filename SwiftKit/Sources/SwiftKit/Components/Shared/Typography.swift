import SwiftUI
import UIKit

public enum Typography: Equatable {
  public enum Weight: Equatable {
    case ultraLight
    case thin
    case light
    case regular
    case medium
    case semibold
    case bold
    case heavy
    case black
  }
  case custom(name: String, size: CGFloat)
  case system(size: CGFloat, weight: Weight)

  var uiFont: UIFont {
    switch self {
    case .custom(let name, let size):
      guard let font = UIFont(name: name, size: size) else {
        fatalError("Unable to initialize font '\(name)'")
      }
      return font
    case let .system(size, weight):
      return UIFont.systemFont(ofSize: size, weight: weight.uiFontWeight)
    }
  }

  var font: Font {
    switch self {
    case .custom(let name, let size):
      return Font.custom(name, size: size)
    case .system(let size, let weight):
      return Font.system(size: size, weight: weight.swiftUIFontWeight)
    }
  }
}

// MARK: Helpers

extension Typography.Weight {
  var uiFontWeight: UIFont.Weight {
    switch self {
    case .ultraLight:
      return .ultraLight
    case .thin:
      return .thin
    case .light:
      return .light
    case .regular:
      return .regular
    case .medium:
      return .medium
    case .semibold:
      return .semibold
    case .bold:
      return .bold
    case .heavy:
      return .heavy
    case .black:
      return .black
    }
  }
}

extension Typography.Weight {
  var swiftUIFontWeight: Font.Weight {
    switch self {
    case .ultraLight:
      return .ultraLight
    case .thin:
      return .thin
    case .light:
      return .light
    case .regular:
      return .regular
    case .medium:
      return .medium
    case .semibold:
      return .semibold
    case .bold:
      return .bold
    case .heavy:
      return .heavy
    case .black:
      return .black
    }
  }
}

// MARK: - Typography + Config

extension Typography {
  public enum Component {
    public static var small: Typography {
      return SwiftKitConfig.shared.layout.componentFont.small
    }
    public static var medium: Typography {
      return SwiftKitConfig.shared.layout.componentFont.medium
    }
    public static var large: Typography {
      return SwiftKitConfig.shared.layout.componentFont.large
    }
  }
}
