// Copyright © SwiftKit. All rights reserved.

import UIKit

public struct ButtonVM {
  public var animationScale: AnimationScale
  public var color: ComponentColor
  public var cornerRadius: ComponentRadius
  public var font: UIFont
  public var isEnabled: Bool
  public var preferredSize: ButtonSize
  public var style: ButtonStyle
  public var title: String

  public init(
    animationScale: AnimationScale = .medium,
    color: ComponentColor = .primary,
    cornerRadius: ComponentRadius = .medium,
    font: UIFont = .systemFont(ofSize: 16),
    isEnabled: Bool = true,
    preferredSize: ButtonSize = .medium,
    style: ButtonStyle = .filled,
    title: String = ""
  ) {
    self.title = title
    self.preferredSize = preferredSize
    self.cornerRadius = cornerRadius
    self.style = style
    self.color = color
    self.animationScale = animationScale
    self.font = font
    self.isEnabled = isEnabled
  }
}

// MARK: Helpers

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

  public var backgroundColor: UIColor {
    switch self.style {
    case .filled:
      return self.mainColor
    case .plain, .bordered:
      return .clear
    }
  }

  public var foregroundColor: UIColor {
    switch self.style {
    case .filled:
      return self.contrastColor
    case .plain:
      return self.mainColor
    case .bordered:
      return self.mainColor
    }
  }

  public var borderWidth: CGFloat {
    switch self.style {
    case .filled, .plain:
      return 0.0
    case .bordered(let borderWidth):
      return borderWidth.value
    }
  }

  public func shouldUpdateSize(_ oldModel: Self?) -> Bool {
    return self.preferredSize != oldModel?.preferredSize
    || self.font != oldModel?.font
    || self.title != oldModel?.title
  }
}
