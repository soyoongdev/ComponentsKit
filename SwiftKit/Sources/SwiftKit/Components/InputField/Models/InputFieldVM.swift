import SwiftUI
import UIKit

public struct InputFieldVM: ComponentVM {
  public var autocapitalization: InputFieldTextAutocapitalization = .sentences
  public var color: ComponentColor?
  public var cornerRadius: ComponentRadius?
  public var font: Typography?
  public var isAutocorrectionEnabled: Bool = true
  public var isEnabled: Bool = true
  public var isRequired: Bool = false
  public var isSecureInput: Bool = false
  public var keyboardType: UIKeyboardType = .default
  public var placeholder: String?
  public var size: ComponentSize = .medium
  public var submitType: SubmitType = .return
  public var tintColor: ThemeColor = .accent
  public var title: String = ""

  public init() {}
}

// MARK: - Shared Helpers

extension InputFieldVM {
  var preferredFont: Typography {
    if let font {
      return font
    }

    switch self.size {
    case .small:
      return Typography.Component.medium
    case .medium:
      return Typography.Component.medium
    case .large:
      return Typography.Component.large
    }
  }
  var preferredCornerRadius: ComponentRadius {
    if let cornerRadius {
      return cornerRadius
    }

    switch self.size {
    case .small, .medium:
      return ComponentRadius.medium
    case .large:
      return ComponentRadius.large
    }
  }
  var horizontalPadding: CGFloat {
    switch self.preferredCornerRadius {
    case .none, .small, .medium, .large, .custom:
      return 12
    case .full:
      return 16
    }
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
      return self.preferredFont.withRelativeSize(-1)
    case .center:
      let relativePadding: CGFloat = switch self.size {
      case .small: 1.5
      case .medium: 2
      case .large: 3
      }
      return self.preferredFont.withRelativeSize(relativePadding)
    }
  }
}

// MARK: - Layout Helpers

extension InputFieldVM {
  var inputFieldTopPadding: CGFloat {
    switch self.size {
    case .small: 30
    case .medium: 34
    case .large: 38
    }
  }
  var inputFieldHeight: CGFloat {
    switch self.size {
    case .small: 26
    case .medium: 28
    case .large: 30
    }
  }
  var verticalPadding: CGFloat {
    switch self.size {
    case .small: 12
    case .medium: 14
    case .large: 16
    }
  }
  var height: CGFloat {
    return self.inputFieldHeight + self.inputFieldTopPadding + self.verticalPadding
  }
}

// MARK: - UIKit Helpers

extension InputFieldVM {
  var nsAttributedPlaceholder: NSAttributedString? {
    guard let placeholder else {
      return nil
    }
    return NSAttributedString(string: placeholder, attributes: [
      .font: self.preferredFont.uiFont,
      .foregroundColor: self.placeholderColor.uiColor
    ])
  }
  func nsAttributedTitle(for position: InputFieldTitlePosition) -> NSAttributedString {
    let attributedString = NSMutableAttributedString()
    attributedString.append(NSAttributedString(
      string: self.title,
      attributes: [
        .font: self.titleFont(for: position).uiFont,
        .foregroundColor: self.titleColor(for: position).uiColor
      ]
    ))
    if self.isRequired {
      attributedString.append(NSAttributedString(
        string: " ",
        attributes: [
          .font: UIFont.systemFont(ofSize: 5)
        ]
      ))
      attributedString.append(NSAttributedString(
        string: "*",
        attributes: [
          .font: self.titleFont(for: position).uiFont,
          .foregroundColor: ThemeColor.danger.uiColor
        ]
      ))
    }
    return attributedString
  }
  func shouldUpdateLayout(_ oldModel: Self) -> Bool {
    return self.size != oldModel.size
    || self.horizontalPadding != oldModel.horizontalPadding
  }
}

// MARK: - UIKit Helpers

extension InputFieldVM {
  var autocorrectionType: UITextAutocorrectionType {
    return self.isAutocorrectionEnabled ? .yes : .no
  }
  func attributedTitle(
    for position: InputFieldTitlePosition
  ) -> AttributedString {
    var attributedString = AttributedString()

    var attributedTitle = AttributedString(self.title)
    attributedTitle.font = self.titleFont(for: position).font
    attributedTitle.foregroundColor = self.titleColor(for: position).uiColor
    attributedString.append(attributedTitle)

    if self.isRequired {
      var space = AttributedString(" ")
      space.font = .systemFont(ofSize: 5)
      attributedString.append(space)

      var requiredSign = AttributedString("*")
      requiredSign.font = self.titleFont(for: position).font
      requiredSign.foregroundColor = ThemeColor.danger.uiColor
      attributedString.append(requiredSign)
    }

    return attributedString
  }
}
