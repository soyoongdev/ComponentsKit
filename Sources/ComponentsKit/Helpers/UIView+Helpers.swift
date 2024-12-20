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
