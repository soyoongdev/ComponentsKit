import Foundation

public struct Layout {
  // MARK: Radius

  public struct Radius {
    public var small: CGFloat
    public var medium: CGFloat
    public var large: CGFloat

    public init(small: CGFloat, medium: CGFloat, large: CGFloat) {
      self.small = small
      self.medium = medium
      self.large = large
    }
  }

  // MARK: BorderWidth

  public struct BorderWidth {
    public var small: CGFloat
    public var medium: CGFloat
    public var large: CGFloat

    public init(small: CGFloat, medium: CGFloat, large: CGFloat) {
      self.small = small
      self.medium = medium
      self.large = large
    }
  }

  // MARK: AnimationScale

  public struct AnimationScale {
    public var small: CGFloat
    public var medium: CGFloat
    public var large: CGFloat

    public init(small: CGFloat, medium: CGFloat, large: CGFloat) {
      guard small >= 0 && small <= 1.0,
            medium >= 0 && medium <= 1.0,
            large >= 0 && large <= 1.0
      else {
        fatalError("Animation scale values should be between 0 and 1")
      }

      self.small = small
      self.medium = medium
      self.large = large
    }
  }

  // MARK: Properties

  public var disabledOpacity: CGFloat
  public var popoverRadius: Radius
  public var componentRadius: Radius
  public var borderWidth: BorderWidth
  public var animationScale: AnimationScale
}

// MARK: - Layout + Default

extension Layout {
  static let `default`: Self = .init(
    disabledOpacity: 0.5,
    popoverRadius: .init(
      small: 15.0,
      medium: 20.0,
      large: 25.0
    ),
    componentRadius: .init(
      small: 8.0,
      medium: 12.0,
      large: 16.0
    ),
    borderWidth: .init(
      small: 1.0,
      medium: 2.0,
      large: 3.0
    ),
    animationScale: .init(
      small: 0.99,
      medium: 0.98,
      large: 0.95
    )
  )
}

// MARK: Layout + Extending

extension Layout {
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
