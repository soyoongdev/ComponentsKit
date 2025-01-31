import SwiftUI

/// A model that defines the appearance properties for a circular progress component.
public struct CircularProgressVM: ComponentVM {
  /// The color of the circular progress indicator.
  ///
  /// Defaults to `.accent`.
  public var color: ComponentColor = .accent

  /// The style of the circular progress indicator.
  ///
  /// Defaults to `.light`.
  public var style: Style = .light

  /// The predefined size of the circular progress indicator.
  ///
  /// Defaults to `.medium`.
  public var size: ComponentSize = .medium

  /// The minimum value for the progress range.
  ///
  /// Defaults to `0`.
  public var minValue: CGFloat = 0

  /// The maximum value for the progress range.
  ///
  /// Defaults to `100`.
  public var maxValue: CGFloat = 100

  /// The width of the circular progress stroke.
  ///
  /// If not provided, the line width is automatically adjusted based on the size.
  public var lineWidth: CGFloat?

  /// An optional label to display inside the circular progress.
  public var label: String?

  /// A custom font to display the label with.
  ///
  /// If not provided, the font is automatically adjusted based on the size.
  public var font: UniversalFont?

  /// Initializes a new instance of `CircularProgressVM` with default values.
  public init() {}
}

// MARK: - Helpers

extension CircularProgressVM {
  var circularLineWidth: CGFloat {
    return self.lineWidth ?? max(self.preferredSize.width / 8, 2)
  }
  var preferredSize: CGSize {
    switch self.size {
    case .small:
      return CGSize(width: 36, height: 36)
    case .medium:
      return CGSize(width: 48, height: 48)
    case .large:
      return CGSize(width: 50, height: 50)
    }
  }
  var radius: CGFloat {
    return self.preferredSize.height / 2 - self.circularLineWidth / 2
  }
  var center: CGPoint {
    return .init(
      x: self.preferredSize.width / 2,
      y: self.preferredSize.height / 2
    )
  }
  var titleFont: UniversalFont {
    if let font {
      return font
    }
    switch self.size {
    case .small:
      return .smBody
    case .medium:
      return .mdBody
    case .large:
      return .lgBody
    }
  }
  public func progress(for currentValue: CGFloat) -> CGFloat {
    let range = self.maxValue - self.minValue
    guard range > 0 else { return 0 }
    let normalized = (currentValue - self.minValue) / range
    return max(0, min(1, normalized))
  }
}
