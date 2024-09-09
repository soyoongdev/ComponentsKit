public protocol ComponentVM: Equatable, Updatable {
  init()
  init(_ transform: (_ value: inout Self) -> Void)
}

extension ComponentVM {
  public init(_ transform: (_ value: inout Self) -> Void) {
    var defaultValue = Self()
    transform(&defaultValue)
    self = defaultValue
  }
}
