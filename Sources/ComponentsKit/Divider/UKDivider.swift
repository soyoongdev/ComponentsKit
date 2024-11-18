import UIKit

/// A UIKit component that displays a separating line.
open class UKDivider: UIView, UKComponent {
  // MARK: - Properties

  /// A model that defines the appearance properties.
  public var model: DividerVM {
    didSet {
      self.update(oldValue)
    }
  }

  // MARK: - Initializers

  /// Initializer.
  /// - Parameters:
  ///   - model: A model that defines the appearance properties.
  public init(model: DividerVM = .init()) {
    self.model = model
    super.init(frame: .zero)
    self.setup()
  }

  public required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Setup

  private func setup() {
    self.backgroundColor = self.model.color.uiColor
  }

  // MARK: - Update

  public func update(_ oldModel: DividerVM) {
    guard self.model != oldModel else { return }

    self.backgroundColor = self.model.color.uiColor

    if self.model.orientation != oldModel.orientation || self.model.size != oldModel.size {
      self.invalidateIntrinsicContentSize()
    }

    self.setNeedsLayout()
  }

  // MARK: - Layout

  open override func layoutSubviews() {
    super.layoutSubviews()
  }

  // MARK: - UIView Properties

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
