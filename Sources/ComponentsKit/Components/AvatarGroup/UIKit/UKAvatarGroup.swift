import AutoLayout
import UIKit

/// A UIKit component that displays a group of avatars.
open class UKAvatarGroup: UIView, UKComponent {
  // MARK: - Properties

  /// A model that defines the appearance properties.
  public var model: AvatarGroupVM {
    didSet {
      self.update(oldValue)
    }
  }

  // MARK: - Subviews

  /// The stack view that contains avatars.
  public var stackView = UIStackView()

  // MARK: - Initializers

  /// Initializer.
  /// - Parameters:
  ///   - model: A model that defines the appearance properties.
  public init(model: AvatarGroupVM = .init()) {
    self.model = model

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
    self.addSubview(self.stackView)
    self.model.identifiedAvatarVMs.forEach { _, avatarVM in
      self.stackView.addArrangedSubview(AvatarContainer(
        avatarVM: avatarVM,
        groupVM: self.model
      ))
    }
  }

  // MARK: - Style

  private func style() {
    Self.Style.stackView(self.stackView, model: self.model)
  }

  // MARK: - Layout

  private func layout() {
    self.stackView.vertically()
    self.stackView.centerHorizontally()
    self.stackView.leadingAnchor.constraint(
      greaterThanOrEqualTo: self.leadingAnchor
    ).isActive = true
    self.stackView.trailingAnchor.constraint(
      lessThanOrEqualTo: self.trailingAnchor
    ).isActive = true
  }

  // MARK: - Update

  public func update(_ oldModel: AvatarGroupVM) {
    guard self.model != oldModel else { return }

    let avatarVMs = self.model.identifiedAvatarVMs.map(\.1)
    self.addOrRemoveArrangedSubviews(newNumber: avatarVMs.count)

    self.stackView.arrangedSubviews.enumerated().forEach { index, view in
      (view as? AvatarContainer)?.update(
        avatarVM: avatarVMs[index],
        groupVM: self.model
      )
    }
    self.style()
  }

  private func addOrRemoveArrangedSubviews(newNumber: Int) {
    let diff = newNumber - self.stackView.arrangedSubviews.count
    if diff > 0 {
      for _ in 0 ..< diff {
        self.stackView.addArrangedSubview(AvatarContainer(avatarVM: .init(), groupVM: self.model))
      }
    } else if diff < 0 {
      for _ in 0 ..< abs(diff) {
        if let view = self.stackView.arrangedSubviews.first {
          self.stackView.removeArrangedSubview(view)
          view.removeFromSuperview()
        }
      }
    }
  }

  // MARK: - Layout

  open override func layoutSubviews() {
    super.layoutSubviews()

    self.stackView.arrangedSubviews.forEach { view in
      view.layer.cornerRadius = self.model.cornerRadius.value(for: view.bounds.height)
    }
  }
}

// MARK: - Style Helpers

extension UKAvatarGroup {
  fileprivate enum Style {
    static func stackView(_ view: UIStackView, model: Model) {
      view.axis = .horizontal
      view.spacing = model.spacing
    }
  }
}
