import UIKit

// MARK: - AnchoredConstraints

/// Contains constraints of the view.
public struct AnchoredConstraints {
  /// Top constraint.
  public var top: NSLayoutConstraint?
  /// Leading constraint.
  public var leading: NSLayoutConstraint?
  /// Bottom constraint.
  public var bottom: NSLayoutConstraint?
  /// Trailing constraint.
  public var trailing: NSLayoutConstraint?
  /// Vertical constraint.
  public var vertical: NSLayoutConstraint?
  /// Horizontal constraint.
  public var horizontal: NSLayoutConstraint?
  /// Width constraint.
  public var width: NSLayoutConstraint?
  /// Height constraint.
  public var height: NSLayoutConstraint?

  /// Array of all constraints.
  public var allConstraints: [NSLayoutConstraint?] {
    return [self.top, self.leading, self.bottom, self.trailing, self.vertical, self.horizontal, self.width, self.height]
  }

  /// Memberwise initializer.
  public init(
    top: NSLayoutConstraint? = nil,
    leading: NSLayoutConstraint? = nil,
    bottom: NSLayoutConstraint? = nil,
    trailing: NSLayoutConstraint? = nil,
    vertical: NSLayoutConstraint? = nil,
    horizontal: NSLayoutConstraint? = nil,
    width: NSLayoutConstraint? = nil,
    height: NSLayoutConstraint? = nil
  ) {
    self.top = top
    self.leading = leading
    self.bottom = bottom
    self.trailing = trailing
    self.vertical = vertical
    self.horizontal = horizontal
    self.width = width
    self.height = height
  }

  /// Activates existing constraints.
  public func activate() {
    self.allConstraints.forEach { $0?.isActive = true }
  }

  /// Deactivates existing constraints.
  public func deactivate() {
    self.allConstraints.forEach { $0?.isActive = false }
  }

  /// Updates insets for the current constraints.
  public func updateInsets(_ insets: UIEdgeInsets) {
    self.top?.constant = insets.top
    self.bottom?.constant = -insets.bottom
    self.leading?.constant = insets.left
    self.trailing?.constant = -insets.right
  }
}

// MARK: - Layout Helpers

extension UIView {
  @discardableResult
  public func pinToEdges(
    _ edges: UIRectEdge = .all,
    insets: UIEdgeInsets = .zero
  ) -> AnchoredConstraints {
    var constraints = AnchoredConstraints()

    guard let superview = superview else {
      assertionFailure("\(Self.self) is not added to superview")
      return constraints
    }

    self.translatesAutoresizingMaskIntoConstraints = false

    if edges.contains(.top) {
      constraints.top = self.topAnchor.constraint(equalTo: superview.topAnchor, constant: insets.top)
    }
    if edges.contains(.bottom) {
      constraints.bottom = self.bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: -insets.bottom)
    }
    if edges.contains(.left) {
      constraints.leading = self.leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: insets.left)
    }
    if edges.contains(.right) {
      constraints.trailing = self.trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: -insets.right)
    }
    constraints.activate()

    return constraints
  }

  @discardableResult
  public func pinToEdges(
    _ edges: UIRectEdge = .all,
    padding: CGFloat
  ) -> AnchoredConstraints {
    return self.pinToEdges(
      edges,
      insets: .init(top: padding, left: padding, bottom: padding, right: padding)
    )
  }
}

