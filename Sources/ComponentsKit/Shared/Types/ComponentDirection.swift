import Foundation

/// An enumeration that defines the direction or style of a component.
public enum ComponentDirection: Hashable {
  /// A button with a vertical layout, typically used for stacked items or buttons.
  case vertical
  /// A button with a horizontal layout, typically used for icons or segmented controls.
  case horizontal(Int)
}

extension ComponentDirection {
  /// Returns the number of items in the horizontal direction if applicable.
  /// If the direction is vertical, it returns `nil`.
  public var columns: Int {
    let cols = switch self {
    case .vertical: 1
    case .horizontal(let count): count
    }
    return cols
  }
}
