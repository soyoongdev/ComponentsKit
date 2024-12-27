import UIKit

/// A center-aligned modal controller.
///
/// - Example:
/// ```swift
/// let centerModal = UKCenterModalController(
///   model: CenterModalVM(),
///   header: { _ in
///     let headerLabel = UILabel()
///     headerLabel.text = "Header"
///     return headerLabel
///   },
///   body: { _ in
///     let bodyLabel = UILabel()
///     bodyLabel.text = "This is the body content of the modal."
///     bodyLabel.numberOfLines = 0
///     return bodyLabel
///   },
///   footer: { dismiss in
///     return UKButton(model: .init {
///       $0.title = "Close"
///     }) {
///       dismiss(true)
///     }
///   }
/// )
///
/// vc.present(centerModal, animated: true)
/// ```
public class UKCenterModalController: UKModalController<CenterModalVM> {
  // MARK: - Initialization

  /// Initializer.
  ///
  /// - Parameters:
  ///   - model: A model that defines the appearance properties.
  ///   - header: An optional content block for the modal's header.
  ///   - body: The main content block for the modal.
  ///   - footer: An optional content block for the modal's footer.
  public override init(
    model: CenterModalVM = .init(),
    header: Content? = nil,
    body: Content,
    footer: Content? = nil
  ) {
    super.init(model: model, header: header, body: body, footer: footer)
  }

  required public init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Lifecycle

  public override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    self.overlay.alpha = 0
    self.container.alpha = 0
  }

  public override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)

    UIView.animate(withDuration: self.model.transition.value) {
      self.overlay.alpha = 1
      self.container.alpha = 1
    }
  }

  // MARK: - Layout

  public override func layout() {
    super.layout()

    self.container.bottomAnchor.constraint(
      lessThanOrEqualTo: self.view.safeAreaLayoutGuide.bottomAnchor,
      constant: -self.model.outerPaddings.bottom
    ).isActive = true
    self.container.centerVertically()
  }

  // MARK: - UIViewController Methods

  public override func dismiss(
    animated flag: Bool,
    completion: (() -> Void)? = nil
  ) {
    UIView.animate(withDuration: self.model.transition.value) {
      self.overlay.alpha = 0
      self.container.alpha = 0
    } completion: { _ in
      super.dismiss(animated: false)
    }
  }
}

// MARK: - UIViewController + Present Center Modal

extension UIViewController {
  public func present(
    _ vc: UKCenterModalController,
    animated: Bool,
    completion: (() -> Void)? = nil
  ) {
    self.present(vc as UIViewController, animated: false)
  }
}
