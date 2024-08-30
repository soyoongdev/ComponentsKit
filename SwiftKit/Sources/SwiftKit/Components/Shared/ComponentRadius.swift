import Foundation

public enum ComponentRadius {
  case none
  case small
  case medium
  case large
  case full
  case custom(CGFloat)

  func value(for height: CGFloat) -> CGFloat {
    switch self {
    case .none:
      return 0
    case .small:
      return SwiftKitConfig.shared.layout.componentRadius.small
    case .medium:
      return SwiftKitConfig.shared.layout.componentRadius.medium
    case .large:
      return SwiftKitConfig.shared.layout.componentRadius.large
    case .full:
      return height / 2
    case .custom(let value):
      return value
    }
  }
}
