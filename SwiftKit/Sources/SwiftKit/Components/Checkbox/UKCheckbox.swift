import UIKit

open class UKCheckbox: UIView, UKComponent {
  // MARK: Properties

  public var onValueChange: (Bool) -> Void

  public var model: CheckboxVM {
    didSet {
      self.update(oldValue)
    }
  }

  public var isSelected: Bool {
    didSet {
      guard self.isSelected != oldValue else { return }
      self.updateSelection()
      self.onValueChange(self.isSelected)
    }
  }

  private var titleLabelConstraints: AnchoredConstraints = .init()

  // MARK: Subviews

  public var stackView = UIStackView()
  public var titleLabel = UILabel()
  public var checkboxContainer = UIView()
  public var checkboxBackground = UIView()
  public var checkmarkLayer = CAShapeLayer()

  // MARK: Initialization

  public init(
    initialValue: Bool = false,
    model: CheckboxVM = .init(),
    onValueChange: @escaping (Bool) -> Void = { _ in }
  ) {
    self.isSelected = initialValue
    self.model = model
    self.onValueChange = onValueChange
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
    self.addSubview(self.stackView)
    self.checkboxContainer.addSubview(self.checkboxBackground)
    self.stackView.addArrangedSubview(self.checkboxContainer)
    if self.model.title.isNotNilAndEmpty {
      self.stackView.addArrangedSubview(self.titleLabel)
    }

    self.checkboxContainer.layer.addSublayer(self.checkmarkLayer)

    self.setupCheckmarkLayer()
  }

  private func setupCheckmarkLayer() {
    self.checkmarkLayer.fillColor = UIColor.clear.cgColor
    self.checkmarkLayer.lineCap = .round
    self.checkmarkLayer.lineJoin = .round
    self.checkmarkLayer.strokeEnd = self.isSelected ? 1.0 : 0.0

    let checkmarkPath = UIBezierPath()
    checkmarkPath.move(to: .init(x: 6, y: 11))
    checkmarkPath.addLine(to: .init(x: 11, y: 17))
    checkmarkPath.addLine(to: .init(x: 18, y: 7))

    self.checkmarkLayer.path = checkmarkPath.cgPath
  }

  // MARK: Style

  func style() {
    Self.Style.stackView(self.stackView)
    Self.Style.titleLabel(self.titleLabel, model: self.model)
    Self.Style.checkboxContainer(self.checkboxContainer, model: self.model)
    Self.Style.checkboxBackground(self.checkboxBackground, model: self.model)
    Self.Style.checkmarkLayer(self.checkmarkLayer, model: self.model)

    self.checkboxBackground.alpha = self.isSelected ? 1.0 : 0.0
    self.checkboxContainer.layer.borderColor = self.isSelected
    ? UIColor.clear.cgColor
    : self.model.borderColor.uiColor.cgColor
  }

  // MARK: Layout

  func layout() {
    self.stackView.pinToEdges()

    self.checkboxContainer.size(24)
    self.checkboxBackground.pinToEdges()
  }

  // MARK: Update

  public func update(_ oldModel: CheckboxVM) {
    guard self.model != oldModel else { return }

    self.style()

    if self.model.shouldAddLabel(oldModel) {
      self.stackView.addArrangedSubview(self.titleLabel)
      self.setNeedsLayout()
      self.invalidateIntrinsicContentSize()
    } else if self.model.shouldRemoveLabel(oldModel) {
      self.stackView.removeArrangedSubview(self.titleLabel)
      self.setNeedsLayout()
      self.invalidateIntrinsicContentSize()
    }
  }

  func updateSelection() {
    if self.isSelected {
      self.animateSelection()
    } else {
      self.animateDeselection()
    }
  }

  // MARK: UIView methods

  open override func touchesEnded(
    _ touches: Set<UITouch>,
    with event: UIEvent?
  ) {
    super.touchesEnded(touches, with: event)

    if self.model.isEnabled,
       let location = touches.first?.location(in: self),
       self.bounds.contains(location) {
      self.isSelected.toggle()
    }
  }

  open override func touchesCancelled(
    _ touches: Set<UITouch>,
    with event: UIEvent?
  ) {
    super.touchesCancelled(touches, with: event)

    if self.model.isEnabled,
       let location = touches.first?.location(in: self),
       self.bounds.contains(location) {
      self.isSelected.toggle()
    }
  }

  // MARK: Helpers

  private func animateSelection() {
    UIView.animate(
      withDuration: CheckboxAnimationDurations.background,
      delay: 0.0,
      options: [.curveEaseInOut],
      animations: {
        self.checkboxBackground.alpha = 1.0
        self.checkboxBackground.transform = .identity
      }, completion: { _ in
        guard self.isSelected else { return }
        CATransaction.begin()
        CATransaction.setAnimationDuration(CheckboxAnimationDurations.checkmarkStroke)
        self.checkmarkLayer.strokeEnd = 1.0
        CATransaction.commit()
      }
    )

    UIView.animate(
      withDuration: CheckboxAnimationDurations.borderOpacity,
      delay: CheckboxAnimationDurations.selectedBorderDelay,
      animations: {
        self.checkboxContainer.layer.borderColor = UIColor.clear.cgColor
      }
    )
  }

  private func animateDeselection() {
    CATransaction.begin()
    CATransaction.setDisableActions(true)
    self.checkmarkLayer.strokeEnd = 0.0
    CATransaction.commit()

    UIView.animate(
      withDuration: CheckboxAnimationDurations.background,
      delay: 0.0,
      options: [.curveEaseInOut]
    ) {
      self.checkboxBackground.alpha = 0.0
      self.checkboxBackground.transform = .init(scaleX: 0.1, y: 0.1)
    }

    UIView.animate(
      withDuration: CheckboxAnimationDurations.borderOpacity,
      animations: {
        self.checkboxContainer.layer.borderColor = self.model.borderColor.uiColor.cgColor
      }
    )
  }

  @objc open func handleTraitChanges() {

  }
}

// MARK: - Style Helpers

extension UKCheckbox {
  fileprivate enum Style {
    static func stackView(_ stackView: UIStackView) {
      stackView.axis = .horizontal
      stackView.spacing = 8
      stackView.alignment = .center
    }
    static func titleLabel(_ label: UILabel, model: Model) {
      label.textColor = Palette.Text.primary.uiColor
      label.numberOfLines = 0
      label.text = model.title
      label.textColor = model.titleColor.uiColor
      label.font = model.titleFont.uiFont
    }
    static func checkboxContainer(_ view: UIView, model: Model) {
      view.layer.cornerRadius = model.checkboxCornerRadius
      view.layer.borderWidth = model.borderWidth
      view.layer.borderColor = model.borderColor.uiColor.cgColor
    }
    static func checkboxBackground(_ view: UIView, model: Model) {
      view.layer.cornerRadius = model.checkboxCornerRadius
      view.backgroundColor = model.backgroundColor.uiColor
    }
    static func checkmarkLayer(_ layer: CAShapeLayer, model: Model) {
      layer.strokeColor = model.foregroundColor.uiColor.cgColor
      layer.lineWidth = model.checkmarkLineWidth
    }
  }
}
