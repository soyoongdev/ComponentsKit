public protocol Updatable {
  func updating(_ transform: (_ value: inout Self) -> Void) -> Self
  mutating func update(_ transform: (_ value: inout Self) -> Void)
}

extension Updatable {
  public func updating(_ transform: (_ value: inout Self) -> Void) -> Self {
    var copy = self
    transform(&copy)
    return copy
  }
  public mutating func update(_ transform: (_ value: inout Self) -> Void) {
    self = self.updating(transform)
  }
}
