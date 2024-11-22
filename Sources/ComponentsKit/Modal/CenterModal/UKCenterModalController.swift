import UIKit

public class UKCenterModalController: UKModalController<CenterModalVM> {
  public override init(
    model: CenterModalVM = .init(),
    content: (_ dismiss: @escaping (_ animated: Bool) -> Void) -> UIView
  ) {
    super.init(model: model, content: content)
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
