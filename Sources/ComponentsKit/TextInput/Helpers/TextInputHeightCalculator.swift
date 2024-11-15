import UIKit

struct TextInputHeightCalculator {
  private static let textView = UITextView()

  private init() {}

  static func height(
    for text: String,
    model: TextInputVM,
    width: CGFloat
  ) -> CGFloat {
    self.textView.text = text
    self.style(self.textView, with: model)

    let targetSize = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
    let estimatedHeight = self.textView.sizeThatFits(targetSize).height

    return estimatedHeight
  }

  private static func style(_ textView: UITextView, with model: TextInputVM) {
    self.textView.isScrollEnabled = false
    self.textView.font = model.preferredFont.uiFont
    self.textView.textContainerInset = .init(
      top: model.contentPadding,
      left: model.contentPadding,
      bottom: model.contentPadding,
      right: model.contentPadding
    )
    self.textView.textContainer.lineFragmentPadding = 0
  }
}
