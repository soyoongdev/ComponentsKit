import UIKit

public class UKAlertController: UKCenterModalController {
  public let titleLabel = UILabel()
  public let subtitleLabel = UILabel()
  public let primaryButton = UKButton()
  public let secondaryButton = UKButton()
  public let buttonsStackView = UIStackView()

  public var primaryAction: (() -> Void)?
  public var secondaryAction: (() -> Void)?

  public init(
    model: AlertVM,
    primaryAction: (() -> Void)? = nil,
    secondaryAction: (() -> Void)? = nil
  ) {
    self.primaryAction = primaryAction
    self.secondaryAction = secondaryAction

    super.init(
      model: model.modalVM,
      body: { _ in UILabel() }
    )

    self.header = self.titleLabel
    self.body = self.subtitleLabel
    if model.primaryButton.isNotNil || model.secondaryButton.isNotNil {
      self.footer = self.buttonsStackView
    }

    self.titleLabel.text = model.title
    self.subtitleLabel.text = model.message
    if let primaryButtonVM = model.primaryButtonVM {
      self.buttonsStackView.addArrangedSubview(self.primaryButton)
      self.primaryButton.model = primaryButtonVM
    }
    if let secondaryButtonVM = model.secondaryButtonVM {
      self.buttonsStackView.addArrangedSubview(self.secondaryButton)
      self.secondaryButton.model = secondaryButtonVM
    }
  }

  required public init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  public override func setup() {
    super.setup()

    self.primaryButton.action = { [weak self] in
      self?.primaryAction?()
      self?.dismiss(animated: true)
    }
    self.secondaryButton.action = { [weak self] in
      self?.secondaryAction?()
      self?.dismiss(animated: true)
    }
  }

  public override func style() {
    super.style()

    Self.Style.titleLabel(self.titleLabel)
    Self.Style.subtitleLabel(self.subtitleLabel)
    Self.Style.buttonsStackView(self.buttonsStackView)
  }

  public override func updateViewConstraints() {
    super.updateViewConstraints()

    if self.buttonsStackView.arrangedSubviews.count == 2 {
      self.buttonsStackView.axis = .vertical
      let primaryButtonWidth = self.primaryButton.intrinsicContentSize.width
      let secondaryButtonWidth = self.secondaryButton.intrinsicContentSize.width

      // Since the `maxWidth` of the alert is always less than the width of the
      // screen, we can assume that the width of the container is equal to this
      // `maxWidth` value.
      let containerWidth = self.model.size.maxWidth
      let availableButtonsWidth = containerWidth
      - AlertVM.buttonsSpacing
      - self.model.contentPaddings.leading
      - self.model.contentPaddings.trailing

      if primaryButtonWidth + secondaryButtonWidth <= availableButtonsWidth {
        self.buttonsStackView.removeArrangedSubview(self.secondaryButton)
        self.buttonsStackView.insertArrangedSubview(self.secondaryButton, at: 0)

        self.buttonsStackView.axis = .horizontal
      } else {
        self.buttonsStackView.removeArrangedSubview(self.secondaryButton)
        self.buttonsStackView.insertArrangedSubview(self.secondaryButton, at: 1)

        self.buttonsStackView.axis = .vertical
      }
    } else {
      self.buttonsStackView.axis = .vertical
    }
  }
}

extension UKAlertController {
  fileprivate enum Style {
    static func titleLabel(_ label: UILabel) {
      label.font = UniversalFont.mdHeadline.uiFont
      label.textColor = UniversalColor.foreground.uiColor
      label.textAlignment = .center
      label.numberOfLines = 0
    }

    static func subtitleLabel(_ label: UILabel) {
      label.font = UniversalFont.mdBody.uiFont
      label.textColor = UniversalColor.secondaryForeground.uiColor
      label.textAlignment = .center
      label.numberOfLines = 0
    }

    static func buttonsStackView(_ stackView: UIStackView) {
      stackView.distribution = .fillEqually
      stackView.spacing = AlertVM.buttonsSpacing
    }
  }
}
