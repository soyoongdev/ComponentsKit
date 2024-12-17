import Foundation

public struct ComponentColor: Hashable {
  // MARK: Properties

  public let main: UniversalColor
  public let contrast: UniversalColor
  public let background: UniversalColor

  // MARK: Initialization

  public init(
    main: UniversalColor,
    contrast: UniversalColor,
    background: UniversalColor? = nil
  ) {
    self.main = main
    self.contrast = contrast
    self.background = background ?? main.withOpacity(0.15)
  }
}
