import SwiftUI

public struct CheckboxVM: ComponentVM {
  public var title: String?
  public var color: ComponentColor = .accent
  public var cornerRadius: ComponentRadius = .small
  public var font: Typography?
  public var isEnabled: Bool = true

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
}

// MARK: UIKit Helpers

extension CheckboxVM {
  func shouldUpdateBorderColor(_ oldModel: Self) -> Bool {
    return self.isEnabled != oldModel.isEnabled
  }
}
