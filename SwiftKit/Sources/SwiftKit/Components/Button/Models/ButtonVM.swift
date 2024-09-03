import UIKit

public struct ButtonVM: ComponentVM {
  public var title: String = ""
  public var animationScale: AnimationScale = .medium
  public var color: ComponentColor = .primary
  public var cornerRadius: ComponentRadius = .medium
  public var font: Typography?
  public var isEnabled: Bool = true
  public var size: ButtonSize = .medium
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

    switch self.size.height {
    case ButtonSize.small.height:
      return Typography.Component.small
    case ButtonSize.medium.height:
      return Typography.Component.medium
    case ButtonSize.large.height:
      return Typography.Component.large
    default:
      return Typography.Component.medium
    }
  }
}

// MARK: UIKit Helpers

extension ButtonVM {
  var insets: UIEdgeInsets {
    return .init(
      top: self.topInset,
      left: self.leadingInset,
      bottom: self.bottomInset,
      right: self.trailingInset
    )
  }

  func preferredSize(for contentSize: CGSize) -> CGSize {
    let width: CGFloat
    switch self.size.width {
    case .dynamic(let leadingInset, let trailingInset):
      width = contentSize.width + leadingInset + trailingInset
    case .constant(let value):
      width = value
    }

    let height: CGFloat
    switch self.size.height {
    case .dynamic(let topInset, let bottomInset):
      height = contentSize.height + topInset + bottomInset
    case .constant(let value):
      height = value
    }

    return .init(width: width, height: height)
  }

  func shouldUpdateSize(_ oldModel: Self?) -> Bool {
    return self.size != oldModel?.size
    || self.font != oldModel?.font
  }

  func shouldUpdateInsets(_ oldModel: Self?) -> Bool {
    return self.insets != oldModel?.insets
  }
}

// MARK: SwiftUI Helpers

extension ButtonVM {
  var height: CGFloat? {
    switch self.size.height {
    case .dynamic:
      return nil
    case .constant(let value):
      return value
    }
  }
  var width: CGFloat? {
    switch self.size.width {
    case .dynamic:
      return nil
    case .constant(let value):
      return value
    }
  }
  var leadingInset: CGFloat {
    switch self.size.width {
    case .dynamic(let leadingInset, _):
      return leadingInset
    case .constant:
      return 0
    }
  }
  var trailingInset: CGFloat {
    switch self.size.width {
    case .dynamic(_, let trailingInset):
      return trailingInset
    case .constant:
      return 0
    }
  }
  var topInset: CGFloat {
    switch self.size.height {
    case .dynamic(let topInset, _):
      return topInset
    case .constant:
      return 0
    }
  }
  var bottomInset: CGFloat {
    switch self.size.height {
    case .dynamic(_, let bottomInset):
      return bottomInset
    case .constant:
      return 0
    }
  }
}
