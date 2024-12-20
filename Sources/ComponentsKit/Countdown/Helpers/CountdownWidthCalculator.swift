import UIKit

struct CountdownWidthCalculator {
  private static let label = UILabel()

  private init() {}

  static func preferredWidth(
    for attributedText: NSAttributedString,
    model: CountdownVM
  ) -> CGFloat {
    self.style(label, with: model)
    label.attributedText = attributedText

    let targetSize = CGSize(width: CGFloat.greatestFiniteMagnitude, height: model.height)
    let estimatedSize = label.sizeThatFits(targetSize)

    return estimatedSize.width
  }

  private static func style(_ label: UILabel, with model: CountdownVM) {
    label.numberOfLines = 0
  }
}
