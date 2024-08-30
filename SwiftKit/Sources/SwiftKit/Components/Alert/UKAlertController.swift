import UIKit

open class UKAlertController: UIViewController {
  // MARK: Properties

  public let titleText: String?
  public let message: String?

  public var preferredButtonsLayout: AlertButtonsLayout = .horizontal()
  public var cornerRadius: PopoverRadius = .medium

  // MARK: Subviews

  public let container = UIView()
  public let scrollView = ContentSizedScrollView()
  public let titleLabel = UILabel()
  public let messageLabel = UILabel()
  public let buttonsStackView = UIStackView()

  // MARK: Initialization

  public init(
    title: String?,
    message: String?
  ) {
    self.titleText = title
    self.message = message

    super.init(nibName: nil, bundle: nil)

    self.modalPresentationStyle = .overFullScreen
    self.modalTransitionStyle = .crossDissolve
  }

  public required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: Lifecycle

  open override func viewDidLoad() {
    super.viewDidLoad()

    self.setup()
    self.style()
    self.layout()
  }

  // MARK: Add actions

  open func addAction(_ action: UKAlertAction) {
    let button = UKButton(model: action.model, action: action.action)
    self.buttonsStackView.addArrangedSubview(button)
  }

  // MARK: Setup

  func setup() {
    self.view.addSubview(self.container)
    self.container.addSubview(self.scrollView)
    self.scrollView.addSubview(self.titleLabel)
    self.scrollView.addSubview(self.messageLabel)
    self.scrollView.addSubview(self.buttonsStackView)
  }

  @objc open func handleCloseAlert() {
    self.dismiss(animated: true)
  }

  // MARK: Style

  func style() {
    Self.Style.mainView(self.view)
    Self.Style.container(self.container, radius: self.cornerRadius.value)
    Self.Style.scrollView(self.scrollView)
    Self.Style.titleLabel(self.titleLabel, text: self.titleText)
    Self.Style.messageLabel(self.messageLabel, text: self.message)

    switch self.preferredButtonsLayout {
    case .vertical:
      Self.Style.buttonsStackView(self.buttonsStackView, axis: .vertical)
    case .horizontal(let distribution):
      let totalButtonsWidth = self.buttonsStackView.arrangedSubviews.reduce(0) { partialResult, button in
        return partialResult + button.intrinsicContentSize.width
      }
      let totalSpacing = Self.Layout.stackViewHorizontalSpacing * CGFloat(self.buttonsStackView.arrangedSubviews.count - 1)
      let totalWidth = Self.Layout.horizontalMargin * 2 + totalButtonsWidth + totalSpacing

      if totalWidth < Self.Layout.containerWidth {
        Self.Style.buttonsStackView(self.buttonsStackView, axis: .horizontal(distribution))
      } else {
        Self.Style.buttonsStackView(self.buttonsStackView, axis: .vertical)
      }
    }
  }

  // MARK: Layout

  func layout() {
    self.container.width(Self.Layout.containerWidth)
    self.container.centerHorizontally()
    self.container.centerVertically()
    self.container.topAnchor.constraint(
      greaterThanOrEqualTo: self.view.safeAreaLayoutGuide.topAnchor,
      constant: 20
    ).isActive = true
    self.container.bottomAnchor.constraint(
      lessThanOrEqualTo: self.view.safeAreaLayoutGuide.bottomAnchor,
      constant: -20
    ).isActive = true

    self.scrollView.horizontally(0)
    self.scrollView.vertically(0)

    self.titleLabel.top(Self.Layout.titleTopInset)
    self.titleLabel.horizontally(Self.Layout.horizontalMargin)

    self.messageLabel.below(of: self.titleLabel, padding: 17)
    self.messageLabel.horizontally(Self.Layout.horizontalMargin)

    if self.buttonsStackView.arrangedSubviews.isEmpty {
      self.messageLabel.bottom(16)
    } else {
      self.buttonsStackView.below(of: self.messageLabel, padding: 22)
      self.buttonsStackView.horizontally(Self.Layout.horizontalMargin)
      self.buttonsStackView.bottom(16)
    }
  }
}

// MARK: - Style Helpers

extension UKAlertController {
  fileprivate enum Style {
    static func mainView(_ view: UIView) {
      view.backgroundColor = .black.withAlphaComponent(0.5)
    }

    static func container(_ view: UIView, radius: CGFloat) {
      view.backgroundColor = .white
      view.layer.cornerRadius = radius
    }

    static func scrollView(_ scrollView: UIScrollView) {
      scrollView.delaysContentTouches = false
    }

    static func titleLabel(_ label: UILabel, text: String?) {
      label.text = text
      label.font = .boldSystemFont(ofSize: 25)
      label.textColor = .label
      label.textAlignment = .center
      label.numberOfLines = 0
    }

    static func messageLabel(_ label: UILabel, text: String?) {
      label.text = text
      label.font = .systemFont(ofSize: 16)
      label.textColor = .secondaryLabel
      label.textAlignment = .center
      label.numberOfLines = 0
    }

    static func buttonsStackView(_ stackView: UIStackView, axis: AlertButtonsLayout) {
      switch axis {
      case .vertical:
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.distribution = .fill
      case .horizontal(let distribution):
        stackView.axis = .horizontal
        stackView.spacing = UKAlertController.Layout.stackViewHorizontalSpacing
        switch distribution {
        case .fillEqually:
          stackView.distribution = .fillEqually
        case .fillProportionally:
          stackView.distribution = .fillProportionally
        }
      }
      stackView.alignment = .fill
    }
  }
}

// MARK: - Layout Helpers

extension UKAlertController {
  fileprivate enum Layout {
    static let containerWidth: CGFloat = 300
    static let titleTopInset: CGFloat = 20
    static let horizontalMargin: CGFloat = 16
    static let stackViewHorizontalSpacing: CGFloat = 10
  }
}
