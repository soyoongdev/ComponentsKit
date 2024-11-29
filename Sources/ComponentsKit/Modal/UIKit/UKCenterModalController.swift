import UIKit

public class UKCenterModalController: UKModalController<CenterModalVM> {
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

  public override func layout() {
    super.layout()

    self.container.bottomAnchor.constraint(
      lessThanOrEqualTo: self.view.safeAreaLayoutGuide.bottomAnchor,
      constant: -self.model.outerPaddings.bottom
    ).isActive = true
    self.container.centerVertically()
  }

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
