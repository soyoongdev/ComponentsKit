import SwiftUI

/// A model that defines the appearance properties for a circular progress component.
public struct CircularProgressVM: ComponentVM {
  /// The color of the circular progress.
  ///
  /// Defaults to `.accent`.
  public var color: ComponentColor = .accent

  /// The style of the circular progress indicator.
  ///
  /// Defaults to `.light`.
  public var style: Style = .light

  /// The  size of the circular progress.
  ///
  /// Defaults to `.medium`.
  public var size: ComponentSize = .medium

  /// The minimum value of the circular progress.
  ///
  /// Defaults to `0`.
  public var minValue: CGFloat = 0

  /// The maximum value of the circular progress.
  ///
  /// Defaults to `100`.
  public var maxValue: CGFloat = 100

  /// The width of the circular progress stroke.
  public var lineWidth: CGFloat?

  /// An optional label to display inside the circular progress.
  public var label: String?

  /// The font used for the circular progress label text.
  public var font: UniversalFont?

  /// Initializes a new instance of `CircularProgressVM` with default values.
  public init() {}
}

// MARK: Shared Helpers

extension CircularProgressVM {
  var animationDuration: TimeInterval {
    return 0.2
  }
  var circularLineWidth: CGFloat {
    return self.lineWidth ?? max(self.preferredSize.width / 8, 2)
  }
  var preferredSize: CGSize {
    switch self.size {
    case .small:
      return CGSize(width: 48, height: 48)
    case .medium:
      return CGSize(width: 64, height: 64)
    case .large:
      return CGSize(width: 80, height: 80)
    }
  }
  var radius: CGFloat {
    return self.preferredSize.height / 2 - self.circularLineWidth / 2
  }
  var center: CGPoint {
    return .init(
      x: self.preferredSize.width / 2,
      y: self.preferredSize.height / 2
    )
  }
  var titleFont: UniversalFont {
    if let font {
      return font
    }
    switch self.size {
    case .small:
      return .smCaption
    case .medium:
      return .mdCaption
    case .large:
      return .lgCaption
    }
  }
  var stripeWidth: CGFloat {
    return 0.5
  }
  private func stripesCGPath(in rect: CGRect) -> CGMutablePath {
    let stripeSpacing: CGFloat = 3
    let stripeAngle: Angle = .degrees(135)

    let path = CGMutablePath()
    let step = stripeWidth + stripeSpacing
    let radians = stripeAngle.radians

    let dx: CGFloat = rect.height * tan(radians)
    for x in stride(from: 0, through: rect.width + rect.height, by: step) {
      let topLeft = CGPoint(x: x, y: 0)
      let bottomRight = CGPoint(x: x + dx, y: rect.height)

      path.move(to: topLeft)
      path.addLine(to: bottomRight)
      path.closeSubpath()
    }
    return path
  }
}

extension CircularProgressVM {
  func gap(for normalized: CGFloat) -> CGFloat {
    return normalized > 0 ? 0.05 : 0
  }

  func stripedArcStart(for normalized: CGFloat) -> CGFloat {
    let gapValue = self.gap(for: normalized)
    return max(0, min(1, normalized + gapValue))
  }

  func stripedArcEnd(for normalized: CGFloat) -> CGFloat {
    let gapValue = self.gap(for: normalized)
    return 1 - gapValue
  }
}

extension CircularProgressVM {
  func progress(for currentValue: CGFloat) -> CGFloat {
    let range = self.maxValue - self.minValue
    guard range > 0 else { return 0 }
    let normalized = (currentValue - self.minValue) / range
    return max(0, min(1, normalized))
  }
}

// MARK: - UIKit Helpers

extension CircularProgressVM {
  var isStripesLayerHidden: Bool {
    switch self.style {
    case .light:
      return true
    case .striped:
      return false
    }
  }
  var isBackgroundLayerHidden: Bool {
    switch self.style {
    case .light:
      return false
    case .striped:
      return true
    }
  }
  func stripesBezierPath(in rect: CGRect) -> UIBezierPath {
    let center = CGPoint(x: rect.midX, y: rect.midY)
    let path = UIBezierPath(cgPath: self.stripesCGPath(in: rect))
    var transform = CGAffineTransform.identity
    transform = transform
      .translatedBy(x: center.x, y: center.y)
      .rotated(by: -CGFloat.pi / 2)
      .translatedBy(x: -center.x, y: -center.y)
    path.apply(transform)
    return path
  }
  func shouldInvalidateIntrinsicContentSize(_ oldModel: Self) -> Bool {
    return self.preferredSize != oldModel.preferredSize
  }
  func shouldUpdateText(_ oldModel: Self) -> Bool {
    return self.label != oldModel.label
  }
  func shouldRecalculateProgress(_ oldModel: Self) -> Bool {
    return self.minValue != oldModel.minValue
    || self.maxValue != oldModel.maxValue
  }
}

// MARK: - SwiftUI Helpers

extension CircularProgressVM {
  func stripesPath(in rect: CGRect) -> Path {
    Path(self.stripesCGPath(in: rect))
  }
}
