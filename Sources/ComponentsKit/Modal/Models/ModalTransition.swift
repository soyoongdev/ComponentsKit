import Foundation

public struct ModalTransition: Hashable {
  var value: TimeInterval

  init(_ value: CGFloat) {
    self.value = value
  }
}

extension ModalTransition {
  public static var none: Self {
    return Self(0.0)
  }
  public static var slow: Self {
    return Self(0.5)
  }
  public static var normal: Self {
    return Self(0.3)
  }
  public static var fast: Self {
    return Self(0.2)
  }
  public static func custom(_ value: CGFloat) -> Self {
    return Self(value)
  }
}
