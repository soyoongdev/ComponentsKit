import Foundation

public struct ComponentColor {
  // MARK: Properties

  let main: Color
  let contrast: Color

  // MARK: Initialization

  public init(main: Color, contrast: Color) {
    self.main = main
    self.contrast = contrast
  }
}
