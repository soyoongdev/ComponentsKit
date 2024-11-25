import Foundation

public struct Paddings: Hashable {
  public var top: CGFloat
  public var leading: CGFloat
  public var bottom: CGFloat
  public var trailing: CGFloat

  public init(top: CGFloat, leading: CGFloat, bottom: CGFloat, trailing: CGFloat) {
    self.top = top
    self.leading = leading
    self.bottom = bottom
    self.trailing = trailing
  }

  public init(horizontal: CGFloat, vertical: CGFloat) {
    self.top = vertical
    self.leading = horizontal
    self.bottom = vertical
    self.trailing = horizontal
  }

  public init(padding: CGFloat) {
    self.top = padding
    self.leading = padding
    self.bottom = padding
    self.trailing = padding
  }
}
