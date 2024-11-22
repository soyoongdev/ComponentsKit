import Foundation

public struct RadioGroupVM<ID: Hashable> {
  public var color: UniversalColor

  public var font: UniversalFont?

  public var isEnabled: Bool

  public var items: [RadioItemVM<ID>]

  public var size: ComponentSize

  public init(
    color: UniversalColor = .primary,
    font: UniversalFont? = nil,
    isEnabled: Bool = true,
    items: [RadioItemVM<ID>],
    size: ComponentSize = .medium
  ) {
    self.color = color
    self.font = font
    self.isEnabled = isEnabled
    self.items = items
    self.size = size
  }
}
