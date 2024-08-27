// Copyright © SwiftKit. All rights reserved.

import Foundation

public struct SwiftKitConfig {
  let colors: AppColors

  public init(colors: AppColors) {
    self.colors = colors
  }
}

// MARK: - SwiftKitConfig + Shared

extension SwiftKitConfig {
  public static var shared: Self = .default
}

// MARK: - SwiftKitConfig + Default

extension SwiftKitConfig {
  public static var `default`: Self = .init(
    colors: .default
  )
}
