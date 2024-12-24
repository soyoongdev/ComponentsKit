import SwiftUI

public enum ProgressBarStyle: String {
  case light
  case filled
  case striped
}

public struct ProgressBarVM: ComponentVM {
  public var color: ComponentColor = .primary
  public var style: ProgressBarStyle = .striped
  public var size: ComponentSize = .medium
  public var minValue: CGFloat = 0
  public var maxValue: CGFloat = 100

  public var cornerRadius: ComponentRadius = .medium
  public var stripeWidth: CGFloat = 2
  public var stripeSpacing: CGFloat = 4
  public var stripeAngle: Angle = .degrees(135)

  public init() {}
}

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
    case .filled:
      return self.color.main
    case .striped:
      return self.color.main
    }
  }

  var barColor: UniversalColor {
    switch style {
    case .light:
      return self.color.main
    case .filled:
      return self.color.contrast
    case .striped:
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
    
    for x in stride(from: -dx - step, through: rect.width + step, by: step) {
      let topLeft  = CGPoint(x: x, y: 0)
      let topRight = CGPoint(x: x + stripeWidth, y: 0)
      let bottomLeft  = CGPoint(x: x + dx, y: rect.height)
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