extension UIView {
  @discardableResult
  public func pinToSafeEdges(
    _ edges: UIRectEdge = .all,
    insets: UIEdgeInsets = .zero
  ) -> AnchoredConstraints {
    var constraints = AnchoredConstraints()

    guard let superview else {
      assertionFailure("\(Self.self) is not added to superview")
      return constraints
    }

    self.translatesAutoresizingMaskIntoConstraints = false

    if edges.contains(.top) {
      constraints.top = self.topAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.topAnchor, constant: insets.top)
    }
    if edges.contains(.bottom) {
      constraints.bottom = self.bottomAnchor.constraint(
        equalTo: superview.safeAreaLayoutGuide.bottomAnchor,
        constant: -insets.bottom
      )
    }
    if edges.contains(.left) {
      constraints.leading = self.leadingAnchor.constraint(
        equalTo: superview.safeAreaLayoutGuide.leadingAnchor,
        constant: insets.left
      )
    }
    if edges.contains(.right) {
      constraints.trailing = self.trailingAnchor.constraint(
        equalTo: superview.safeAreaLayoutGuide.trailingAnchor,
        constant: -insets.right
      )
    }
    constraints.activate()

    return constraints
  }

  @discardableResult
  public func pinToSafeEdges(
    _ edges: UIRectEdge = .all,
    padding: CGFloat
  ) -> AnchoredConstraints {
    return self.pinToSafeEdges(
      edges,
      insets: .init(top: padding, left: padding, bottom: padding, right: padding)
    )
  }
}

extension UIView {
  @discardableResult
  public func width(_ constant: CGFloat) -> NSLayoutConstraint {
    self.translatesAutoresizingMaskIntoConstraints = false
    let constraint = self.widthAnchor.constraint(equalToConstant: constant)
    constraint.isActive = true
    constraint.priority = UILayoutPriority(999)
    return constraint
  }

  @discardableResult
  public func height(_ constant: CGFloat) -> NSLayoutConstraint {
    self.translatesAutoresizingMaskIntoConstraints = false
    let constraint = self.heightAnchor.constraint(equalToConstant: constant)
    constraint.isActive = true
    constraint.priority = UILayoutPriority(999)
    return constraint
  }

  @discardableResult
  public func size(_ size: CGSize) -> AnchoredConstraints {
    let widthConstraint = self.width(size.width)
    let heightConstraint = self.height(size.height)
    return AnchoredConstraints(width: widthConstraint, height: heightConstraint)
  }

  @discardableResult
  public func size(_ constant: CGFloat) -> AnchoredConstraints {
    return self.size(.init(width: constant, height: constant))
  }
}

extension UIView {
  @discardableResult
  public func leading(_ padding: CGFloat = 0, to view: UIView? = nil) -> NSLayoutConstraint? {
    self.translatesAutoresizingMaskIntoConstraints = false
    if let view = view ?? self.superview {
      let constraint = self.leadingAnchor.constraint(
        equalTo: view.leadingAnchor,
        constant: padding
      )
      constraint.isActive = true
      return constraint
    } else {
      assertionFailure("\(Self.self) is not added to superview")
      return nil
    }
  }

  @discardableResult
  public func trailing(_ padding: CGFloat = 0, to view: UIView? = nil) -> NSLayoutConstraint? {
    self.translatesAutoresizingMaskIntoConstraints = false
    if let view = view ?? self.superview {
      let constraint = self.trailingAnchor.constraint(
        equalTo: view.trailingAnchor,
        constant: -padding
      )
      constraint.isActive = true
      return constraint
    } else {
      assertionFailure("\(Self.self) is not added to superview")
      return nil
    }
  }

  @discardableResult
  public func top(_ padding: CGFloat = 0, to view: UIView? = nil) -> NSLayoutConstraint? {
    self.translatesAutoresizingMaskIntoConstraints = false
    if let view = view ?? self.superview {
      let constraint = self.topAnchor.constraint(
        equalTo: view.topAnchor,
        constant: padding
      )
      constraint.isActive = true
      return constraint
    } else {
      assertionFailure("\(Self.self) is not added to superview")
      return nil
    }
  }

  @discardableResult
  public func bottom(_ padding: CGFloat = 0, to view: UIView? = nil) -> NSLayoutConstraint? {
    self.translatesAutoresizingMaskIntoConstraints = false
    if let view = view ?? self.superview {
      let constraint = self.bottomAnchor.constraint(
        equalTo: view.bottomAnchor,
        constant: -padding
      )
      constraint.isActive = true
      return constraint
    } else {
      assertionFailure("\(Self.self) is not added to superview")
      return nil
    }
  }
}

