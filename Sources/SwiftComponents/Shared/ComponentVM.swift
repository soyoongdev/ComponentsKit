/// A protocol that defines a component view model.
public protocol ComponentVM: Equatable, Updatable {

  /// Initializes a new instance with default values.
  init()

  /// Initializes a new instance by applying a transformation closure to the default values.
  ///
  /// - Parameter transform: A closure that defines the transformation.
  init(_ transform: (_ value: inout Self) -> Void)
}

extension ComponentVM {
  /// Initializes a new instance by applying a transformation closure to the default values.
  ///
  /// This default implementation creates a new instance using the default initializer and applies
  /// the provided transformation closure to the new instance.
  ///
  /// - Parameter transform: A closure that defines the transformation.
  public init(_ transform: (_ value: inout Self) -> Void) {
    var defaultValue = Self()
    transform(&defaultValue)
    self = defaultValue
  }
}
