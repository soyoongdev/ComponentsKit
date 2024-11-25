import AutoLayout
import UIKit

open class UKModalController<VM: ModalVM>: UIViewController {
  public let model: VM

  public var header: UIView?
  public var body = UIView()
  public var footer: UIView?
  public var container = UIView()
  public let content = UIView()
  public let bodyWrapper = ContentSizedScrollView()
  public let overlay: UIView

  init(
    model: VM = .init(),
    header: ((_ dismiss: @escaping (_ animated: Bool) -> Void) -> UIView)? = nil,
    body: (_ dismiss: @escaping (_ animated: Bool) -> Void) -> UIView,
    footer: ((_ dismiss: @escaping (_ animated: Bool) -> Void) -> UIView)? = nil
  ) {
    self.model = model

    switch model.overlayStyle {
    case .dimmed, .opaque:
      self.overlay = UIView()
    case .blurred:
      self.overlay = UIVisualEffectView()
    }

    super.init(nibName: nil, bundle: nil)

    self.header = header?({ [weak self] animated in
      self?.dismiss(animated: animated)
    })
    self.body = body({ [weak self] animated in
      self?.dismiss(animated: animated)
    })
    self.footer = footer?({ [weak self] animated in
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
    self.view.addSubview(self.container)
    self.container.addSubview(self.content)
    if let header {
      self.content.addSubview(header)
    }
    self.content.addSubview(self.bodyWrapper)
    if let footer {
      self.content.addSubview(footer)
    }

    self.bodyWrapper.addSubview(self.body)

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
    Self.Style.container(self.container)
    Self.Style.content(self.content, model: self.model)
    Self.Style.bodyWrapper(self.bodyWrapper)
  }

  // MARK: - Layout

  open func layout() {
    self.overlay.allEdges()
    self.content.allEdges()

    if let header {
      header.top(self.model.contentPaddings.top)
      header.leading(self.model.contentPaddings.leading)
      header.trailing(self.model.contentPaddings.trailing)
      header.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)

      self.bodyWrapper.below(header, padding: self.model.contentSpacing)
      self.body.top()
    } else {
      self.bodyWrapper.top()
      self.body.top(self.model.contentPaddings.top)
    }

    if let footer {
      footer.bottom(self.model.contentPaddings.top)
      footer.leading(self.model.contentPaddings.leading)
      footer.trailing(self.model.contentPaddings.trailing)
      footer.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)

      self.bodyWrapper.above(footer, padding: self.model.contentSpacing)
      self.body.bottom()
    } else {
      self.bodyWrapper.bottom()
      self.body.bottom(self.model.contentPaddings.top)
    }

    self.bodyWrapper.horizontally()
    self.bodyWrapper.setContentCompressionResistancePriority(.defaultLow, for: .vertical)

    self.body.leading(self.model.contentPaddings.leading, to: self.container)
    self.body.trailing(self.model.contentPaddings.trailing, to: self.container)

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

// MARK: - Style Helpers

extension UKModalController {
  enum Style {
    static func overlay(_ view: UIView, model: VM) {
      switch model.overlayStyle {
      case .dimmed:
        view.backgroundColor = .black.withAlphaComponent(0.7)
      case .opaque:
        view.backgroundColor = .clear
      case .blurred:
        (view as? UIVisualEffectView)?.effect = UIBlurEffect(style: .systemUltraThinMaterial)
      }
    }
    static func container(_ view: UIView) {
      view.backgroundColor = Palette.Base.background.uiColor
      view.layer.cornerRadius = 25
      view.clipsToBounds = true
    }
    static func content(_ view: UIView, model: VM) {
      view.backgroundColor = model.backgroundColor.uiColor
    }
    static func bodyWrapper(_ scrollView: UIScrollView) {
      scrollView.delaysContentTouches = false
      scrollView.contentInsetAdjustmentBehavior = .never
      scrollView.automaticallyAdjustsScrollIndicatorInsets = false
    }
  }
}
