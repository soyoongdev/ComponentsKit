// Copyright © SwiftKit. All rights reserved.

import Foundation

public enum AnimationScale {
  case none
  case small
  case medium
  case large

  public var coef: CGFloat {
    switch self {
    case .none:
      return 1
    case .small:
      return 0.99
    case .medium:
      return 0.98
    case .large:
      return 0.95
    }
  }
}
