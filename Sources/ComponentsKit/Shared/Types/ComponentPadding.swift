import Foundation

/// An enumeration that defines alignment options for a component.
public enum ComponentPadding: Hashable {
  /// The alignment options for a component.
  case none
  
  /// A small padding around the component.
  case small
  
  /// A medium padding around the component.
  case medium
  
  /// A large padding around the component.
  case large
  
  /// A custom padding with a specific value.
  /// - Parameter value: The padding value as a `CGFloat`.
  case custom(CGFloat)
}
