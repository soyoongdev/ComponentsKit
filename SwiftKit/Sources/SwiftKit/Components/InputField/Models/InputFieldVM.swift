import UIKit

public struct InputFieldVM: ComponentVM {
  public var color: ComponentColor?
  public var cornerRadius: ComponentRadius = .medium
  public var font: Typography = Typography.Component.medium
  public var isEnabled: Bool = true
  public var isSecureInput: Bool = false
  public var keyboardType: UIKeyboardType = .default
  public var placeholder: String?
  public var submitType: SubmitType = .return
  public var tintColor: ThemeColor = .accent
  public var title: String = ""

  public init() {}
}

// MARK: - Shared Helpers

extension InputFieldVM {
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
    let foregroundColor = self.color?.main ?? .init(
      light: .rgba(r: 0, g: 0, b: 0, a: 1.0),
      dark: .rgba(r: 255, g: 255, b: 255, a: 1.0)
    )
    return foregroundColor.withOpacity(
      self.isEnabled ? 1.0 : 0.5
    )
  }
  var placeholderColor: ThemeColor {
    return self.foregroundColor.withOpacity(self.isEnabled ? 0.7 : 0.3)
  }
  func titleColor(for position: InputFieldTitlePosition) -> ThemeColor {
    switch position {
    case .top:
      return self.foregroundColor
    case .center:
      return self.foregroundColor.withOpacity(self.isEnabled ? 0.8 : 0.45)
    }
  }
  func titleFont(for position: InputFieldTitlePosition) -> Typography {
    switch position {
    case .top:
      return self.font.withRelativeSize(-2)
    case .center:
      return self.font.withRelativeSize(2)
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
      .foregroundColor: self.placeholderColor.uiColor
    ])
  }
}
