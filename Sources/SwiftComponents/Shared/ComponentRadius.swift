import Foundation
import SwiftUI

public enum ComponentRadius: Hashable {
  case none
  case small
  case medium
  case large
  case full
  case custom(CGFloat)
}

extension ComponentRadius {
  func value(for height: CGFloat = 10_000) -> CGFloat {
    let maxValue = height / 2
    let value = switch self {
    case .none: CGFloat(0)
    case .small: SwiftComponentsConfig.shared.layout.componentRadius.small
    case .medium: SwiftComponentsConfig.shared.layout.componentRadius.medium
    case .large: SwiftComponentsConfig.shared.layout.componentRadius.large
    case .full: height / 2
    case .custom(let value): value
    }
    return min(value, maxValue)
  }
}
