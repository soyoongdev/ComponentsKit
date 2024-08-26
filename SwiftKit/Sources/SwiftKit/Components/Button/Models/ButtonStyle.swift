// Copyright © SwiftKit. All rights reserved.

import Foundation

public enum ButtonStyle {
  public enum BorderSize {
    case small
    case medium
    case large
    case custom(CGFloat)
  }

  case filled
  case plain
  case bordered(BorderSize)
}
