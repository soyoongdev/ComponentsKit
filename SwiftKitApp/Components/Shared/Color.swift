// Copyright © SwiftKit. All rights reserved.

import UIKit

public enum Color {
  case primary
  case secondary
  case accent
  case success
  case warning
  case danger

  public var uiColor: UIColor {
    switch self {
    case .primary:
      return .label
    case .secondary:
      return .secondaryLabel
    case .accent:
      return .systemBlue
    case .success:
      return .systemGreen
    case .warning:
      return .systemOrange
    case .danger:
      return .systemRed
    }
  }
}
