import Foundation

public struct Layout: Initializable, Updatable {
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

  // MARK: Font

  public struct Font {
    public var small: UniversalFont
    public var medium: UniversalFont
    public var large: UniversalFont

    public init(small: UniversalFont, medium: UniversalFont, large: UniversalFont) {
      self.small = small
      self.medium = medium
      self.large = large
    }
  }

  // MARK: Properties

  public var animationScale: AnimationScale = .init(
    small: 0.99,
    medium: 0.98,
    large: 0.95
  )
  public var borderWidth: BorderWidth = .init(
    small: 1.0,
    medium: 2.0,
    large: 3.0
  )
  public var componentFont: Font = .init(
    small: .system(size: 14, weight: .regular),
    medium: .system(size: 18, weight: .regular),
    large: .system(size: 22, weight: .regular)
  )
  public var componentRadius: Radius = .init(
    small: 10.0,
    medium: 14.0,
    large: 18.0
  )
  public var disabledOpacity: CGFloat = 0.5
  public var modalRadius: Radius = .init(
    small: 16.0,
    medium: 20.0,
    large: 26.0
  )

  public init() {}
}
