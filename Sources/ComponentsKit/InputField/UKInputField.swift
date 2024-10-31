import AutoLayout
import UIKit

/// A UIKit component that displays a field to input a text.
open class UKInputField: UIView, UKComponent {
  // MARK: Properties

  /// A closure that is triggered when the text changes.
  public var onValueChange: (String) -> Void

  /// A model that defines the appearance properties.
  public var model: InputFieldVM {
    didSet {
      self.update(oldValue)
    }
  }

  /// A text inputted in the field.
  public var text: String {
    get {
      return self.textField.text ?? ""
    }
    set {
      guard newValue != self.text else { return }

      self.textField.text = newValue
      self.onValueChange(newValue)
    }
  }

  private var titleLabelConstraints: LayoutConstraints?
  private var inputFieldConstraints: LayoutConstraints?

  // MARK: Subviews

  /// A label that displays the title from the model.
  public var titleLabel = UILabel()
  /// An underlying text field from the standard library.
  public var textField = UITextField()

  // MARK: UIView Properties

  open override var intrinsicContentSize: CGSize {
    return self.sizeThatFits(UIView.layoutFittingExpandedSize)
  }

  open override var isFirstResponder: Bool {
    return self.textField.isFirstResponder
  }

  // MARK: Initialization

  /// Initializer.
  /// - Parameters:
  ///   - initialText: A text that is initially inputted in the field.
  ///   - model: A model that defines the appearance properties.
  ///   - onValueChange: A closure that is triggered when the text changes.
  public init(
    initialText: String = "",
    model: InputFieldVM = .init(),
    onValueChange: @escaping (String) -> Void = { _ in }
  ) {
    self.model = model
    self.onValueChange = onValueChange
    super.init(frame: .zero)

    self.text = initialText

    self.setup()
    self.style()
    self.layout()
  }

  public required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: Setup

  private func setup() {
    self.addSubview(self.titleLabel)
    self.addSubview(self.textField)

    self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.handleTap)))
    self.textField.addTarget(self, action: #selector(self.handleTextChange), for: .editingChanged)
  }

  @objc private func handleTap() {
    self.becomeFirstResponder()
  }

  @objc private func handleTextChange() {
    self.onValueChange(self.text)
  }

  // MARK: Style

  private func style() {
    Self.Style.mainView(self, model: self.model)
    Self.Style.textField(self.textField, model: self.model)
    Self.Style.titleLabel(self.titleLabel, model: self.model)
  }

  // MARK: Layout

  private func layout() {
    self.titleLabelConstraints = self.titleLabel.leading(self.model.horizontalPadding)
    self.titleLabel.centerVertically()

    self.textField.trailing(self.model.horizontalPadding)
    self.textField.vertically()

    self.inputFieldConstraints = self.textField.after(
      self.titleLabel,
      padding: self.model.spacing
    )

    self.textField.setContentHuggingPriority(.defaultLow, for: .horizontal)
    self.titleLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
  }

  open override func layoutSubviews() {
    super.layoutSubviews()

    self.layer.cornerRadius = self.model.cornerRadius.value(for: self.bounds.height)
  }

  // MARK: Update

  public func update(_ oldModel: InputFieldVM) {
    guard self.model != oldModel else { return }

    self.style()

    self.inputFieldConstraints?.leading?.constant = self.model.spacing
    self.titleLabelConstraints?.leading?.constant = self.model.horizontalPadding
    if self.model.shouldUpdateLayout(oldModel) {
      self.setNeedsLayout()
      self.invalidateIntrinsicContentSize()
    }
  }

  // MARK: UIView Method

  @discardableResult
  open override func becomeFirstResponder() -> Bool {
    return self.textField.becomeFirstResponder()
  }

  @discardableResult
  open override func resignFirstResponder() -> Bool {
    return self.textField.resignFirstResponder()
  }

  open override func sizeThatFits(_ size: CGSize) -> CGSize {
    let width: CGFloat
    if let parentWidth = self.superview?.bounds.width,
       parentWidth > 0 {
      width = parentWidth
    } else {
      width = 10_000
    }
    return .init(
      width: min(size.width, width),
      height: min(size.height, self.model.height)
    )
  }
}

// MARK: - Style Helpers

extension UKInputField {
  fileprivate enum Style {
    static func mainView(
      _ view: UIView,
      model: InputFieldVM
    ) {
      view.backgroundColor = model.backgroundColor.uiColor
      view.layer.cornerRadius = model.cornerRadius.value(for: view.bounds.height)
    }
    static func titleLabel(
      _ label: UILabel,
      model: InputFieldVM
    ) {
      label.attributedText = model.nsAttributedTitle
    }
    static func textField(
      _ textField: UITextField,
      model: InputFieldVM
    ) {
      textField.font = model.preferredFont.uiFont
      textField.textColor = model.foregroundColor.uiColor
      textField.tintColor = model.tintColor.uiColor
      textField.attributedPlaceholder = model.nsAttributedPlaceholder
      textField.keyboardType = model.keyboardType
      textField.returnKeyType = model.submitType.returnKeyType
      textField.isSecureTextEntry = model.isSecureInput
      textField.isEnabled = model.isEnabled
      textField.autocorrectionType = model.autocorrectionType
      textField.autocapitalizationType = model.autocapitalization.textAutocapitalizationType
    }
  }
}
