import Foundation

/// Defines shadow options for components.
public enum Shadow: Hashable {
  /// No shadow is applied.
  case none
  /// A small shadow.
  case small
  /// A medium shadow.
  case medium
  /// A large shadow.
  case large
  /// A custom shadow with specific parameters.
  ///
  /// - Parameters:
  ///   - radius: The blur radius of the shadow.
  ///   - offset: The offset of the shadow.
  ///   - color: The color of the shadow.
  case custom(_ radius: CGFloat, _ offset: CGSize, _ color: UniversalColor)
}

extension Shadow {
  var radius: CGFloat {
    return switch self {
    case .none: CGFloat(0)
    case .small: ComponentsKitConfig.shared.layout.shadow.small.radius
    case .medium: ComponentsKitConfig.shared.layout.shadow.medium.radius
    case .large: ComponentsKitConfig.shared.layout.shadow.large.radius
    case .custom(let radius, _, _): radius
    }
  }

  var offset: CGSize {
    return switch self {
    case .none: .zero
    case .small: ComponentsKitConfig.shared.layout.shadow.small.offset
    case .medium: ComponentsKitConfig.shared.layout.shadow.medium.offset
    case .large: ComponentsKitConfig.shared.layout.shadow.large.offset
    case .custom(_, let offset, _): offset
    }
  }

  var color: UniversalColor {
    return switch self {
    case .none: .clear
    case .small: ComponentsKitConfig.shared.layout.shadow.small.color
    case .medium: ComponentsKitConfig.shared.layout.shadow.medium.color
    case .large: ComponentsKitConfig.shared.layout.shadow.large.color
    case .custom(_, _, let color): color
    }
  }
}
