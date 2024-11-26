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

  public override func layout() {
    super.layout()

    self.container.bottomAnchor.constraint(
      lessThanOrEqualTo: self.view.safeAreaLayoutGuide.bottomAnchor,
      constant: -self.model.outerPaddings.bottom
    ).isActive = true
    self.container.centerVertically()
  }
}
