// Copyright © SwiftKit. All rights reserved.

import UIKit

open class UKButton: UIButton, ConfigurableComponent {
  // MARK: Properties

  private var actions: [UIControl.Event: () -> Void] = [:]

  public var model: ButtonVM = .init() {
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
    return self.sizeThatFits(.init(
      width: CGFloat.greatestFiniteMagnitude,
      height: CGFloat.greatestFiniteMagnitude
    ))
  }

  // MARK: Initialization

  public override init(frame: CGRect) {
    super.init(frame: frame)

    if frame.size != .zero {
      self.model.preferredSize = .custom(frame.size)
    }

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

  // MARK: UIButton methods

  open override func setTitle(_ title: String?, for state: UIControl.State) {
    super.setTitle(title, for: state)

    self.sizeToFit()
  }

  open override func sizeThatFits(_ size: CGSize) -> CGSize {
    switch self.model.preferredSize {
    case .small, .medium, .large:
      let height = self.model.preferredSize.height
      let horizontalPadding = self.model.preferredSize.horizontalPadding
      let textWidth = self.titleLabel?.sizeThatFits(size).width ?? 0
      return .init(width: textWidth + 2 * horizontalPadding, height: height)
    case .custom(let size):
      return size
    }
  }

  // MARK: Update

  public func update(_ oldModel: ButtonVM?) {
    self.layer.cornerRadius = self.model.cornerRadius.value(for: self.bounds.height)

    self.setTitle(self.model.title, for: .normal)
    self.titleLabel?.font = self.model.font

    self.isEnabled = self.model.isEnabled
    self.layer.borderWidth = self.model.borderWidth

    let color = self.model.isEnabled
    ? self.model.color.main.uiColor
    : self.model.color.main.uiColor.withAlphaComponent(
      SwiftKitConfig.shared.layout.disabledOpacity
    )
    switch self.model.style {
    case .filled:
      self.layer.borderWidth = 0
      self.backgroundColor = color
      self.setTitleColor(self.model.color.contrast.uiColor, for: .normal)
    case .plain:
      self.layer.borderWidth = 0
      self.backgroundColor = nil
      self.setTitleColor(color, for: .normal)
    case .bordered(let borderWidth):
      self.layer.borderWidth = borderWidth.value
      self.layer.borderColor = color.cgColor
      self.backgroundColor = nil
      self.setTitleColor(color, for: .normal)
    }

    if self.model.shouldUpdateSize(oldModel) {
      self.sizeToFit()
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
