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
    return self.color.main.withOpacity(self.isEnabled ? 1.0 : 0.5)
  }
  var foregroundColor: ThemeColor {
    return self.color.contrast.withOpacity(self.isEnabled ? 1.0 : 0.5)
  }
  var borderColor: ThemeColor {
    return .init(universal: .uiColor(.lightGray)).withOpacity(self.isEnabled ? 1.0 : 0.5)
  }
  var borderWidth: CGFloat {
    return 2.0
  }
}
