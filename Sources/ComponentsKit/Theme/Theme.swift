import Foundation

/// A predefined set of colors and layout attributes that ensure visual consistency across the
/// application.
public struct Theme: Initializable, Updatable, Equatable {
  // MARK: - Properties

  /// The palette of colors.
  public var colors: Palette = .init()

  /// The layout configuration.
  public var layout: Layout = .init()

  // MARK: - Initialization

  /// Initializes a new `Theme` instance with default values.
  public init() {}
}

// MARK: - Theme + Shared

extension Theme {
  /// A current instance of `Theme` for global use.
  public static var current: Self = .init()
}
