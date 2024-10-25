import Foundation

public struct ComponentsKitConfig: Initializable, Updatable {
  public var colors: Palette = .init()
  public var layout: Layout = .init()

  public init() {}
}

// MARK: - ComponentsKitConfig + Shared

extension ComponentsKitConfig {
  public static var shared: Self = .init()
}
