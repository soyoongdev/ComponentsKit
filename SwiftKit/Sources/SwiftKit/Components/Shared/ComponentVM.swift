protocol ComponentVM {
  init()
  init(_ transform: (_ model: inout Self) -> Void)
  func updating(_ transform: (_ model: inout Self) -> Void) -> Self
  mutating func update(_ transform: (_ model: inout Self) -> Void)
}

extension ComponentVM {
  init(_ transform: (_ model: inout Self) -> Void) {
    var defaultValue = Self()
    transform(&defaultValue)
    self = defaultValue
  }
  func updating(_ transform: (_ model: inout Self) -> Void) -> Self {
    var copy = self
    transform(&copy)
    return copy
  }
  mutating func update(_ transform: (_ model: inout Self) -> Void) {
    self = self.updating(transform)
  }
}
