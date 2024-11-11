import AutoLayout
import UIKit

/// A UIKit component that displays a field to input a text.
open class UKTextInput: UIView, UKComponent, UITextViewDelegate {
  // MARK: Properties

  /// A closure that is triggered when the text changes.
  public var onValueChange: (String) -> Void

  /// A model that defines the appearance properties.
  public var model: InputTextVM {
    didSet {
      self.update(oldValue)
      self.adjustTextViewHeight()
    }
  }
//  public var text: String {
//    get { return self.textView.text ?? "" }
//    set {
//      guard newValue != self.text else { return }
////      self.textView.text = newValue
//      self.onValueChange(newValue)
//    }
//  }

  private var inputFieldConstraints: LayoutConstraints?
  private var textViewHeightConstraint: NSLayoutConstraint?

  // MARK: Subviews

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
    model: InputTextVM = .init(),
    onValueChange: @escaping (String) -> Void = { _ in }
  ) {
    self.model = model
    self.onValueChange = onValueChange
    super.init(frame: .zero)

//    self.text = initialText
    self.setup()
    self.style()
    self.layout()
  }

  public required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: Setup

  private func setup() {
    self.addSubview(self.textView)
    self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.handleTap)))
    self.textView.delegate = self
    self.textView.isScrollEnabled = false
  }

  @objc private func handleTap() {
    self.becomeFirstResponder()
  }

  // MARK: UITextViewDelegate

  public func textViewDidChange(_ textView: UITextView) {
//    self.onValueChange(self.text)
    self.adjustTextViewHeight()
  }

  private func adjustTextViewHeight() {
    let estimatedSize = self.textView.sizeThatFits(CGSize(width: self.textView.frame.width, height: CGFloat.infinity))
    let minHeight = model.calculatedHeight(forRows: model.minRows + 1)
    let maxHeight = model.maxRows.map { model.calculatedHeight(forRows: $0 + 1) } ?? .greatestFiniteMagnitude

    let newHeight = min(max(estimatedSize.height, minHeight), maxHeight)
    self.textViewHeightConstraint?.constant = newHeight
    self.textView.isScrollEnabled = estimatedSize.height > maxHeight
  }

  // MARK: Style

  private func style() {
    Self.Style.mainView(self, model: self.model)
    Self.Style.textView(self.textView, model: self.model)
  }

  // MARK: Layout

  private func layout() {
    self.textView.leading(self.model.horizontalPadding)
    self.textView.trailing(self.model.horizontalPadding)
    self.textView.vertically()

    let minHeight = model.calculatedHeight(forRows: model.minRows)
    self.textViewHeightConstraint = self.textView.heightAnchor.constraint(equalToConstant: minHeight)
    self.textViewHeightConstraint?.isActive = true

    self.textView.setContentHuggingPriority(.defaultLow, for: .horizontal)
  }

  open override func layoutSubviews() {
    super.layoutSubviews()
    self.layer.cornerRadius = self.model.cornerRadius.value(for: self.bounds.height)
  }

  // MARK: Update

  public func update(_ oldModel: InputTextVM) {
    guard self.model != oldModel else { return }
    self.style()
    if self.model.shouldUpdateLayout(oldModel) {
      self.setNeedsLayout()
      self.invalidateIntrinsicContentSize()
    }
  }

  @discardableResult
  open override func becomeFirstResponder() -> Bool {
    return self.textView.becomeFirstResponder()
  }

  @discardableResult
  open override func resignFirstResponder() -> Bool {
    return self.textView.resignFirstResponder()
  }

  open override func sizeThatFits(_ size: CGSize) -> CGSize {
    let width: CGFloat = self.superview?.bounds.width ?? 10_000
    return CGSize(width: min(size.width, width), height: min(size.height, self.model.height))
  }
}

// MARK: - Style Helpers

extension UKTextInput {
  fileprivate enum Style {
    static func mainView(
      _ view: UIView,
      model: InputTextVM
    ) {
      view.backgroundColor = model.backgroundColor.uiColor
      view.layer.cornerRadius = model.cornerRadius.value(for: view.bounds.height)
    }
    static func textView(
      _ textView: UITextView,
      model: InputTextVM
    ) {
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
