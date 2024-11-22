import AutoLayout
import UIKit

open class UKModalController<VM: ModalVM>: UIViewController {
  public let model: VM

  public var content = UIView()
  public var containerWrapper = UIView()
  public let container = ContentSizedScrollView()
  public let overlay: UIView

  init(
    model: VM = .init(),
    content: (_ dismiss: @escaping (_ animated: Bool) -> Void) -> UIView
  ) {
    self.model = model

    switch model.overlayStyle {
    case .dimmed, .opaque:
      self.overlay = UIView()
    case .blured:
      self.overlay = UIVisualEffectView()
    }

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

  // MARK: - Setup

  open func setup() {
    self.view.addSubview(self.overlay)
    self.view.addSubview(self.containerWrapper)
    self.containerWrapper.addSubview(self.container)
    self.container.addSubview(self.content)

    self.overlay.addGestureRecognizer(UITapGestureRecognizer(
      target: self,
      action: #selector(self.handleOverlayTap)
    ))
  }

  @objc func handleOverlayTap() {
    guard self.model.closesOnOverlayTap else { return }
    self.dismiss(animated: true)
  }

  // MARK: - Style

  open func style() {
    Self.Style.overlay(self.overlay, model: self.model)
    Self.Style.containerWrapper(self.containerWrapper)
    Self.Style.container(self.container, model: self.model)
  }

  // MARK: - Layout

  open func layout() {
    self.overlay.allEdges()
    self.container.allEdges()

    self.content.top(self.model.contentPaddings.top)
    self.content.bottom(self.model.contentPaddings.bottom)
    self.content.leading(self.model.contentPaddings.leading, to: self.containerWrapper)
    self.content.trailing(self.model.contentPaddings.trailing, to: self.containerWrapper)

    self.containerWrapper.topAnchor.constraint(
      greaterThanOrEqualTo: self.view.safeAreaLayoutGuide.topAnchor,
      constant: 20
    ).isActive = true
    self.containerWrapper.leadingAnchor.constraint(
      greaterThanOrEqualTo: self.view.safeAreaLayoutGuide.leadingAnchor,
      constant: 20
    ).isActive = true
    self.containerWrapper.trailingAnchor.constraint(
      lessThanOrEqualTo: self.view.safeAreaLayoutGuide.trailingAnchor,
      constant: -20
    ).isActive = true
    self.containerWrapper.heightAnchor.constraint(
      greaterThanOrEqualToConstant: 80
    ).isActive = true

    let containerWidthConstraint = self.containerWrapper.width(400).width
    containerWidthConstraint?.priority = .defaultHigh

    self.containerWrapper.centerHorizontally()
  }
}

// MARK: - Style Helpers

extension UKModalController {
  enum Style {
    static func overlay(_ view: UIView, model: VM) {
      switch model.overlayStyle {
      case .dimmed:
        view.backgroundColor = .black.withAlphaComponent(0.7)
      case .opaque:
        view.backgroundColor = .clear
      case .blured:
        (view as? UIVisualEffectView)?.effect = UIBlurEffect(style: .systemUltraThinMaterial)
      }
    }
    static func containerWrapper(_ view: UIView) {
      view.backgroundColor = .systemBackground
      view.layer.cornerRadius = 25
      view.clipsToBounds = true
    }
    static func container(_ scrollView: UIScrollView, model: VM) {
      scrollView.backgroundColor = model.backgroundColor.uiColor
      scrollView.delaysContentTouches = false
      scrollView.contentInsetAdjustmentBehavior = .never
      scrollView.automaticallyAdjustsScrollIndicatorInsets = false
    }
  }
}
