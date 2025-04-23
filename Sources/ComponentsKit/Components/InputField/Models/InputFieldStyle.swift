import Foundation

extension InputFieldVM {
  /// The input fields appearance style.
  public enum Style: Hashable {
    /// An input field with a partially transparent background.
    case light
    /// An input field with a transparent background and a border.
    case bordered
    /// An input field with a partially transparent background and a border.
    case faded
  }
}
