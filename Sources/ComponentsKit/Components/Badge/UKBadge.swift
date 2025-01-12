import AutoLayout
import UIKit

/// A UIKit component that displays a badge.
open class UKBadge: UIView, UKComponent {
  // MARK: - Properties

  /// A model that defines the appearance properties.
  public var model: BadgeVM {
    didSet {
      self.update(oldValue)
    }
  }

  private var titleLabelConstraints: LayoutConstraints = .init()

  // MARK: Subviews

  /// A label that displays the title from the model.
  public var titleLabel = UILabel()

  // MARK: - UIView Properties

  open override var intrinsicContentSize: CGSize {
    return self.sizeThatFits(UIView.layoutFittingExpandedSize)
  }

  // MARK: - Initialization

  /// Initializes a new instance of `UKBadge`.
  /// - Parameter model: A model that defines the appearance properties for the badge.
  public init(model: BadgeVM = .init()) {
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
    self.addSubview(self.titleLabel)

    if #available(iOS 17.0, *) {
      self.registerForTraitChanges([UITraitUserInterfaceStyle.self]) { (view: Self, _: UITraitCollection) in
        view.handleTraitChanges()
      }
    }
  }

  // MARK: - Style

  private func style() {
    Self.Style.mainView(self, model: self.model)
    Self.Style.titleLabel(self.titleLabel, model: self.model)
  }

  // MARK: - Layout

  private func layout() {
    self.titleLabelConstraints = self.titleLabel.horizontally(self.model.horizontalPadding)
    self.titleLabel.center()

    self.titleLabelConstraints.leading?.priority = .defaultHigh
    self.titleLabelConstraints.trailing?.priority = .defaultHigh
  }

  open override func layoutSubviews() {
    super.layoutSubviews()

    self.layer.cornerRadius = self.model.cornerRadius.value()
  }

  // MARK: - Update

  public func update(_ oldModel: BadgeVM) {
    guard self.model != oldModel else { return }

    self.style()
    self.titleLabelConstraints.leading?.constant = self.model.horizontalPadding
    self.titleLabelConstraints.trailing?.constant = -self.model.horizontalPadding

    self.invalidateIntrinsicContentSize()
    self.setNeedsLayout()
  }

  // MARK: - UIView Methods

  open override func sizeThatFits(_ size: CGSize) -> CGSize {
    let contentSize = self.titleLabel.sizeThatFits(size)

    let width = contentSize.width + self.model.horizontalPadding * 2
    let height = contentSize.height + self.model.verticalPadding * 2

    return CGSize(
      width: min(width, size.width),
      height: min(height, size.height)
    )
  }

  open override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
    super.traitCollectionDidChange(previousTraitCollection)
    self.handleTraitChanges()
  }

  // MARK: - Helpers

  @objc private func handleTraitChanges() {
    self.backgroundColor = self.model.backgroundColor?.uiColor
  }
}

// MARK: - Style Helpers

extension UKBadge {
  fileprivate enum Style {
    static func mainView(_ view: UIView, model: BadgeVM) {
      view.backgroundColor = model.backgroundColor?.uiColor
      view.layer.cornerRadius = model.cornerRadius.value()
    }
    static func titleLabel(_ label: UILabel, model: BadgeVM) {
      label.textAlignment = .center
      label.text = model.title
      label.font = model.preferredFont.uiFont
      label.textColor = model.foregroundColor.uiColor
    }
  }
}
