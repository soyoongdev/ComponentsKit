import UIKit

public struct ButtonVM: ComponentVM {
  public var title: String = ""
  public var animationScale: AnimationScale = .medium
  public var color: ComponentColor = .primary
  public var cornerRadius: ComponentRadius = .medium
  public var font: UIFont?
  public var isEnabled: Bool = true
  public var size: ButtonSize = .medium
  public var style: ButtonStyle = .filled

  public init() {}
}

// MARK: Shared Helpers

extension ButtonVM {
  // TODO: [1] The model should not depend on uikit
  private var mainColor: UIColor {
    return self.isEnabled
    ? self.color.main.uiColor
    : self.color.main.uiColor.withAlphaComponent(
      SwiftKitConfig.shared.layout.disabledOpacity
    )
  }
  private var contrastColor: UIColor {
    return self.isEnabled
    ? self.color.contrast.uiColor
    : self.color.contrast.uiColor.withAlphaComponent(
      SwiftKitConfig.shared.layout.disabledOpacity
    )
  }

  var backgroundColor: UIColor {
    switch self.style {
    case .filled:
      return self.mainColor
    case .plain, .bordered:
      return .clear
    }
  }

  var foregroundColor: UIColor {
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

  var borderColor: UIColor {
    switch self.style {
    case .filled, .plain:
      return .clear
    case .bordered(let borderWidth):
      return self.mainColor
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
