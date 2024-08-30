import UIKit

public final class ContentSizedScrollView: UIScrollView {
  public override var contentSize: CGSize {
    didSet {
      invalidateIntrinsicContentSize()
    }
  }

  public override var intrinsicContentSize: CGSize {
    layoutIfNeeded()
    return CGSize(width: UIView.noIntrinsicMetric, height: self.contentSize.height)
  }
}
