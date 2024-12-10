import Foundation

extension ButtonVM {
  /// The buttons appearance style.
  public enum Style: Hashable {
    /// A button with a filled background.
    case filled
    /// A button with a transparent background.
    case plain
    /// A button with a transparent background and a border.
    case bordered(BorderWidth)
  }
}
