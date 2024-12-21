import UIKit

/// A model that defines the appearance properties for a button component.
public struct ButtonVM: ComponentVM {
  /// The text displayed on the button.
  public var title: String = ""

  /// The scaling factor for the button's press animation, with a value between 0 and 1.
  ///
  /// Defaults to `.medium`.
  public var animationScale: AnimationScale = .medium

  /// The color of the button.
  public var color: ComponentColor?

  /// The corner radius of the button.
  ///
  /// Defaults to `.medium`.
  public var cornerRadius: ComponentRadius = .medium

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
  public var style: Style = .filled

  /// Initializes a new instance of `ButtonVM` with default values.
  public init() {}
}

// MARK: Shared Helpers

extension ButtonVM {
  var backgroundColor: UniversalColor? {
    switch self.style {
    case .filled:
      let color = self.color?.main ?? .content2
      return color.enabled(self.isEnabled)
    case .light:
      let color = self.color?.background ?? .content1
      return color.enabled(self.isEnabled)
    case .plain, .bordered:
      return nil
    }
  }
  var foregroundColor: UniversalColor {
    let color = switch self.style {
    case .filled:
      self.color?.contrast ?? .foreground
    case .plain, .light, .bordered:
      self.color?.main ?? .foreground
    }
    return color.enabled(self.isEnabled)
  }
  var borderWidth: CGFloat {
    switch self.style {
    case .filled, .plain, .light:
      return 0.0
    case .bordered(let borderWidth):
      return borderWidth.value
    }
  }
  var borderColor: UniversalColor? {
    switch self.style {
    case .filled, .plain, .light:
      return nil
    case .bordered:
      if let color {
        return color.main.enabled(self.isEnabled)
      } else {
        return .divider
      }
    }
  }
  var preferredFont: UniversalFont {
    if let font {
      return font
    }

    switch self.size {
    case .small:
      return .smButton
    case .medium:
      return .mdButton
    case .large:
      return .mdButton
    }
  }
  var height: CGFloat {
    return switch self.size {
    case .small: 36
    case .medium: 44
    case .large: 52
    }
  }
  var horizontalPadding: CGFloat {
    return switch self.size {
    case .small: 16
    case .medium: 20
    case .large: 24
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
