import Foundation
public struct InputFieldVM: ComponentVM {
  public var title: String = ""
  public var placeholder: String?
  public var tintColor: ThemeColor = .accent
  public var color: ComponentColor?
  public var cornerRadius: ComponentRadius = .medium
  public var font: Typography = Typography.Component.medium
  public var isEnabled: Bool = true
//  public var style: ButtonStyle = .filled

  public init() {}
}

// MARK: - Shared Helpers

extension InputFieldVM {
  var titleFont: Typography {
    return self.font.withRelativeSize(-2)
  }
  var backgroundColor: ThemeColor {
    if let color {
      return color.main.withOpacity(0.25)
    } else {
      return .init(
        light: .rgba(r: 244, g: 244, b: 245, a: 1.0),
        dark: .rgba(r: 39, g: 39, b: 42, a: 1.0)
      )
    }
  }
  var foregroundColor: ThemeColor {
    if let color {
      return color.main
    } else {
      return .init(
        light: .rgba(r: 0, g: 0, b: 0, a: 1.0),
        dark: .rgba(r: 255, g: 255, b: 255, a: 1.0)
      )
    }
  }
}

// MARK: - UIKit Helpers

extension InputFieldVM {
  var attributedPlaceholder: NSAttributedString? {
    guard let placeholder else {
      return nil
    }
    return NSAttributedString(string: placeholder, attributes: [
      .font: self.font.uiFont,
      .foregroundColor: self.foregroundColor.withOpacity(0.7).uiColor
    ])
  }
}
