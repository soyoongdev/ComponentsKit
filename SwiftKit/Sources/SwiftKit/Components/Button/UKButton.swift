import UIKit

open class UKButton: UIView, ConfigurableComponent {
  // MARK: Properties

  public var action: () -> Void

  public var model: ButtonVM {
    didSet {
      self.update(oldValue)
    }
  }

  public var isHighlighted: Bool = false {
    didSet {
      self.transform = self.isHighlighted
      ? .init(
        scaleX: self.model.animationScale.value,
        y: self.model.animationScale.value
      )
      : .identity
    }
  }

  private var titleLabelConstraints: AnchoredConstraints = .init()

  // MARK: Subviews

  public var titleLabel = UILabel()

  // MARK: UIView Properties

  open override var intrinsicContentSize: CGSize {
    return self.sizeThatFits(UIView.layoutFittingExpandedSize)
  }

  // MARK: Initialization

  public init(
    model: ButtonVM = .init(),
    action: @escaping () -> Void = {}
  ) {
    self.model = model
    self.action = action
    super.init(frame: .zero)

    self.setup()
    self.style()
    self.layout()
    self.update(model)
  }

  public required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: Setup

  func setup() {
    self.addSubview(self.titleLabel)
  }

  // MARK: Style

  func style() {
    Self.Style.titleLabel(self.titleLabel)
  }

  // MARK: Layout

  func layout() {
    self.titleLabelConstraints = self.titleLabel.pinToEdges(.all, insets: self.model.insets)
    self.titleLabel.centerVertically()
    self.titleLabel.centerHorizontally()

    self.titleLabelConstraints.leading?.priority = .defaultHigh
    self.titleLabelConstraints.top?.priority = .defaultHigh
    self.titleLabelConstraints.trailing?.priority = .defaultHigh
    self.titleLabelConstraints.bottom?.priority = .defaultHigh
  }

  open override func layoutSubviews() {
    super.layoutSubviews()

    self.layer.cornerRadius = self.model.cornerRadius.value(for: self.bounds.height)
  }

  // MARK: Update

  public func update(_ oldModel: ButtonVM) {
    self.layer.cornerRadius = self.model.cornerRadius.value(for: self.bounds.height)

    self.titleLabel.text = self.model.title
    self.titleLabel.font = self.model.font

    self.layer.borderWidth = self.model.borderWidth
    self.layer.borderColor = self.model.borderColor.cgColor
    self.backgroundColor = self.model.backgroundColor
    self.titleLabel.textColor = self.model.foregroundColor

    if self.model.shouldUpdateInsets(oldModel) {
      self.titleLabelConstraints.updateInsets(self.model.insets)
    }
    if self.model.shouldUpdateSize(oldModel) {
      self.invalidateIntrinsicContentSize()
      self.setNeedsLayout()
    }
  }

  // MARK: UIView methods

  open override func sizeThatFits(_ size: CGSize) -> CGSize {
    let contentSize = self.titleLabel.sizeThatFits(size)
    let preferredSize = self.model.preferredSize(for: contentSize)
    return .init(
      width: min(preferredSize.width, size.width),
      height: min(preferredSize.height, size.height)
    )
  }

  open override func touchesBegan(
    _ touches: Set<UITouch>,
    with event: UIEvent?
  ) {
    super.touchesBegan(touches, with: event)

    self.isHighlighted = true
  }

  open override func touchesEnded(
    _ touches: Set<UITouch>,
    with event: UIEvent?
  ) {
    super.touchesEnded(touches, with: event)

    defer { self.isHighlighted = false }

    if self.model.isEnabled,
       let location = touches.first?.location(in: self),
       self.bounds.contains(location) {
      self.action()
    }
  }

  open override func touchesCancelled(
    _ touches: Set<UITouch>,
    with event: UIEvent?
  ) {
    super.touchesCancelled(touches, with: event)

    self.isHighlighted = false
  }

  // MARK: Helpers

  @objc open func handleTraitChanges() {

  }
}

// MARK: - Style Helpers

extension UKButton {
  fileprivate enum Style {
    static func titleLabel(_ label: UILabel) {
      label.textAlignment = .center
    }
  }
}
