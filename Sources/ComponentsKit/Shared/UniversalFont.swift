import SwiftUI
import UIKit

public enum UniversalFont: Hashable {
  public enum Weight: Hashable {
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

  // MARK: Fonts

  public var uiFont: UIFont {
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

  public var font: Font {
    switch self {
    case .custom(let name, let size):
      return Font.custom(name, size: size)
    case .system(let size, let weight):
      return Font.system(size: size, weight: weight.swiftUIFontWeight)
    }
  }

  // MARK: Helpers

  public func withSize(_ size: CGFloat) -> Self {
    switch self {
    case .custom(let name, _):
      return .custom(name: name, size: size)
    case .system(_, let weight):
      return .system(size: size, weight: weight)
    }
  }

  public func withRelativeSize(_ shift: CGFloat) -> Self {
    switch self {
    case .custom(let name, let size):
      return .custom(name: name, size: size + shift)
    case .system(let size, let weight):
      return .system(size: size + shift, weight: weight)
    }
  }
}

// MARK: Helpers

extension UniversalFont.Weight {
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

extension UniversalFont.Weight {
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

// MARK: - UniversalFont + Config

extension UniversalFont {
  public static var smHeadline: UniversalFont {
    return ComponentsKitConfig.shared.layout.typography.headline.small
  }
  public static var mdHeadline: UniversalFont {
    return ComponentsKitConfig.shared.layout.typography.headline.medium
  }
  public static var lgHeadline: UniversalFont {
    return ComponentsKitConfig.shared.layout.typography.headline.large
  }

  public static var smBody: UniversalFont {
    return ComponentsKitConfig.shared.layout.typography.body.small
  }
  public static var mdBody: UniversalFont {
    return ComponentsKitConfig.shared.layout.typography.body.medium
  }
  public static var lgBody: UniversalFont {
    return ComponentsKitConfig.shared.layout.typography.body.large
  }

  public static var smButton: UniversalFont {
    return ComponentsKitConfig.shared.layout.typography.button.small
  }
  public static var mdButton: UniversalFont {
    return ComponentsKitConfig.shared.layout.typography.button.medium
  }
  public static var lgButton: UniversalFont {
    return ComponentsKitConfig.shared.layout.typography.button.large
  }
}
