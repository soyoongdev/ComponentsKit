import UIKit

public struct Color {
  // MARK: ColorRepresentable

  public enum ColorRepresentable {
    case rgba(r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat)
    case hex(String)
    case uiColor(UIColor)

    fileprivate var uiColor: UIColor {
      switch self {
      case .rgba(let red, let green, let blue, let alpha):
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
      case .hex(let value):
        return UIColor(hex: value)
      case .uiColor(let uiColor):
        return uiColor
      }
    }
  }

  // MARK: Properties

  let light: ColorRepresentable
  let dark: ColorRepresentable

  // MARK: Initialization

  public init(light: ColorRepresentable, dark: ColorRepresentable) {
    self.light = light
    self.dark = dark
  }

  public init(universal: ColorRepresentable) {
    self.light = universal
    self.dark = universal
  }

  // MARK: Colors

  public var uiColor: UIColor {
    UIColor { trait in
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
}
