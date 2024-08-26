// Copyright © SwiftKit. All rights reserved.

import Foundation

public enum LoadingSize {
  case small
  case medium
  case large
  case custom(CGSize)

  public var cgSize: CGSize {
    switch self {
    case .small:
      return .init(width: 24, height: 24)
    case .medium:
      return .init(width: 36, height: 36)
    case .large:
      return .init(width: 48, height: 48)
    case .custom(let size):
      let minSide = min(size.height, size.width)
      return .init(width: minSide, height: minSide)
    }
  }

  public var lineWidth: CGFloat {
    return max(self.cgSize.width / 8, 2)
  }
}
