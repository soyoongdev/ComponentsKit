// Copyright © SwiftKit. All rights reserved.

import Foundation

public enum Radius {
  case none
  case small
  case medium
  case large
  case full

  public var coef: CGFloat {
    switch self {
    case .none:
      return 0
    case .small:
      return 0.15
    case .medium:
      return 0.25
    case .large:
      return 0.35
    case .full:
      return 0.5
    }
  }
}
