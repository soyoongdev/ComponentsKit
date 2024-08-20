//
//  UKButton.swift
//  SwiftKitApp
//
//  Created by Mikhail on 19.08.2024.
//

import UIKit

public enum Radius {
  case none
  case small
  case medium
  case large
  case full

  var coef: CGFloat {
    switch self {
    case .none:
      return 0
    case .small:
      return 0.15
    case .medium:
      return 0.25
    case .large:
      return 0.35
    case .full:
      return 0.5
    }
  }
}

public enum AnimationScale {
  case none
  case small
  case medium
  case large

  var coef: CGFloat {
    switch self {
    case .none:
      return 1
    case .small:
      return 0.99
    case .medium:
      return 0.98
    case .large:
      return 0.95
    }
  }
}

public enum Size {
  case small
  case medium
  case large
}

public enum Color {
  case primary
  case secondary
  case accent
  case success
  case warning
  case danger

  var uiColor: UIColor {
    return .systemBlue
  }
}

public enum ButtonStyle {
  public enum BorderSize {
    case small
    case medium
    case large
    case custom(CGFloat)
  }

  case filled
  case plain
  case bordered(BorderSize)
}

open class UKButton: UIButton {
  // MARK: Properties

  public var preferredSize: Size = .medium {
    didSet { self.updateSize() }
  }
  public var cornerRadius: Radius = .medium {
    didSet { self.updateRadius() }
  }
  public var style: ButtonStyle = .filled {
    didSet { self.updateStyle() }
  }
  public var color: Color = .primary {
    didSet { self.updateStyle() }
  }
  public var animationScale: AnimationScale = .medium

  public var font: UIFont? {
    willSet {
      guard let newValue else { return }
      self.titleLabel?.font = newValue
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

  private var referenceLabel = UILabel()
  private var heightConstraint: NSLayoutConstraint?
  private var widthConstraint: NSLayoutConstraint?

  // MARK: Initialization

  public override init(frame: CGRect) {
    super.init(frame: frame)

    self.setup()
    self.updateStyle()
    self.updateSize()
    // TODO: [1] Handle trait changes
  }

  public required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: Lifecycle

  open override func layoutSubviews() {
    super.layoutSubviews()

    self.updateRadius()
  }

  open override func setTitle(_ title: String?, for state: UIControl.State) {
    super.setTitle(title, for: state)

    self.referenceLabel.text = title
    self.updateSize()
  }

  // MARK: Setup

  private func setup() {
    self.translatesAutoresizingMaskIntoConstraints = false
    self.widthConstraint = self.widthAnchor.constraint(equalToConstant: 0)
    self.widthConstraint?.priority = .defaultLow
    self.widthConstraint?.isActive = true
    self.heightConstraint = self.heightAnchor.constraint(equalToConstant: 0)
    self.heightConstraint?.priority = .defaultLow
    self.heightConstraint?.isActive = true
  }

  // MARK: Update

  public func updateRadius() {
    self.layer.cornerRadius = self.bounds.height * self.cornerRadius.coef
  }

  public func updateStyle() {
    let color = self.isEnabled ? self.color.uiColor : self.color.uiColor.withAlphaComponent(0.5)
    switch self.style {
    case .filled:
      self.layer.borderWidth = 0
      self.backgroundColor = color
      self.setTitleColor(.white, for: .normal)
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

  public func updateSize() {
    let height: CGFloat
    let horizontalPadding: CGFloat
    switch self.preferredSize {
    case .small:
      height = 36
      horizontalPadding = 8
    case .medium:
      height = 50
      horizontalPadding = 12
    case .large:
      height = 70
      horizontalPadding = 16
    }
    let textWidth = self.referenceLabel.sizeThatFits(.init(width: .greatestFiniteMagnitude, height: height)).width
    self.widthConstraint?.constant = textWidth + 2 * horizontalPadding
    self.heightConstraint?.constant = height
  }

  // MARK: Helpers

  @objc open func handleTraitChanges() {

  }
}
