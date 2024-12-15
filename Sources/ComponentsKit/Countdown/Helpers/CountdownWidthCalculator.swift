import UIKit

struct CountdownWidthCalculator {
  private static let label = UILabel()

  private init() {}

  static func preferredWidth(
    for text: String,
    model: CountdownVM
  ) -> CGFloat {
    self.style(self.label, with: model)
    self.label.text = text

    let targetSize = CGSize(width: CGFloat.greatestFiniteMagnitude, height: model.height)
    let estimatedSize = self.label.sizeThatFits(targetSize)

    return estimatedSize.width
  }

  private static func style(_ label: UILabel, with model: CountdownVM) {
    label.font = model.preferredFont.uiFont
    label.numberOfLines = 0
  }
}
