// Copyright © SwiftKit. All rights reserved.

import UIKit

open class UKButton: UIButton, ConfigurableComponent {
  // MARK: Properties

  private var actions: [UIControl.Event: () -> Void] = [:]

  public var model: ButtonVM {
    didSet {
      self.update(oldValue)
    }
  }

  // MARK: UIButton Properties

  public override var isHighlighted: Bool {
    didSet {
      self.transform = self.isHighlighted
      ? .init(
        scaleX: self.model.animationScale.value,
        y: self.model.animationScale.value
      )
      : .identity
    }
  }

  open override var intrinsicContentSize: CGSize {
    return self.sizeThatFits(UIView.layoutFittingExpandedSize)
  }

  // MARK: Initialization

  public init(model: ButtonVM = .init()) {
    self.model = model
    super.init(frame: .zero)

    self.update(nil)
  }

  public required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: Lifecycle

  open override func layoutSubviews() {
    super.layoutSubviews()

    self.layer.cornerRadius = self.model.cornerRadius.value(for: self.bounds.height)
  }

  open override func sizeThatFits(_ size: CGSize) -> CGSize {
    let contentSize = self.titleLabel?.sizeThatFits(size) ?? .zero
    let preferredSize = self.model.preferredSize(for: contentSize)
    return .init(
      width: min(preferredSize.width, size.width),
      height: min(preferredSize.height, size.height)
    )
  }

  // MARK: Update

  public func update(_ oldModel: ButtonVM?) {
    self.layer.cornerRadius = self.model.cornerRadius.value(for: self.bounds.height)

    self.setTitle(self.model.title, for: .normal)
    self.titleLabel?.font = self.model.font

    self.isEnabled = self.model.isEnabled
    self.layer.borderWidth = self.model.borderWidth

    self.layer.borderWidth = self.model.borderWidth
    self.layer.borderColor = self.model.borderColor.cgColor
    self.backgroundColor = self.model.backgroundColor
    self.setTitleColor(self.model.foregroundColor, for: .normal)

    if self.model.shouldUpdateSize(oldModel) {
//      self.sizeToFit()
    }
  }

  // MARK: Helpers

  @objc open func handleTraitChanges() {

  }
}

  // MARK: - Events handling

extension UKButton {
  public func on(_ event: UIControl.Event, _ action: @escaping () -> Void) {
    switch event {
    case .touchUpInside:
      self.addTarget(self, action: #selector(self.handleTouchUpInsideEvent), for: .touchUpInside)

    case .touchUpOutside:
      self.addTarget(self, action: #selector(self.handleTouchUpOutsideEvent), for: .touchUpOutside)

    default:
      assertionFailure("Attempting to register not supported event.")
    }

    self.actions[event] = action
  }

  @objc private func handleTouchUpInsideEvent() {
    self.actions[.touchUpInside]?()
  }

  @objc private func handleTouchUpOutsideEvent() {
    self.actions[.touchUpOutside]?()
  }
}

// MARK: - UIControl.Event + Hashable

extension UIControl.Event: Hashable {}
