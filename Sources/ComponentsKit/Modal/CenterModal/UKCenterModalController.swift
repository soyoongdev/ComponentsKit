import UIKit

public class UKCenterModalController: UKModalController<CenterModalVM> {
  public override init(
    model: CenterModalVM = .init(),
    header: ((_ dismiss: @escaping (_ animated: Bool) -> Void) -> UIView)? = nil,
    body: (_ dismiss: @escaping (_ animated: Bool) -> Void) -> UIView,
    footer: ((_ dismiss: @escaping (_ animated: Bool) -> Void) -> UIView)? = nil
  ) {
    super.init(model: model, header: header, body: body, footer: footer)
  }

  required public init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  public override func layout() {
    super.layout()

    self.container.bottomAnchor.constraint(
      lessThanOrEqualTo: self.view.safeAreaLayoutGuide.bottomAnchor,
      constant: -20
    ).isActive = true
    self.container.centerVertically()
  }
}
