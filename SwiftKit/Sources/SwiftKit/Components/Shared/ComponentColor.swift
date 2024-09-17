import Foundation

public struct ComponentColor: Hashable {
  // MARK: Properties

  let main: UniversalColor
  let contrast: UniversalColor

  // MARK: Initialization

  public init(main: UniversalColor, contrast: UniversalColor) {
    self.main = main
    self.contrast = contrast
  }
}
