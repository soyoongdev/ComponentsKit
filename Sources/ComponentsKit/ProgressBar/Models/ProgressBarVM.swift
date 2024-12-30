import SwiftUI

/// A model that defines the appearance properties for a a progress bar component.
public struct ProgressBarVM: ComponentVM {
  /// The color of the progress bar..
  ///
  /// Defaults to `.accent`.
  public var color: ComponentColor = .accent

  /// The visual style of the progress bar component.
  ///
  /// Defaults to `.striped`.
  public var style: Style = .striped

  /// The size of the progress bar.
  ///
  /// Defaults to `.medium`.
  public var size: ComponentSize = .medium

  /// The minimum value of the progress bar.
  public var minValue: CGFloat = 0

  /// The maximum value of the progress bar.
  public var maxValue: CGFloat = 100

  /// The corner radius of the progress bar.
  ///
  /// Defaults to `.medium`.
  public var cornerRadius: ComponentRadius = .medium

  /// The padding applied to the modal's content area.
  ///
  /// Defaults to a padding value of `3` for all sides.
  public var contentPaddings: Paddings = .init(padding: 3)

  /// Initializes a new instance of `ProgressBarVM` with default values.
  public init() {}
}

// MARK: - Shared Helpers

extension ProgressBarVM {
  var barHeight: CGFloat {
    switch self.style {
    case .light:
      switch size {
      case .small:
        return 4
      case .medium:
        return 8
      case .large:
        return 12
      }
    case .filled, .striped:
      switch self.size {
      case .small:
        return 20
      case .medium:
        return 32
      case .large:
        return 42
      }
    }
  }

  var computedCornerRadius: CGFloat {
    switch self.cornerRadius {
    case .none:
      return 0.0
    case .small:
      return self.barHeight / 3.5
    case .medium:
      return self.barHeight / 3.0
    case .large:
      return self.barHeight / 2.5
    case .full:
      return self.barHeight / 2.0
    case .custom(let value):
      return min(value, self.barHeight / 2)
    }
  }

  var innerCornerRadius: CGFloat {
    let distance: CGFloat = 3
    return max(0, self.computedCornerRadius - distance)
  }

  var backgroundColor: UniversalColor {
    switch style {
    case .light:
      return self.color.background
    case .filled, .striped:
      return self.color.main
    }
  }

  var barColor: UniversalColor {
    switch style {
    case .light:
      return self.color.main
    case .filled, .striped:
      return self.color.contrast
    }
  }

  func layoutNeedsUpdate(from oldModel: Self) -> Bool {
    return self.size != oldModel.size
    || self.cornerRadius != oldModel.cornerRadius
    || self.style != oldModel.style
  }

  private func stripesCGPath(in rect: CGRect) -> CGMutablePath {
    let stripeWidth: CGFloat = 2
    let stripeSpacing: CGFloat = 4
    let stripeAngle: Angle = .degrees(135)

    let path = CGMutablePath()
    let step = stripeWidth + stripeSpacing
    let radians = stripeAngle.radians
    let dx = rect.height * tan(radians)
    for x in stride(from: dx, through: rect.width + rect.height, by: step) {
      let topLeft = CGPoint(x: x, y: 0)
      let topRight = CGPoint(x: x + stripeWidth, y: 0)
      let bottomLeft = CGPoint(x: x + dx, y: rect.height)
      let bottomRight = CGPoint(x: x + stripeWidth + dx, y: rect.height)
      path.move(to: topLeft)
      path.addLine(to: topRight)
      path.addLine(to: bottomRight)
      path.addLine(to: bottomLeft)
      path.closeSubpath()
    }
    return path
  }

  public func stripesPath(in rect: CGRect) -> Path {
    return Path(self.stripesCGPath(in: rect))
  }

  public func stripesBezierPath(in rect: CGRect) -> UIBezierPath {
    return UIBezierPath(cgPath: self.stripesCGPath(in: rect))
  }
}

// MARK: - Validation

extension ProgressBarVM {
  func validateMinMaxValues() {
    if self.minValue > self.maxValue {
      assertionFailure("Min value must be less than max value")
    }
  }
}
