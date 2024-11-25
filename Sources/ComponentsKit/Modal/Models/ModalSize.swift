import Foundation

public enum ModalSize {
  case small
  case medium
  case large
  case full
}

extension ModalSize {
  public var maxWidth: CGFloat {
    switch self {
    case .small:
      return 300
    case .medium:
      return 400
    case .large:
      return 600
    case .full:
      return 10_000
    }
  }
}
