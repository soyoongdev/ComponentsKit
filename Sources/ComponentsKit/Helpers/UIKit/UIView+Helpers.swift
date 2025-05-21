#if canImport(UIKit)
import UIKit

extension UIView {
  /// Whether the view is visible.
  var isVisible: Bool {
    get {
      return !self.isHidden
    }
    set {
      self.isHidden = !newValue
    }
  }
}

extension UIView {
  /// A helper to get bounds of the device's screen.
  public var screenBounds: CGRect {
#if os(visionOS)
    return self.window?.bounds ?? .zero
#else
    return self.window?.windowScene?.screen.bounds
    ?? UIScreen.main.bounds
#endif
  }
}
#endif
