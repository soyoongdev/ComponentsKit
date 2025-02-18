import Foundation

/// A configuration structure for customizing colors and layout attributes of the components.
public struct ComponentsKitConfig: Initializable, Updatable, Equatable {
  // MARK: - Properties

  /// The palette of colors.
  public var colors: Palette = .init()

  /// The layout configuration.
  public var layout: Layout = .init()

  // MARK: - Initialization

  /// Initializes a new `ComponentsKitConfig` instance with default values.
  public init() {}
}

// MARK: - ComponentsKitConfig + Shared

extension ComponentsKitConfig {
  /// A shared instance of `ComponentsKitConfig` for global use.
  public static var shared: Self = .init()
}
