import Foundation

public struct LoadingVM: ComponentVM {
  public var color: ComponentColor = .primary
  // TODO: [1] Remove `isAnimating` property
  public var isAnimating: Bool = true
  public var lineWidth: CGFloat?
  public var size: ComponentSize = .medium
  public var speed: CGFloat = 1.0
  public var style: LoadingStyle = .spinner

  public init() {}
}

// MARK: Shared Helpers

extension LoadingVM {
  var loadingLineWidth: CGFloat {
    return self.lineWidth ?? max(self.preferredSize.width / 8, 2)
  }
  var preferredSize: CGSize {
    switch self.style {
    case .spinner:
      switch self.size {
      case .small:
        return .init(width: 24, height: 24)
      case .medium:
        return .init(width: 36, height: 36)
      case .large:
        return .init(width: 48, height: 48)
      }
    }
  }
  var radius: CGFloat {
    return self.preferredSize.height / 2 - self.loadingLineWidth / 2
  }
}

// MARK: UIKit Helpers

extension LoadingVM {
  func shouldStartAnimating(_ oldModel: Self) -> Bool {
    return self.isAnimating && !oldModel.isAnimating
  }
  func shouldStopAnimating(_ oldModel: Self) -> Bool {
    return !self.isAnimating && oldModel.isAnimating
  }
  func shouldUpdateShapePath(_ oldModel: Self) -> Bool {
    return self.size != oldModel.size || self.lineWidth != oldModel.lineWidth
  }
  func shouldUpdateSize(_ oldModel: Self) -> Bool {
    return self.size != oldModel.size
  }
  func shouldUpdateAnimationSpeed(_ oldModel: Self) -> Bool {
    return self.speed != oldModel.speed
  }
}

// MARK: SwiftUI Helpers

extension LoadingVM {
  var center: CGPoint {
    return .init(
      x: self.preferredSize.width / 2,
      y: self.preferredSize.height / 2
    )
  }
}
