import Foundation

/// A model that defines the appearance properties for a bottom modal component.
public struct BottomModalVM: ModalVM {
  public var isDraggable: Bool = true
  public var hidesOnSwap: Bool = true

  /// Initializes a new instance of `ModalVM` with default values.
  public init() {}
}
