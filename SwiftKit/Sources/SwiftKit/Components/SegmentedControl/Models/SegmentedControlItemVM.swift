import Foundation

public struct SegmentedControlItemVM: ComponentVM {
  public var title: String = ""
  public var font: Typography?
  public var isEnabled: Bool = true

  public init() {}
}
