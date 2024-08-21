// Copyright © SwiftKit. All rights reserved.

import Foundation

public enum ButtonSize {
  case small
  case medium
  case large
  case custom(CGSize)

  public var height: CGFloat {
    switch self {
    case .small:
      return 36
    case .medium:
      return 50
    case .large:
      return 70
    case .custom(let size):
      return size.height
    }
  }

  public var horizontalPadding: CGFloat {
    switch self {
    case .small:
      return 8
    case .medium:
      return 12
    case .large:
      return 16
    case .custom(let size):
      return 0
    }
  }
}
