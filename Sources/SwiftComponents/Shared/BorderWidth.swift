import Foundation

public struct BorderWidth: Hashable {
  var value: CGFloat

  init(_ value: CGFloat) {
    self.value = value
  }
}

extension BorderWidth {
  public static var small: Self {
    return Self(SwiftComponentsConfig.shared.layout.borderWidth.small)
  }
  public static var medium: Self {
    return Self(SwiftComponentsConfig.shared.layout.borderWidth.medium)
  }
  public static var large: Self {
    return Self(SwiftComponentsConfig.shared.layout.borderWidth.large)
  }
  public static func custom(_ value: CGFloat) -> Self {
    return Self(value)
  }
}
