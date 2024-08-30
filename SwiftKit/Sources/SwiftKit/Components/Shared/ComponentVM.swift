public protocol ComponentVM {
  init()
  init(_ transform: (_ model: inout Self) -> Void)
  func updating(_ transform: (_ model: inout Self) -> Void) -> Self
  mutating func update(_ transform: (_ model: inout Self) -> Void)
}

extension ComponentVM {
  public init(_ transform: (_ model: inout Self) -> Void) {
    var defaultValue = Self()
    transform(&defaultValue)
    self = defaultValue
  }
  public func updating(_ transform: (_ model: inout Self) -> Void) -> Self {
    var copy = self
    transform(&copy)
    return copy
  }
  public mutating func update(_ transform: (_ model: inout Self) -> Void) {
    self = self.updating(transform)
  }
}
