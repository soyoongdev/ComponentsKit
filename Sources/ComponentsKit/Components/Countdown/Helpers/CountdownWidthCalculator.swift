import UIKit

struct CountdownWidthCalculator {
  private static let label = UILabel()

  private init() {}

  static func preferredWidth(
    for attributedText: NSAttributedString,
    model: CountdownVM
  ) -> CGFloat {
    self.style(self.label, with: model)
    self.label.attributedText = attributedText

    let estimatedSize = self.label.sizeThatFits(UIView.layoutFittingExpandedSize)

    return estimatedSize.width + 2
  }

  private static func style(_ label: UILabel, with model: CountdownVM) {
    label.textAlignment = .center
    label.numberOfLines = 0
  }
}
