import Foundation

public struct RadioItemVM<ID: Hashable>: Identifiable {
  public var id: ID

  public var title: String

  public var font: UniversalFont?

  public var isEnabled: Bool

  public init(id: ID, title: String, font: UniversalFont? = nil, isEnabled: Bool = true) {
    self.id = id
    self.title = title
    self.font = font
    self.isEnabled = isEnabled
  }
}
