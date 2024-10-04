import UIKit

/// A model that defines the appearance properties for a button component.
public struct ButtonVM: ComponentVM {
  /// The text displayed on the button.
  public var title: String = ""

  /// The scaling factor for the button's press animation, with a value between 0 and 1.
  ///
  /// If not provided, the scale is automatically calculated based on the button's size.
  public var animationScale: AnimationScale?

  /// The color of the button.
  ///
  /// Defaults to `.primary`.
  public var color: ComponentColor = .primary

  /// The corner radius of the button.
  ///
  /// If not provided, the radius is automatically calculated based on the button's size.
  public var cornerRadius: ComponentRadius?

  /// The font used for the button's title text.
  ///
  /// If not provided, the font is automatically calculated based on the button's size.
  public var font: UniversalFont?

  /// A Boolean value indicating whether the button is enabled or disabled.
  ///
  /// Defaults to `true`.
  public var isEnabled: Bool = true

  /// A Boolean value indicating whether the button should occupy the full width of its superview.
  ///
  /// Defaults to `false`.
  public var isFullWidth: Bool = false

  /// The predefined size of the button.
  ///
  /// Defaults to `.medium`.
  public var size: ComponentSize = .medium

  /// The visual style of the button.
  ///
  /// Defaults to `.filled`.
  public var style: ButtonStyle = .filled

  /// Initializes a new instance of `ButtonVM` with default values.
  public init() {}
}

// MARK: Shared Helpers

extension ButtonVM {
  private var mainColor: UniversalColor {
    return self.isEnabled
    ? self.color.main
    : self.color.main.withOpacity(
      SwiftComponentsConfig.shared.layout.disabledOpacity
    )
  }
  private var contrastColor: UniversalColor {
    return self.isEnabled
    ? self.color.contrast
    : self.color.contrast.withOpacity(
      SwiftComponentsConfig.shared.layout.disabledOpacity
    )
  }
  var backgroundColor: UniversalColor? {
    switch self.style {
    case .filled:
      return self.mainColor
    case .plain, .bordered:
      return nil
    }
  }
  var foregroundColor: UniversalColor {
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
  var borderColor: UniversalColor? {
    switch self.style {
    case .filled, .plain:
      return nil
    case .bordered:
      return self.mainColor
    }
  }
  var preferredAnimationScale: AnimationScale {
    if let animationScale {
      return animationScale
    }

    switch self.size {
    case .small:
      return AnimationScale.small
    case .medium:
      return AnimationScale.medium
    case .large:
      return AnimationScale.large
    }
  }
  var preferredFont: UniversalFont {
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
  var height: CGFloat {
    return switch self.size {
    case .small: 36
    case .medium: 50
    case .large: 70
    }
  }
  var horizontalPadding: CGFloat {
    return switch self.size {
    case .small: 8
    case .medium: 12
    case .large: 16
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
  var width: CGFloat? {
    return self.isFullWidth ? 10_000 : nil
  }
}
