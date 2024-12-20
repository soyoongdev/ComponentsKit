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

  // MARK: Fonts

  public struct FontSet {
    public var small: UniversalFont
    public var medium: UniversalFont
    public var large: UniversalFont

    public init(small: UniversalFont, medium: UniversalFont, large: UniversalFont) {
      self.small = small
      self.medium = medium
      self.large = large
    }
  }

  public struct Typography {
    public var headline: FontSet
    public var body: FontSet
    public var button: FontSet
    public var caption: FontSet

    public init(headline: FontSet, body: FontSet, button: FontSet, caption: FontSet) {
      self.headline = headline
      self.body = body
      self.button = button
      self.caption = caption
    }
  }

  // MARK: Properties

  public var disabledOpacity: CGFloat = 0.5
  public var componentRadius: Radius = .init(
    small: 10.0,
    medium: 12.0,
    large: 16.0
  )
  public var borderWidth: BorderWidth = .init(
    small: 1.0,
    medium: 2.0,
    large: 3.0
  )
  public var animationScale: AnimationScale = .init(
    small: 0.99,
    medium: 0.98,
    large: 0.95
  )
  public var typography: Typography = .init(
    headline: .init(
      small: .system(size: 14, weight: .semibold),
      medium: .system(size: 20, weight: .semibold),
      large: .system(size: 28, weight: .semibold)
    ),
    body: .init(
      small: .system(size: 14, weight: .regular),
      medium: .system(size: 16, weight: .regular),
      large: .system(size: 18, weight: .regular)
    ),
    button: .init(
      small: .system(size: 14, weight: .medium),
      medium: .system(size: 16, weight: .medium),
      large: .system(size: 20, weight: .medium)
    ),
    caption: .init(
      small: .system(size: 10, weight: .regular),
      medium: .system(size: 12, weight: .regular),
      large: .system(size: 14, weight: .regular)
    )
  )

  public init() {}
}
