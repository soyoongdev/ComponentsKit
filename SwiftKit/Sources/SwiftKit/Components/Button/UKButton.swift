// Copyright © SwiftKit. All rights reserved.

import UIKit

open class UKButton: UIButton {
  // MARK: Properties

  private var actions: [UIControl.Event: () -> Void] = [:]

  public var preferredSize: ButtonSize = .medium {
    didSet { self.sizeToFit() }
  }
  public var cornerRadius: Radius = .medium {
    didSet { self.updateRadius() }
  }
  public var style: ButtonStyle = .filled {
    didSet { self.updateStyle() }
  }
  public var color: ComponentColor = .primary {
    didSet { self.updateStyle() }
  }
  public var animationScale: AnimationScale = .medium

  public var font: UIFont? {
    willSet {
      guard let newValue else { return }
      self.titleLabel?.font = newValue
      self.sizeToFit()
    }
  }

  public override var isHighlighted: Bool {
    didSet {
      self.transform = self.isHighlighted ? .init(scaleX: self.animationScale.coef, y: self.animationScale.coef) : .identity
    }
  }
  public override var isEnabled: Bool {
    didSet { self.updateStyle() }
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
      self.preferredSize = .custom(frame.size)
    }

    self.updateStyle()
  }

  public required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: Lifecycle

  open override func layoutSubviews() {
    super.layoutSubviews()

    self.updateRadius()
  }

  // MARK: UIButton methods

  open override func setTitle(_ title: String?, for state: UIControl.State) {
    super.setTitle(title, for: state)

    self.sizeToFit()
  }

  open override func sizeThatFits(_ size: CGSize) -> CGSize {
    switch self.preferredSize {
    case .small, .medium, .large:
      let height = self.preferredSize.height
      let horizontalPadding = self.preferredSize.horizontalPadding
      let textWidth = self.titleLabel?.sizeThatFits(size).width ?? 0
      return .init(width: textWidth + 2 * horizontalPadding, height: height)
    case .custom(let size):
      return size
    }
  }

  // MARK: Update

  public func updateRadius() {
    self.layer.cornerRadius = self.bounds.height * self.cornerRadius.coef
  }

  public func updateStyle() {
    let color = self.isEnabled
    ? self.color.main.uiColor
    : self.color.main.uiColor.withAlphaComponent(0.5)
    switch self.style {
    case .filled:
      self.layer.borderWidth = 0
      self.backgroundColor = color
      self.setTitleColor(self.color.contrast.uiColor, for: .normal)
    case .plain:
      self.layer.borderWidth = 0
      self.backgroundColor = nil
      self.setTitleColor(color, for: .normal)
    case .bordered(let size):
      switch size {
      case .small:
        self.layer.borderWidth = 1
      case .medium:
        self.layer.borderWidth = 2
      case .large:
        self.layer.borderWidth = 3
      case .custom(let value):
        self.layer.borderWidth = value
      }
      self.layer.borderColor = color.cgColor
      self.backgroundColor = nil
      self.setTitleColor(color, for: .normal)
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
