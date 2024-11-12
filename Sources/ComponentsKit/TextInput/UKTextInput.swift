import AutoLayout
import UIKit

/// A UIKit component that provides a customizable, multi-line text input field with dynamic height adjustment and placeholder support.
open class UKTextInput: UIView, UKComponent, UITextViewDelegate {
  // MARK: - Properties

  /// A closure that is triggered when the text changes.
  public var onValueChange: (String) -> Void

  /// A model that defines the appearance properties.
  public var model: TextInputVM {
    didSet {
      self.update(oldValue)
      self.adjustTextViewHeight()
    }
  }

  /// The UITextView instance used for text input.
  public var textView = UITextView()

  /// A label used to display placeholder text when the text view is empty.
  private var placeholderLabel = UILabel()

  private var textViewHeightConstraint: NSLayoutConstraint?

  // MARK: - UIView Properties

  /// Overrides the intrinsic content size to fit the text view dynamically.
  open override var intrinsicContentSize: CGSize {
    return self.sizeThatFits(UIView.layoutFittingExpandedSize)
  }

  /// Overrides the `isFirstResponder` property to check the text view's focus state.
  open override var isFirstResponder: Bool {
    return self.textView.isFirstResponder
  }

  // MARK: - Initialization

  /// Initializer.
  /// - Parameters:
  ///   - initialText: A text that is initially inputted in the field.
  ///   - model: A model that defines the appearance properties.
  ///   - onValueChange: A closure that is triggered when the text changes.
  public init(
    initialText: String = "",
    model: TextInputVM = .init(),
    onValueChange: @escaping (String) -> Void = { _ in }
  ) {
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

  // MARK: - Setup

  private func setup() {
    self.addSubview(self.textView)
    self.addSubview(self.placeholderLabel)
    self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.handleTap)))
    self.textView.delegate = self
    self.textView.isScrollEnabled = false
    self.placeholderLabel.isUserInteractionEnabled = false
  }

  @objc private func handleTap() {
    self.becomeFirstResponder()
  }

  // MARK: - UITextViewDelegate

  public func textViewDidBeginEditing(_ textView: UITextView) {
    updatePlaceholderVisibility()
  }

  public func textViewDidChange(_ textView: UITextView) {
    self.onValueChange(textView.text)
    self.adjustTextViewHeight()
    updatePlaceholderVisibility()
  }

  public func textViewDidEndEditing(_ textView: UITextView) {
    updatePlaceholderVisibility()
  }

  // MARK: - Placeholder

  private func updatePlaceholderVisibility() {
    placeholderLabel.isHidden = !textView.text.isEmpty
  }

  // MARK: - Height Adjustment

  /// Adjusts the height of the text view based on its content and model constraints.
  private func adjustTextViewHeight() {
    let estimatedSize = self.textView.sizeThatFits(CGSize(width: self.textView.frame.width, height: CGFloat.infinity))
    let minHeight = model.minTextInputHeight
    let maxHeight = model.maxTextInputHeight

    let newHeight = min(max(estimatedSize.height, minHeight), maxHeight)
    self.textViewHeightConstraint?.constant = newHeight

    if maxHeight >= 10_000 {
      self.textView.isScrollEnabled = estimatedSize.height > minHeight
    } else {
      self.textView.isScrollEnabled = estimatedSize.height > maxHeight
    }
  }

  // MARK: - Style

  private func style() {
    Self.Style.mainView(self, model: self.model)
    Self.Style.textView(self.textView, model: self.model)

    placeholderLabel.font = model.preferredFont.uiFont
    placeholderLabel.textColor = model.placeholderColor.uiColor
    placeholderLabel.text = model.placeholder
    placeholderLabel.isHidden = !textView.text.isEmpty
  }

  // MARK: - Layout

  private func layout() {
    self.textView.leading()
    self.textView.trailing()
    self.textView.vertically()

    placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      placeholderLabel.leadingAnchor.constraint(equalTo: textView.leadingAnchor, constant: model.contentPadding),
      placeholderLabel.topAnchor.constraint(equalTo: textView.topAnchor, constant: textView.textContainerInset.top + 4)
    ])

    let minHeight = model.minTextInputHeight
    self.textViewHeightConstraint = self.textView.heightAnchor.constraint(equalToConstant: minHeight)
    self.textViewHeightConstraint?.isActive = true

    self.textView.setContentHuggingPriority(.defaultLow, for: .horizontal)
  }

  open override func layoutSubviews() {
    super.layoutSubviews()
    self.layer.cornerRadius = self.model.cornerRadius.value(for: self.bounds.height)
  }

  // MARK: - Model Update

  /// Updates the view’s styling and layout when the model changes.
  /// - Parameter oldModel: The previous model state for comparison.
  public func update(_ oldModel: TextInputVM) {
    guard self.model != oldModel else { return }
    self.style()
    if self.model.shouldUpdateLayout(oldModel) {
      self.setNeedsLayout()
      self.invalidateIntrinsicContentSize()
    }
  }

  // MARK: - UIResponder

  /// Makes the text view the first responder.
  @discardableResult
  open override func becomeFirstResponder() -> Bool {
    return self.textView.becomeFirstResponder()
  }

  /// Resigns the first responder status from the text view.
  @discardableResult
  open override func resignFirstResponder() -> Bool {
    return self.textView.resignFirstResponder()
  }

  open override func sizeThatFits(_ size: CGSize) -> CGSize {
      let width: CGFloat = min(size.width, self.superview?.bounds.width ?? 10_000)

      let estimatedHeight = self.textView.sizeThatFits(CGSize(width: width, height: CGFloat.infinity)).height

      let height = min(max(estimatedHeight, model.minTextInputHeight), model.maxTextInputHeight)

      return CGSize(width: width, height: height)
  }
}

// MARK: - Style Helpers

extension UKTextInput {
  fileprivate enum Style {
    /// Applies the main view styling based on the model.
    static func mainView(_ view: UIView, model: TextInputVM) {
      view.backgroundColor = model.backgroundColor.uiColor
      view.layer.cornerRadius = model.adaptedCornerRadius.value(for: view.bounds.height)
    }

    /// Applies styling to the text view based on the model.
    static func textView(_ textView: UITextView, model: TextInputVM) {
      textView.font = model.preferredFont.uiFont
      textView.textColor = model.foregroundColor.uiColor
      textView.tintColor = model.tintColor.uiColor
      textView.autocorrectionType = model.autocorrectionType
      textView.autocapitalizationType = model.autocapitalization.textAutocapitalizationType
      textView.isEditable = model.isEnabled
      textView.isSelectable = model.isEnabled
      textView.backgroundColor = .clear
    }
  }
}