extension UIView {
  @discardableResult
  public func safeTop(_ padding: CGFloat = 0) -> NSLayoutConstraint? {
    if let superview {
      let constraint = self.topAnchor.constraint(
        equalTo: superview.safeAreaLayoutGuide.topAnchor,
        constant: padding
      )
      constraint.isActive = true
      return constraint
    } else {
      assertionFailure("\(Self.self) is not added to superview")
      return nil
    }
  }

  @discardableResult
  public func safeBottom(_ padding: CGFloat = 0) -> NSLayoutConstraint? {
    if let superview {
      let constraint = self.bottomAnchor.constraint(
        equalTo: superview.safeAreaLayoutGuide.bottomAnchor,
        constant: -padding
      )
      constraint.isActive = true
      return constraint
    } else {
      assertionFailure("\(Self.self) is not added to superview")
      return nil
    }
  }
}

extension UIView {
  @discardableResult
  public func horizontally(_ padding: CGFloat) -> AnchoredConstraints {
    return self.pinToSafeEdges([.left, .right], padding: padding)
  }

  @discardableResult
  public func vertically(_ padding: CGFloat) -> AnchoredConstraints {
    return self.pinToSafeEdges([.top, .bottom], padding: padding)
  }
}

extension UIView {
  /// Align the view after the passed view.
  @discardableResult
  public func after(of view: UIView, padding: CGFloat) -> NSLayoutConstraint? {
    self.translatesAutoresizingMaskIntoConstraints = false
    let constraint = self.leadingAnchor.constraint(
      equalTo: view.trailingAnchor,
      constant: padding
    )
    constraint.isActive = true
    return constraint
  }

  /// Align the view before the passed view.
  @discardableResult
  public func before(of view: UIView, padding: CGFloat) -> NSLayoutConstraint? {
    self.translatesAutoresizingMaskIntoConstraints = false
    let constraint = self.trailingAnchor.constraint(
      equalTo: view.leadingAnchor,
      constant: -padding
    )
    constraint.isActive = true
    return constraint
  }

  /// Align the view below the passed view.
  @discardableResult
  public func below(of view: UIView, padding: CGFloat) -> NSLayoutConstraint? {
    self.translatesAutoresizingMaskIntoConstraints = false
    let constraint = self.topAnchor.constraint(
      equalTo: view.bottomAnchor,
      constant: padding
    )
    constraint.isActive = true
    return constraint
  }

  /// Align the view above the passed view.
  @discardableResult
  public func above(of view: UIView, padding: CGFloat) -> NSLayoutConstraint? {
    self.translatesAutoresizingMaskIntoConstraints = false
    let constraint = self.bottomAnchor.constraint(
      equalTo: view.topAnchor,
      constant: -padding
    )
    constraint.isActive = true
    return constraint
  }
}

extension UIView {
  @discardableResult
  public func centerVertically(_ constant: CGFloat = 0, to view: UIView? = nil) -> NSLayoutConstraint? {
    guard let view = view ?? self.superview else {
      assertionFailure("\(Self.self) is not added to superview")
      return nil
    }

    self.translatesAutoresizingMaskIntoConstraints = false

    let vertical = self.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: constant)
    vertical.priority = .defaultHigh
    vertical.isActive = true
    return vertical
  }

  @discardableResult
  public func centerHorizontally(_ constant: CGFloat = 0, to view: UIView? = nil) -> NSLayoutConstraint? {
    guard let view = view ?? self.superview else {
      assertionFailure("\(Self.self) is not added to superview")
      return nil
    }

    translatesAutoresizingMaskIntoConstraints = false

    let horizontal = self.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: constant)
    horizontal.priority = .defaultHigh
    horizontal.isActive = true
    return horizontal
  }
}
