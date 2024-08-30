import Foundation

public struct PopoverRadius {
  var value: CGFloat

  init(_ value: CGFloat) {
    self.value = value
  }
}

extension PopoverRadius {
  public static var none: Self {
    return Self(0)
  }
  public static var small: Self {
    return Self(SwiftKitConfig.shared.layout.popoverRadius.small)
  }
  public static var medium: Self {
    return Self(SwiftKitConfig.shared.layout.popoverRadius.medium)
  }
  public static var large: Self {
    return Self(SwiftKitConfig.shared.layout.popoverRadius.large)
  }
  public static func custom(_ value: CGFloat) -> Self {
    return Self(value)
  }
}
