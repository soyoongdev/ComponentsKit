import UIKit

/// A model that defines the appearance properties for a text input component.
public struct CellVM {
  
  // MARK: - Properties
  
  /// The direction of the grid layout.
  /// Defaults to `.vertical`.
  public var cellClass: AnyClass?
  
  public var nib: UINib?
  
  public var forCellWithReuseIdentifier: String?
  
  /// Initializes a new instance of `GridVM` with default values.
  public init() {}
}
