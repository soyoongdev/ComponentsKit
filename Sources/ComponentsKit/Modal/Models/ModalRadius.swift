import Foundation

/// Defines the corner radius options for a modal's content area.
public enum ModalRadius: Hashable {
  /// No corner radius is applied, resulting in sharp edges.
  case none
  /// A small corner radius is applied.
  case small
  /// A medium corner radius is applied.
  case medium
  /// A large corner radius is applied.
  case large
  /// A custom corner radius specified by a `CGFloat` value.
  ///
  /// - Parameter value: The custom radius value to be applied.
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
