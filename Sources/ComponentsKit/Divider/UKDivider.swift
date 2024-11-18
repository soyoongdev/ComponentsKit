import UIKit

open class UKDivider: UIView, UKComponent {
  public var model: DividerVM {
    didSet {
      self.update(oldValue)
    }
  }

  public init(model: DividerVM = .init()) {
    self.model = model
    super.init(frame: .zero)
    self.setup()
  }

  public required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func setup() {
    self.backgroundColor = self.model.color.uiColor
  }

  public func update(_ oldModel: DividerVM) {
    guard self.model != oldModel else { return }

    self.backgroundColor = self.model.color.uiColor

    if self.model.orientation != oldModel.orientation || self.model.size != oldModel.size {
      self.invalidateIntrinsicContentSize()
    }

    self.setNeedsLayout()
  }

  open override func layoutSubviews() {
    super.layoutSubviews()
  }

  open override var intrinsicContentSize: CGSize {
    return self.sizeThatFits(UIView.layoutFittingExpandedSize)
  }

  open override func sizeThatFits(_ size: CGSize) -> CGSize {
    let lineSize = self.model.lineSize
    switch self.model.orientation {
    case .vertical:
      return CGSize(width: lineSize, height: size.height)
    case .horizontal:
      return CGSize(width: size.width, height: lineSize)
    }
  }
}
