import UIKit

public struct ButtonVM: ComponentVM {
  public var title: String = ""
  public var animationScale: AnimationScale = .medium
  public var color: ComponentColor = .primary
  public var cornerRadius: ComponentRadius?
  public var font: Typography?
  public var isEnabled: Bool = true
  public var isFullWidth: Bool = false
  public var size: ComponentSize = .medium
  public var style: ButtonStyle = .filled

  public init() {}
}

// MARK: Shared Helpers

extension ButtonVM {
  private var mainColor: ThemeColor {
    return self.isEnabled
    ? self.color.main
    : self.color.main.withOpacity(
      SwiftKitConfig.shared.layout.disabledOpacity
    )
  }
  private var contrastColor: ThemeColor {
    return self.isEnabled
    ? self.color.contrast
    : self.color.contrast.withOpacity(
      SwiftKitConfig.shared.layout.disabledOpacity
    )
  }
  var backgroundColor: ThemeColor? {
    switch self.style {
    case .filled:
      return self.mainColor
    case .plain, .bordered:
      return nil
    }
  }
  var foregroundColor: ThemeColor {
    switch self.style {
    case .filled:
      return self.contrastColor
    case .plain:
      return self.mainColor
    case .bordered:
      return self.mainColor
    }
  }
  var borderWidth: CGFloat {
    switch self.style {
    case .filled, .plain:
      return 0.0
    case .bordered(let borderWidth):
      return borderWidth.value
    }
  }
  var borderColor: ThemeColor? {
    switch self.style {
    case .filled, .plain:
      return nil
    case .bordered:
      return self.mainColor
    }
  }
  var preferredFont: Typography {
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
  var preferredCornerRadius: ComponentRadius {
    if let cornerRadius {
      return cornerRadius
    }

    switch self.size {
    case .small:
      return ComponentRadius.small
    case .medium:
      return ComponentRadius.medium
    case .large:
      return ComponentRadius.large
    }
  }
}

// MARK: UIKit Helpers

extension ButtonVM {
  func preferredSize(
    for contentSize: CGSize,
    parentWidth: CGFloat?
  ) -> CGSize {
    let width: CGFloat
    if self.isFullWidth {
      if let parentWidth, parentWidth > 0 {
        width = parentWidth
      } else {
        width = 10_000
      }
    } else {
      width = contentSize.width + 2 * self.horizontalPadding
    }

    return .init(width: width, height: self.height)
  }
  func shouldUpdateSize(_ oldModel: Self?) -> Bool {
    return self.size != oldModel?.size
    || self.font != oldModel?.font
    || self.isFullWidth != oldModel?.isFullWidth
  }
}

// MARK: SwiftUI Helpers

extension ButtonVM {
  var height: CGFloat {
    return switch self.size {
    case .small: 36
    case .medium: 50
    case .large: 70
    }
  }
  var width: CGFloat? {
    return self.isFullWidth ? 10_000 : nil
  }
  var horizontalPadding: CGFloat {
    return switch self.size {
    case .small: 8
    case .medium: 12
    case .large: 16
    }
  }
}
