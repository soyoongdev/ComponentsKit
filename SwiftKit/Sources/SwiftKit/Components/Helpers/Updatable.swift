public protocol Updatable {
  init()
  init(_ transform: (_ value: inout Self) -> Void)
  func updating(_ transform: (_ value: inout Self) -> Void) -> Self
  mutating func update(_ transform: (_ value: inout Self) -> Void)
}

extension Updatable {
  public init(_ transform: (_ value: inout Self) -> Void) {
    var defaultValue = Self()
    transform(&defaultValue)
    self = defaultValue
  }
  public func updating(_ transform: (_ value: inout Self) -> Void) -> Self {
    var copy = self
    transform(&copy)
    return copy
  }
  public mutating func update(_ transform: (_ value: inout Self) -> Void) {
    self = self.updating(transform)
  }
}
