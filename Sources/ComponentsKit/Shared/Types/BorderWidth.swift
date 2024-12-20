import Foundation

/// An enumeration that defines border thickness for components.
public enum BorderWidth: Hashable {
  /// A small border width.
  case small
  /// A medium border width.
  case medium
  /// A large border width.
  case large
}

extension BorderWidth {
  /// The numeric value of the border width as a `CGFloat`.
  public var value: CGFloat {
    switch self {
    case .small:
      return ComponentsKitConfig.shared.layout.borderWidth.small
    case .medium:
      return ComponentsKitConfig.shared.layout.borderWidth.medium
    case .large:
      return ComponentsKitConfig.shared.layout.borderWidth.large
    }
  }
}
