import UIKit

public class UKAlertController: UKCenterModalController {
  public let alertVM: AlertVM

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
    self.alertVM = model

    self.primaryAction = primaryAction
    self.secondaryAction = secondaryAction

    super.init(model: model.modalVM)
  }

  required public init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  public override func setup() {
    if self.alertVM.title.isNotNilAndEmpty,
       self.alertVM.message.isNotNilAndEmpty {
      self.header = self.titleLabel
      self.body = self.subtitleLabel
    } else if self.alertVM.title.isNotNilAndEmpty {
      self.body = self.titleLabel
    } else {
      self.body = self.subtitleLabel
    }
    if self.alertVM.primaryButton.isNotNil || self.alertVM.secondaryButton.isNotNil {
      self.footer = self.buttonsStackView
    }

    if self.alertVM.primaryButton.isNotNil {
      self.buttonsStackView.addArrangedSubview(self.primaryButton)
    }
    if self.alertVM.secondaryButton.isNotNil {
      self.buttonsStackView.addArrangedSubview(self.secondaryButton)
    }

    self.primaryButton.action = { [weak self] in
      self?.primaryAction?()
      self?.dismiss(animated: true)
    }
    self.secondaryButton.action = { [weak self] in
      self?.secondaryAction?()
      self?.dismiss(animated: true)
    }

    // NOTE: Labels and stack view should be assigned to `header`, `body`
    // and `footer` before calling the superview's method, otherwise they
    // won't be added to the list of subviews.
    super.setup()
  }

  public override func style() {
    super.style()

    Self.Style.titleLabel(self.titleLabel, text: self.alertVM.title)
    Self.Style.subtitleLabel(self.subtitleLabel, text: self.alertVM.message)
    Self.Style.buttonsStackView(self.buttonsStackView)

    if let primaryButtonVM = self.alertVM.primaryButtonVM {
      self.primaryButton.model = primaryButtonVM
    }
    if let secondaryButtonVM = self.alertVM.secondaryButtonVM {
      self.secondaryButton.model = secondaryButtonVM
    }
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
      let availableButtonWidth = availableButtonsWidth / 2

      if primaryButtonWidth <= availableButtonWidth,
         secondaryButtonWidth <= availableButtonWidth {
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
    static func titleLabel(_ label: UILabel, text: String?) {
      label.text = text
      label.font = UniversalFont.mdHeadline.uiFont
      label.textColor = UniversalColor.foreground.uiColor
      label.textAlignment = .center
      label.numberOfLines = 0
    }

    static func subtitleLabel(_ label: UILabel, text: String?) {
      label.text = text
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
