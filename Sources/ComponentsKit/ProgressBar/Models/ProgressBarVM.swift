import SwiftUI

/// A model that defines the appearance properties for a a progress bar component.
public struct ProgressBarVM: ComponentVM {
  /// The color of the progress bar..
  ///
  /// Defaults to `.primary`.
  public var color: ComponentColor = .primary

  /// The visual style of the progress bar component.
  ///
  /// Defaults to `.light`.
  public var style: ProgressBarStyle = .striped

  /// The size of the progress bar.
  ///
  /// Defaults to `.medium`.
  public var size: ComponentSize = .large

  /// The minimum value of the progress bar.
  public var minValue: CGFloat = 0

  /// The maximum value of the progress bar.
  public var maxValue: CGFloat = 100

  /// The corner radius of the progress bar.
  ///
  /// Defaults to `.medium`.
  public var cornerRadius: ComponentRadius = .medium

  /// The width of the stripes in the `.striped` progress bar style.
  public var stripeWidth: CGFloat = 2

  /// The spacing between the stripes in the `.striped` progress bar style.
  public var stripeSpacing: CGFloat = 4

  /// The angle of the stripes in the `.striped` progress bar style..
  public var stripeAngle: Angle = .degrees(135)

  /// Initializes a new instance of `ProgressBarVM` with default values.
  public init() {}
}

// MARK: - Shared Helpers

extension ProgressBarVM {
  var barHeight: CGFloat {
    switch style {
    case .light:
      switch size {
      case .small:
        return 4
      case .medium:
        return 8
      case .large:
        return 16
      }
    case .filled, .striped:
      switch size {
      case .small:
        return 10
      case .medium:
        return 25
      case .large:
        return 45
      }
    }
  }

  var computedCornerRadius: CGFloat {
    switch style {
    case .light:
      return barHeight / 2
    case .filled, .striped:
      switch size {
      case .small, .medium:
        return barHeight / 2
      case .large:
        return barHeight / 2.5
      }
    }
  }

  var backgroundColor: UniversalColor {
    switch style {
    case .light:
      return self.color.main.withOpacity(0.15)
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

  func shouldUpdateLayout(_ oldModel: Self) -> Bool {
    return self.size != oldModel.size
  }

  public func stripesPath(in rect: CGRect) -> Path {
    var path = Path()
    let step = stripeWidth + stripeSpacing
    let radians = stripeAngle.radians
    let dx = rect.height * tan(radians)

    for x in stride(from: dx - step, through: rect.width + step, by: step) {
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

  public func stripesBezierPath(in rect: CGRect) -> UIBezierPath {
    let swiftUIPath = stripesPath(in: rect)
    return UIBezierPath(cgPath: swiftUIPath.cgPath)
  }
}

// MARK: - Validation

extension ProgressBarVM {
  public func isValid() -> Bool {
    return minValue < maxValue
  }
}
