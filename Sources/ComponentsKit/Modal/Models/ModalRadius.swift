import Foundation

public enum ModalRadius: Hashable {
  case none
  case small
  case medium
  case large
  case custom(CGFloat)
}

extension ModalRadius {
  var value: CGFloat {
    return switch self {
    case .none: CGFloat(0)
    case .small: ComponentsKitConfig.shared.layout.modalRadius.small
    case .medium: ComponentsKitConfig.shared.layout.modalRadius.medium
    case .large: ComponentsKitConfig.shared.layout.modalRadius.large
    case .custom(let value): value
    }
  }
}
