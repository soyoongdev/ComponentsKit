import Foundation

public struct RadioItemVM<ID: Hashable> {
  public var id: ID

  public var title: String = ""

  public var font: UniversalFont?

  public var isEnabled: Bool = true

  public init(id: ID) {
    self.id = id
  }

  public init(id: ID, _ transform: (_ value: inout Self) -> Void) {
    var defaultValue = Self(id: id)
    transform(&defaultValue)
    self = defaultValue
  }
}

extension RadioItemVM: Equatable, Identifiable {}
