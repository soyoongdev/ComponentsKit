import UIKit

open class UKInputField: UIView, UKComponent {
  // MARK: Models

  fileprivate enum TitlePosition {
    case top
    case center
  }

  // MARK: Properties

  public var onValueChange: (String) -> Void

  public var model: InputFieldVM {
    didSet {
      self.update(oldValue)
    }
  }

  public var text: String {
    get {
      return self.inputField.text ?? ""
    }
    set {
      guard newValue != self.text else { return }

      self.inputField.text = newValue
      self.onValueChange(newValue)
      self.titlePosition = Self.getTitlePosition(
        isSelected: self.inputField.isFirstResponder,
        hasText: newValue.isNotEmpty,
        hasPlaceholder: self.model.placeholder.isNotNilAndEmpty
      )
    }
  }
  public var isSelected: Bool {
    get {
      return self.inputField.isFirstResponder
    }
    set {
      if newValue {
        self.inputField.becomeFirstResponder()
      } else {
        self.inputField.resignFirstResponder()
      }
    }
  }

  private var titlePosition: TitlePosition {
    didSet {
      if self.titlePosition != oldValue {
        self.updateTitlePosition()
      }
    }
  }

  private var titleLabelConstraints: AnchoredConstraints = .init()

  // MARK: Subviews

  public var titleLabel = UILabel()
  public var inputField = UITextField()

  // MARK: Initialization

  public init(
    initialText: String = "",
    model: InputFieldVM = .init(),
    onValueChange: @escaping (String) -> Void = { _ in }
  ) {
    self.model = model
    self.onValueChange = onValueChange
    self.titlePosition = Self.getTitlePosition(
      isSelected: false,
      hasText: initialText.isNotEmpty,
      hasPlaceholder: model.placeholder.isNotNilAndEmpty
    )
    super.init(frame: .zero)

    self.text = initialText

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
    self.addSubview(self.inputField)

    self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.handleTap)))
    self.inputField.addTarget(self, action: #selector(self.handleTextChange), for: .editingChanged)

    self.inputField.delegate = self
  }

  @objc private func handleTap() {
    self.isSelected = true
  }

  @objc private func handleTextChange() {
    self.onValueChange(self.text)
  }

  // MARK: Style

  func style() {
    Self.Style.titleLabel(self.titleLabel, position: .center, model: self.model)
  }

  // MARK: Layout

  func layout() {
    self.titleLabelConstraints = self.titleLabel.horizontally(12)

    self.inputField.horizontally(12)
    self.inputField.bottom(Self.Layout.inputFieldBottomInset)
    self.inputField.top(Self.Layout.inputFieldTopInset)
    self.inputField.height(Self.Layout.inputFieldHeight)

    self.titleLabelConstraints.bottom = self.titleLabel.above(of: self.inputField, padding: 5)
    self.titleLabelConstraints.bottom?.isActive = self.titlePosition == .top

    self.titleLabelConstraints.vertical = self.titleLabel.centerVertically()
    self.titleLabelConstraints.vertical?.isActive = self.titlePosition == .center
  }

  open override func layoutSubviews() {
    super.layoutSubviews()

    self.layer.cornerRadius = self.model.cornerRadius.value(for: self.bounds.height)
  }

  // MARK: Update

  public func update(_ oldModel: InputFieldVM) {
    self.layer.cornerRadius = self.model.cornerRadius.value(for: self.bounds.height)

    self.titleLabel.text = self.model.title

    self.inputField.font = self.model.font.uiFont
    self.inputField.textColor = self.model.foregroundColor.uiColor
    self.inputField.tintColor = self.model.tintColor.uiColor
    self.inputField.attributedPlaceholder = self.model.attributedPlaceholder

    self.backgroundColor = self.model.backgroundColor.uiColor

    self.titlePosition = Self.getTitlePosition(
      isSelected: self.inputField.isFirstResponder,
      hasText: self.text.isNotEmpty,
      hasPlaceholder: self.model.placeholder.isNotNilAndEmpty
    )
  }

  // MARK: Helpers

  @objc open func handleTraitChanges() {

  }

  private static func getTitlePosition(
    isSelected: Bool,
    hasText: Bool,
    hasPlaceholder: Bool
  ) -> TitlePosition {
    if !hasPlaceholder, !hasText, !isSelected {
      return .center
    } else {
      return .top
    }
  }

  private func updateTitlePosition() {
    Self.Style.titleLabel(
      self.titleLabel,
      position: self.titlePosition,
      model: self.model
    )

    switch self.titlePosition {
    case .center:
      self.titleLabelConstraints.bottom?.isActive = false
      self.titleLabelConstraints.vertical?.isActive = true
    case .top:
      self.titleLabelConstraints.vertical?.isActive = false
      self.titleLabelConstraints.bottom?.isActive = true
    }
    UIView.animate(withDuration: 0.2) {
      self.layoutIfNeeded()
    }
  }
}

extension UKInputField: UITextFieldDelegate {
  public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
    if !textField.isFirstResponder {
      self.titlePosition = Self.getTitlePosition(
        isSelected: true,
        hasText: self.text.isNotEmpty,
        hasPlaceholder: self.model.placeholder.isNotNilAndEmpty
      )
    }

    return true
  }

  public func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
    if textField.isFirstResponder {
      self.titlePosition = Self.getTitlePosition(
        isSelected: false,
        hasText: self.text.isNotEmpty,
        hasPlaceholder: self.model.placeholder.isNotNilAndEmpty
      )
    }

    return true
  }
}

// MARK: - Style Helpers

extension UKInputField {
  fileprivate enum Style {
    static func titleLabel(
      _ label: UILabel,
      position: TitlePosition,
      model: InputFieldVM
    ) {
      switch position {
      case .top:
        label.textColor = model.foregroundColor.uiColor
        label.font = model.font.withRelativeSize(-2).uiFont
      case .center:
        label.textColor = model.foregroundColor.uiColor.withAlphaComponent(0.9)
        label.font = model.font.withRelativeSize(2).uiFont
      }
    }
  }
}

extension UKInputField {
  fileprivate enum Layout {
    static let inputFieldTopInset: CGFloat = 36
    static let inputFieldHeight: CGFloat = 30
    static let inputFieldBottomInset: CGFloat = 12
    static var height: CGFloat {
      return self.inputFieldHeight + self.inputFieldTopInset + self.inputFieldBottomInset
    }
  }
}
