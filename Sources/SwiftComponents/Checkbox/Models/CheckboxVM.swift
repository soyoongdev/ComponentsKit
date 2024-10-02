import SwiftUI

/// A model that defines the appearance properties for a checkbox component.
public struct CheckboxVM: ComponentVM {
  /// The label text displayed next to the checkbox.
  public var title: String?

  /// The color of the checkbox.
  ///
  /// Defaults to `.accent`.
  public var color: ComponentColor = .accent

  /// The corner radius of the checkbox.
  ///
  /// If not provided, the radius is automatically calculated based on the checkbox's size.
  public var cornerRadius: ComponentRadius?

  /// The font used for the checkbox label text.
  /// 
  /// If not provided, the font is automatically calculated based on the checkbox's size.
  public var font: UniversalFont?

  /// A Boolean value indicating whether the checkbox is enabled or disabled.
  ///
  /// Defaults to `true`.
  public var isEnabled: Bool = true

  /// The predefined size of the checkbox.
  ///
  /// Defaults to `.medium`.
  public var size: ComponentSize = .medium

  /// Initializes a new instance of `CheckboxVM` with default values.
  public init() {}
}

// MARK: Shared Helpers

extension CheckboxVM {
  var backgroundColor: UniversalColor {
    return self.color.main.withOpacity(
      self.isEnabled
      ? 1.0
      : SwiftComponentsConfig.shared.layout.disabledOpacity
    )
  }
  var foregroundColor: UniversalColor {
    return self.color.contrast.withOpacity(
      self.isEnabled
      ? 1.0
      : SwiftComponentsConfig.shared.layout.disabledOpacity
    )
  }
  var titleColor: UniversalColor {
    return Palette.Text.primary.withOpacity(
      self.isEnabled
      ? 1.0
      : SwiftComponentsConfig.shared.layout.disabledOpacity
    )
  }
  var borderColor: UniversalColor {
    return .universal(.uiColor(.lightGray)).withOpacity(
      self.isEnabled
      ? 1.0
      : SwiftComponentsConfig.shared.layout.disabledOpacity
    )
  }
  var borderWidth: CGFloat {
    return 2.0
  }
  var spacing: CGFloat {
    return self.title.isNil ? 0.0 : 8.0
  }
  var checkmarkLineWidth: CGFloat {
    switch self.size {
    case .small:
      return 1.5
    case .medium:
      return 2.0
    case .large:
      return 2.5
    }
  }
  var checkboxSide: CGFloat {
    switch self.size {
    case .small:
      return 18.0
    case .medium:
      return 24.0
    case .large:
      return 32.0
    }
  }
  private var preferredCornerRadius: ComponentRadius {
    if let cornerRadius {
      return cornerRadius
    }

    switch self.size {
    case .small:
      return .small
    case .medium:
      return .medium
    case .large:
      return .large
    }
  }
  var checkboxCornerRadius: CGFloat {
    switch self.preferredCornerRadius {
    case .none:
      return 0.0
    case .small:
      return self.checkboxSide / 3.5
    case .medium:
      return self.checkboxSide / 3.0
    case .large:
      return self.checkboxSide / 2.5
    case .full:
      return self.checkboxSide / 2.0
    case .custom(let value):
      return min(value, self.checkboxSide / 2)
    }
  }
  var titleFont: UniversalFont {
    if let font {
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
}

// MARK: UIKit Helpers

extension CheckboxVM {
  func shouldAddLabel(_ oldModel: Self) -> Bool {
    return self.title.isNotNilAndEmpty && oldModel.title.isNilOrEmpty
  }
  func shouldRemoveLabel(_ oldModel: Self) -> Bool {
    return self.title.isNilOrEmpty && oldModel.title.isNotNilAndEmpty
  }
  func shouldUpdateSize(_ oldModel: Self) -> Bool {
    return self.size != oldModel.size
  }
  func shouldUpadateLayout(_ oldModel: Self) -> Bool {
    return self.size != oldModel.size
    || self.title.isNotNilAndEmpty && oldModel.title.isNilOrEmpty
    || self.title.isNilOrEmpty && oldModel.title.isNotNilAndEmpty
  }
}
