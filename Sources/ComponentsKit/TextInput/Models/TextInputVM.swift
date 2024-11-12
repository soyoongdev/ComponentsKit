import SwiftUI
import UIKit

/// A model that defines the appearance properties for an input field component.
public struct TextInputVM: ComponentVM {
  /// The autocapitalization behavior for the input field.
  ///
  /// Defaults to `.sentences`, which capitalizes the first letter of each sentence.
  public var autocapitalization: InputFieldTextAutocapitalization = .sentences

  /// The color of the input field.
  public var color: ComponentColor?

  /// The corner radius of the input field.
  ///
  /// Defaults to `.medium`.
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

  public var minRows: Int = 2

  public var maxRows: Int?

  /// Initializes a new instance of `TextInputVM` with default values.
  public init() {}
}

// MARK: - Shared Helpers

extension TextInputVM {
  var adaptedCornerRadius: ComponentRadius {
    switch self.cornerRadius {
    case .none:
      return .none
    case .small:
      return .small
    case .medium:
      return .medium
    case .large:
      return .large
    case .full:
      return .custom(self.height(forRows: 1) / 2)
    case .custom(let value):
      return .custom(value)
    }
  }

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

  var height: CGFloat {
    return switch self.size {
    case .small: 40
    case .medium: 60
    case .large: 80
    }
  }

  var contentPadding: CGFloat {
    return 12
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
}

// MARK: - SwiftUI Helpers

extension TextInputVM {
  var autocorrectionType: UITextAutocorrectionType {
    return self.isAutocorrectionEnabled ? .yes : .no
  }

  var minTextInputHeight: CGFloat {
    let numberOfRows: Int
    if let maxRows {
      numberOfRows = min(maxRows, self.minRows)
    } else {
      numberOfRows = self.minRows
    }
    return self.height(forRows: numberOfRows)
  }

  var maxTextInputHeight: CGFloat {
    if let maxRows {
      return self.height(forRows: maxRows)
    } else {
      return 10_000
    }
  }

  private func height(forRows rows: Int) -> CGFloat {
    // TODO: [2] Show a warning if number of rows less than 1
    let numberOfRows = max(1, rows)
    return self.preferredFont.uiFont.lineHeight * CGFloat(numberOfRows) + 2 * self.contentPadding
  }
}
