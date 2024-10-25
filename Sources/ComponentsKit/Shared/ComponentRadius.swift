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
    case .small: ComponentsKitConfig.shared.layout.componentRadius.small
    case .medium: ComponentsKitConfig.shared.layout.componentRadius.medium
    case .large: ComponentsKitConfig.shared.layout.componentRadius.large
    case .full: height / 2
    case .custom(let value): value
    }
    return min(value, maxValue)
  }
}
