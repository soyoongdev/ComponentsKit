import UIKit

open class UKButton: UIView, UKComponent {
  // MARK: Properties

  public var action: () -> Void

  public var model: ButtonVM {
    didSet {
      self.update(oldValue)
    }
  }

  public var isHighlighted: Bool = false {
    didSet {
      self.transform = self.isHighlighted && self.model.isEnabled
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
    Self.Style.mainView(self, model: self.model)
    Self.Style.titleLabel(self.titleLabel, model: self.model)
  }

  // MARK: Layout

  func layout() {
    self.titleLabelConstraints = self.titleLabel.horizontally(self.model.horizontalPadding)
    self.titleLabel.centerVertically()
    self.titleLabel.centerHorizontally()

    self.titleLabelConstraints.leading?.priority = .defaultHigh
    self.titleLabelConstraints.trailing?.priority = .defaultHigh
  }

  open override func layoutSubviews() {
    super.layoutSubviews()

    self.layer.cornerRadius = self.model.cornerRadius.value(for: self.bounds.height)
  }

  // MARK: Update

  public func update(_ oldModel: ButtonVM) {
    guard self.model != oldModel else { return }

    self.layer.cornerRadius = self.model.cornerRadius.value(for: self.bounds.height)

    self.style()

    if self.model.shouldUpdateSize(oldModel) {
      self.titleLabelConstraints.leading?.constant = self.model.horizontalPadding
      self.titleLabelConstraints.trailing?.constant = -self.model.horizontalPadding
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

    defer { self.isHighlighted = false }

    if self.model.isEnabled,
       let location = touches.first?.location(in: self),
       self.bounds.contains(location) {
      self.action()
    }
  }

  // MARK: Helpers

  @objc open func handleTraitChanges() {

  }
}

// MARK: - Style Helpers

extension UKButton {
  fileprivate enum Style {
    static func mainView(_ view: UIView, model: Model) {
      view.layer.borderWidth = model.borderWidth
      view.layer.borderColor = model.borderColor?.uiColor.cgColor
      view.backgroundColor = model.backgroundColor?.uiColor
    }
    static func titleLabel(_ label: UILabel, model: Model) {
      label.textAlignment = .center
      label.text = model.title
      label.font = model.preferredFont.uiFont
      label.textColor = model.foregroundColor.uiColor
    }
  }
}
