import UIKit

// TODO: [1] Fix, it does not work properly
public final class ContentSizedScrollView: UIScrollView {
  public override var contentSize: CGSize {
    didSet {
      self.invalidateIntrinsicContentSize()
    }
  }

  public override var intrinsicContentSize: CGSize {
    self.layoutIfNeeded()
    return CGSize(
      width: UIView.noIntrinsicMetric,
      height: self.contentSize.height
    )
  }
}
