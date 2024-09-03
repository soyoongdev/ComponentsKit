import Foundation

public struct ComponentColor: Equatable {
  // MARK: Properties

  let main: ThemeColor
  let contrast: ThemeColor

  // MARK: Initialization

  public init(main: ThemeColor, contrast: ThemeColor) {
    self.main = main
    self.contrast = contrast
  }
}
