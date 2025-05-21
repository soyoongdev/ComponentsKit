#if canImport(UIKit)
import UIKit

struct AlertButtonsOrientationCalculator {
  enum Orientation {
    case vertical
    case horizontal
  }

  private static let primaryButton = UKButton(model: .init())
  private static let secondaryButton = UKButton(model: .init())

  private init() {}

  static func preferredOrientation(model: AlertVM) -> Orientation {
    guard let primaryButtonVM = model.primaryButtonVM,
          let secondaryButtonVM = model.secondaryButtonVM else {
      return .vertical
    }

    self.primaryButton.model = primaryButtonVM.updating {
      $0.isFullWidth = false
    }
    self.secondaryButton.model = secondaryButtonVM.updating {
      $0.isFullWidth = false
    }

    let primaryButtonWidth = self.primaryButton.intrinsicContentSize.width
    let secondaryButtonWidth = self.secondaryButton.intrinsicContentSize.width

    // Since the `maxWidth` of the alert is always less than the width of the
    // screen, we can assume that the width of the container is equal to this
    // `maxWidth` value.
    let containerWidth = model.modalVM.size.maxWidth
    let availableButtonsWidth = containerWidth
    - AlertVM.buttonsSpacing
    - model.contentPaddings.leading
    - model.contentPaddings.trailing
    let availableButtonWidth = availableButtonsWidth / 2

    if primaryButtonWidth <= availableButtonWidth,
       secondaryButtonWidth <= availableButtonWidth {
      return .horizontal
    } else {
      return .vertical
    }
  }
}
#endif
