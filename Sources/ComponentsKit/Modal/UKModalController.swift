import AutoLayout
import UIKit

open class UKModalController<VM: ModalVM>: UIViewController {
  public let model: VM

  public var content = UIView()
  public let container = UIView()
  public let dimOverlay = UIView()

  init(
    model: VM = .init(),
    content: (_ dismiss: @escaping (_ animated: Bool) -> Void) -> UIView
  ) {
    self.model = model

    super.init(nibName: nil, bundle: nil)

    self.content = content({ [weak self] animated in
      self?.dismiss(animated: animated)
    })

    self.modalPresentationStyle = .overFullScreen
    self.modalTransitionStyle = .crossDissolve
  }

  public required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  open override func viewDidLoad() {
    super.viewDidLoad()

    self.setup()
    self.style()
    self.layout()
  }

  open func setup() {
    self.view.addSubview(self.dimOverlay)
    self.view.addSubview(self.container)
    self.container.addSubview(self.content)

    self.dimOverlay.addGestureRecognizer(UITapGestureRecognizer(
      target: self,
      action: #selector(self.handleOverlayTap)
    ))
  }

  @objc func handleOverlayTap() {
    self.dismiss(animated: true)
  }

  open func style() {
    Self.Style.dimOverlay(self.dimOverlay)
    Self.Style.container(self.container, model: self.model)
  }

  open func layout() {
    self.dimOverlay.allEdges()
    self.content.allEdges()

    self.container.topAnchor.constraint(
      greaterThanOrEqualTo: self.view.safeAreaLayoutGuide.topAnchor,
      constant: 20
    ).isActive = true
    self.container.leadingAnchor.constraint(
      greaterThanOrEqualTo: self.view.safeAreaLayoutGuide.leadingAnchor,
      constant: 20
    ).isActive = true
    self.container.trailingAnchor.constraint(
      lessThanOrEqualTo: self.view.safeAreaLayoutGuide.trailingAnchor,
      constant: -20
    ).isActive = true
    self.container.heightAnchor.constraint(
      greaterThanOrEqualToConstant: 80
    ).isActive = true

    let containerWidthConstraint = self.container.width(400).width
    containerWidthConstraint?.priority = .defaultHigh

    self.container.centerHorizontally()
  }
}

extension UKModalController {
  enum Style {
    static func dimOverlay(_ view: UIView) {
      view.backgroundColor = .black.withAlphaComponent(0.7)
    }
    static func container(_ view: UIView, model: VM) {
      view.backgroundColor = .white
      view.layer.cornerRadius = 25
      view.clipsToBounds = true
    }
  }
}
