import Foundation

public struct SwiftKitConfig: Updatable {
  public var colors: Palette = .init()
  public var layout: Layout = .init()

  public init() {}
}

// MARK: - SwiftKitConfig + Shared

extension SwiftKitConfig {
  public static var shared: Self = .init()
}
