import Foundation

public struct AnimationScale: Hashable {
  var value: CGFloat

  init(_ value: CGFloat) {
    self.value = value
  }
}

extension AnimationScale {
  public static var none: Self {
    return Self(1.0)
  }
  public static var small: Self {
    return Self(SwiftKitConfig.shared.layout.animationScale.small)
  }
  public static var medium: Self {
    return Self(SwiftKitConfig.shared.layout.animationScale.medium)
  }
  public static var large: Self {
    return Self(SwiftKitConfig.shared.layout.animationScale.large)
  }
  public static func custom(_ value: CGFloat) -> Self {
    guard value >= 0 && value <= 1.0 else {
      fatalError("Animation scale value should be between 0 and 1")
    }
    return Self(value)
  }
}
