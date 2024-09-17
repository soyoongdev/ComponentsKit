import SwiftUI

public struct CheckboxVM: ComponentVM {
  public var title: String?
  public var color: ComponentColor = .accent
  public var cornerRadius: ComponentRadius?
  public var font: UniversalFont?
  public var isEnabled: Bool = true
  public var size: ComponentSize = .medium

  public init() {}
}

// MARK: Shared Helpers

extension CheckboxVM {
  var backgroundColor: UniversalColor {
    return self.color.main.withOpacity(
      self.isEnabled
      ? 1.0
      : SwiftKitConfig.shared.layout.disabledOpacity
    )
  }
  var foregroundColor: UniversalColor {
    return self.color.contrast.withOpacity(
      self.isEnabled
      ? 1.0
      : SwiftKitConfig.shared.layout.disabledOpacity
    )
  }
  var titleColor: UniversalColor {
    return Palette.Text.primary.withOpacity(
      self.isEnabled
      ? 1.0
      : SwiftKitConfig.shared.layout.disabledOpacity
    )
  }
  var borderColor: UniversalColor {
    return .universal(.uiColor(.lightGray)).withOpacity(
      self.isEnabled
      ? 1.0
      : SwiftKitConfig.shared.layout.disabledOpacity
    )
  }
  var borderWidth: CGFloat {
    return 2.0
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
    return self.title.isNotNilAndEmpty != oldModel.title.isNil
  }
  func shouldRemoveLabel(_ oldModel: Self) -> Bool {
    return self.title.isNil != oldModel.title.isNotNilAndEmpty
  }
  func shouldUpdateSize(_ oldModel: Self) -> Bool {
    return self.size != oldModel.size
  }
}
