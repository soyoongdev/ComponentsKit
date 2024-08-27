// Copyright © SwiftKit. All rights reserved.

import Foundation

public struct BorderWidth {
  var value: CGFloat

  init(_ value: CGFloat) {
    self.value = value
  }
}

extension BorderWidth {
  public static var small: Self {
    return Self(SwiftKitConfig.shared.layout.borderWidth.small)
  }
  public static var medium: Self {
    return Self(SwiftKitConfig.shared.layout.borderWidth.medium)
  }
  public static var large: Self {
    return Self(SwiftKitConfig.shared.layout.borderWidth.large)
  }
  public static func custom(_ value: CGFloat) -> Self {
    return Self(value)
  }
}
