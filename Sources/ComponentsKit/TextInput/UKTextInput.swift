import AutoLayout
import UIKit

/// A UIKit component that displays a field to input a text.
open class UKTextInput: UIView, UKComponent, UITextViewDelegate {
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
      return self.textView.text ?? ""
    }
    set {
      guard newValue != self.text else { return }

      self.textView.text = newValue
      self.onValueChange(newValue)
    }
  }

  private var titleLabelConstraints: LayoutConstraints?
  private var inputFieldConstraints: LayoutConstraints?
  private var textViewHeightConstraint: NSLayoutConstraint?

  private var minHeight: CGFloat = 0
  private var maxHeight: CGFloat = 0

  // MARK: Subviews

  /// A label that displays the title from the model.
  public var titleLabel = UILabel()
  /// An underlying text view from the standard library.
  public var textView = UITextView()

  // MARK: UIView Properties

  open override var intrinsicContentSize: CGSize {
    return self.sizeThatFits(UIView.layoutFittingExpandedSize)
  }

  open override var isFirstResponder: Bool {
    return self.textView.isFirstResponder
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
    self.addSubview(self.textView)

    self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.handleTap)))
    self.textView.delegate = self

    let lineHeight = self.textView.font?.lineHeight ?? UIFont.systemFontSize
    minHeight = lineHeight * 5 + self.textView.textContainerInset.top + self.textView.textContainerInset.bottom
    maxHeight = lineHeight * 7 + self.textView.textContainerInset.top + self.textView.textContainerInset.bottom

    self.textView.isScrollEnabled = false
  }

  @objc private func handleTap() {
    self.becomeFirstResponder()
  }

  // MARK: UITextViewDelegate

  public func textViewDidChange(_ textView: UITextView) {
    self.onValueChange(self.text)

    let size = CGSize(width: self.textView.frame.width, height: CGFloat.infinity)
    let estimatedSize = self.textView.sizeThatFits(size)

    var newHeight = estimatedSize.height
    if newHeight < minHeight {
      newHeight = minHeight
    } else if newHeight > maxHeight {
      newHeight = maxHeight
    }

    self.textViewHeightConstraint?.constant = newHeight

    self.textView.isScrollEnabled = estimatedSize.height > maxHeight
  }

  // MARK: Style

  private func style() {
    Self.Style.mainView(self, model: self.model)
    Self.Style.textView(self.textView, model: self.model)
    Self.Style.titleLabel(self.titleLabel, model: self.model)
  }

  // MARK: Layout

  private func layout() {
    self.titleLabelConstraints = self.titleLabel.leading(self.model.horizontalPadding)
    self.titleLabel.centerVertically()

    self.textView.trailing(self.model.horizontalPadding)
    self.textView.vertically()

    self.inputFieldConstraints = self.textView.after(
      self.titleLabel,
      padding: self.model.spacing
    )

    let heightConstraint = self.textView.heightAnchor.constraint(equalToConstant: minHeight)
    heightConstraint.isActive = true
    self.textViewHeightConstraint = heightConstraint

    self.textView.setContentHuggingPriority(.defaultLow, for: .horizontal)
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
    return self.textView.becomeFirstResponder()
  }

  @discardableResult
  open override func resignFirstResponder() -> Bool {
    return self.textView.resignFirstResponder()
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

extension UKTextInput {
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
    static func textView(
      _ textView: UITextView,
      model: InputFieldVM
    ) {
      textView.font = model.preferredFont.uiFont
      textView.textColor = model.foregroundColor.uiColor
      textView.tintColor = model.tintColor.uiColor
      textView.text = model.placeholder
      textView.autocorrectionType = model.autocorrectionType
      textView.autocapitalizationType = model.autocapitalization.textAutocapitalizationType
      textView.isEditable = model.isEnabled
      textView.isSelectable = model.isEnabled
    }
  }
}
