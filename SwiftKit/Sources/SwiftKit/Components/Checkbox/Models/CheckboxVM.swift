import SwiftUI

public struct CheckboxVM: ComponentVM {
  public var title: String?
  public var color: ComponentColor = .accent
  public var cornerRadius: ComponentRadius = .medium
  public var font: Typography?
  public var isEnabled: Bool = true
  public var size: ComponentSize = .medium

  public init() {}
}

// MARK: Shared Helpers

extension CheckboxVM {
  var backgroundColor: ThemeColor {
    return self.color.main.withOpacity(
      self.isEnabled
      ? 1.0
      : SwiftKitConfig.shared.layout.disabledOpacity
    )
  }
  var foregroundColor: ThemeColor {
    return self.color.contrast.withOpacity(
      self.isEnabled
      ? 1.0
      : SwiftKitConfig.shared.layout.disabledOpacity
    )
  }
  var titleColor: ThemeColor {
    return Palette.Text.primary.withOpacity(
      self.isEnabled
      ? 1.0
      : SwiftKitConfig.shared.layout.disabledOpacity
    )
  }
  var borderColor: ThemeColor {
    return .init(universal: .uiColor(.lightGray)).withOpacity(
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
  var checkboxCornerRadius: CGFloat {
    switch self.cornerRadius {
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
  var titleFont: Typography {
    if let font {
      return font
    }

    switch self.size {
    case .small:
      return Typography.Component.small
    case .medium:
      return Typography.Component.medium
    case .large:
      return Typography.Component.large
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
