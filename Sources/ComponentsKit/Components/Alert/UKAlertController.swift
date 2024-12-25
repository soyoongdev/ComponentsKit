import UIKit

/// A controller that presents an alert with a title, message, and up to two action buttons.
///
/// All actions in an alert dismiss the alert after the action runs. If no actions are present, a standard “OK” action is included.
///
/// - Example:
/// ```swift
/// let alert = UKAlertController(
///   model: .init { alertVM in
///     alertVM.title = "My Alert"
///     alertVM.message = "This is an alert."
///     alertVM.primaryButton = .init { buttonVM in
///       buttonVM.title = "OK"
///       buttonVM.color = .primary
///       buttonVM.style = .filled
///     }
///     alertVM.secondaryButton = .init { buttonVM in
///       buttonVM.title = "Cancel"
///       buttonVM.style = .light
///     }
///   }, primaryAction: {
///     NSLog("Primary button tapped")
///   }, secondaryAction: {
///     NSLog("Secondary button tapped")
///   }
/// )
///
/// vc.present(alert, animated: true)
/// ```
public class UKAlertController: UKCenterModalController {
  // MARK: - Properties

  /// A model that defines the appearance properties for an alert.
  public let alertVM: AlertVM

  /// The primary action to be executed when the primary button is tapped.
  public var primaryAction: (() -> Void)?
  /// The secondary action to be executed when the secondary button is tapped.
  public var secondaryAction: (() -> Void)?

  // MARK: - Subviews

  /// The label used to display the title of the alert.
  public let titleLabel = UILabel()
  /// The label used to display the subtitle or message of the alert.
  public let subtitleLabel = UILabel()
  /// The button representing the primary action in the alert.
  public let primaryButton = UKButton()
  /// The button representing the secondary action in the alert.
  public let secondaryButton = UKButton()
  /// A stack view that arranges the primary and secondary buttons.
  public let buttonsStackView = UIStackView()

  // MARK: - Initialization

  /// Initializer.
  ///
  /// - Parameters:
  ///   - model: A model that defines the appearance properties for an alert.
  ///   - primaryAction: An optional closure executed when the primary button is tapped.
  ///   - secondaryAction: An optional closure executed when the secondary button is tapped.
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

  // MARK: - Setup

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
    self.footer = self.buttonsStackView

    if self.alertVM.primaryButtonVM.isNotNil {
      self.buttonsStackView.addArrangedSubview(self.primaryButton)
    }
    if self.alertVM.secondaryButtonVM.isNotNil {
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

  // MARK: - Style

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

  // MARK: - Layout

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

// MARK: - Style Helpers

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
