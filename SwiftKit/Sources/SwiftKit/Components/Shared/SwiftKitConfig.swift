// Copyright © SwiftKit. All rights reserved.

import Foundation

public struct SwiftKitConfig {
  public var colors: AppColors
  public var layout: Layout
}

// MARK: - SwiftKitConfig + Shared

extension SwiftKitConfig {
  public static var shared: Self = .default
}

// MARK: - SwiftKitConfig + Default

extension SwiftKitConfig {
  fileprivate static var `default`: Self = .init(
    colors: .default,
    layout: .default
  )
}

// MARK: SwiftKitConfig + Extending

extension SwiftKitConfig {
  public func extending(
    _ transform: ( _ config: inout Self) -> Void
  ) -> Self {
    var instance = self
    transform(&instance)
    return instance
  }

  public static func extendingDefault(
    _ transform: ( _ config: inout Self) -> Void
  ) -> Self {
    return Self.default.extending(transform)
  }
}
