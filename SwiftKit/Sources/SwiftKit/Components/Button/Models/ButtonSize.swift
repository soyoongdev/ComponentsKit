import Foundation

public struct ButtonSize: Equatable {
  public enum Width: Equatable {
    case dynamic(leadingInset: CGFloat, trailingInset: CGFloat)
    case constant(CGFloat)
  }
  public enum Height: Equatable {
    case dynamic(topInset: CGFloat, bottomInset: CGFloat)
    case constant(CGFloat)
  }

  let width: Width
  let height: Height

  public var fullWidth: Self {
    return .init(width: .constant(.infinity), height: self.height)
  }
}

extension ButtonSize {
  public static var small: Self {
    return .init(
      width: .dynamic(leadingInset: 8, trailingInset: 8),
      height: .constant(36)
    )
  }
  public static var medium: Self {
    return .init(
      width: .dynamic(leadingInset: 12, trailingInset: 12),
      height: .constant(50)
    )
  }
  public static var large: Self {
    return .init(
      width: .dynamic(leadingInset: 16, trailingInset: 16),
      height: .constant(70)
    )
  }
  public static func custom(width: Width, height: Height) -> Self {
    let maxSideValue: CGFloat = 10_000

    let adaptedWidth: Width
    switch width {
    case .constant(let value) where value < 0:
      adaptedWidth = .constant(0)
    case .constant(let value) where value > maxSideValue:
      adaptedWidth = .constant(maxSideValue)
    case .constant, .dynamic:
      adaptedWidth = width
    }

    let adaptedHeight: Height
    switch height {
    case .constant(let value) where value < 0:
      adaptedHeight = .constant(0)
    case .constant(let value) where value > maxSideValue:
      adaptedHeight = .constant(maxSideValue)
    case .constant, .dynamic:
      adaptedHeight = height
    }

    return .init(width: adaptedWidth, height: adaptedHeight)
  }
}
