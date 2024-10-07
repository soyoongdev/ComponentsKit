import SwiftUI
import UIKit

/// A model that defines the appearance properties for an input field component.
public struct InputFieldVM: ComponentVM {
  /// The autocapitalization behavior for the input field.
  ///
  /// Defaults to `.sentences`, which capitalizes the first letter of each sentence.
  public var autocapitalization: InputFieldTextAutocapitalization = .sentences

  /// The color of the input field.
  public var color: ComponentColor?

  /// The corner radius of the input field.
  ///
  /// /// Defaults to `.medium`.
  public var cornerRadius: ComponentRadius = .medium

  /// The font used for the input field's text.
  ///
  /// If not provided, the font is automatically calculated based on the checkbox's size.
  public var font: UniversalFont?

  /// A Boolean value indicating whether autocorrection is enabled for the input field.
  ///
  /// Defaults to `true`.
  public var isAutocorrectionEnabled: Bool = true

  /// A Boolean value indicating whether the input field is enabled or disabled.
  ///
  /// Defaults to `true`.
  public var isEnabled: Bool = true

  /// A Boolean value indicating whether the input field is required to be filled.
  ///
  /// Defaults to `false`.
  public var isRequired: Bool = false

  /// A Boolean value indicating whether the input field should hide the input text for secure data entry (e.g., passwords).
  ///
  /// Defaults to `false`.
  public var isSecureInput: Bool = false

  /// The type of keyboard to display when the input field is active.
  ///
  /// Defaults to `.default`.
  public var keyboardType: UIKeyboardType = .default

  /// The placeholder text displayed when there is no input.
  public var placeholder: String?

  /// The predefined size of the input field.
  ///
  /// Defaults to `.medium`.
  public var size: ComponentSize = .medium

  /// The type of the submit button on the keyboard.
  ///
  /// Defaults to `.return`.
  public var submitType: SubmitType = .return

  /// The tint color applied to the input field's cursor.
  ///
  /// Defaults to `.accent`.
  public var tintColor: UniversalColor = .accent

  /// The title displayed on the input field.
  public var title: String = ""

  /// Initializes a new instance of `InputFieldVM` with default values.
  public init() {}
}

// MARK: - Shared Helpers

extension InputFieldVM {
  var preferredFont: UniversalFont {
    if let font {
      return font
    }

    switch self.size {
    case .small:
      return UniversalFont.Component.medium
    case .medium:
      return UniversalFont.Component.medium
    case .large:
      return UniversalFont.Component.large
    }
  }
  var horizontalPadding: CGFloat {
    switch self.cornerRadius {
    case .none, .small, .medium, .large, .custom:
      return 12
    case .full:
      return 16
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
    return foregroundColor.withOpacity(
      self.isEnabled ? 1.0 : 0.5
    )
  }
  var placeholderColor: UniversalColor {
    return self.foregroundColor.withOpacity(self.isEnabled ? 0.7 : 0.3)
  }
  func titleColor(for position: InputFieldTitlePosition) -> UniversalColor {
    switch position {
    case .top:
      return self.foregroundColor
    case .center:
      return self.foregroundColor.withOpacity(self.isEnabled ? 0.8 : 0.45)
    }
  }
  func titleFont(for position: InputFieldTitlePosition) -> UniversalFont {
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
          .foregroundColor: UniversalColor.danger.uiColor
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
      requiredSign.foregroundColor = UniversalColor.danger.uiColor
      attributedString.append(requiredSign)
    }

    return attributedString
  }
}
