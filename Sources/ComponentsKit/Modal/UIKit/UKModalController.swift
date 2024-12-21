import AutoLayout
import UIKit

/// A generic class that defines shared behavior for modal controllers.
open class UKModalController<VM: ModalVM>: UIViewController {
  // MARK: - Typealiases

  /// A typealias for content providers, which create views for the header, body, or footer.
  /// The content provider closure receives a dismiss action that can be called to close the modal.
  public typealias Content = (_ dismiss: @escaping (_ animated: Bool) -> Void) -> UIView

  // MARK: - Properties

  /// A model that defines the appearance properties.
  public let model: VM

  /// The optional header view of the modal.
  public var header: UIView?
  /// The main body view of the modal.
  public var body = UIView()
  /// The optional footer view of the modal.
  public var footer: UIView?
  /// The container view that holds the modal's content.
  public let container = UIView()
  /// The content view inside the container, holding the header, body, and footer.
  public let content = UIView()
  /// A scrollable wrapper for the body content.
  public let bodyWrapper: UIScrollView = ContentSizedScrollView()
  /// The overlay view that appears behind the modal.
  public let overlay: UIView

  // MARK: - Initialization

  init(
    model: VM = .init(),
    header: Content? = nil,
    body: Content,
    footer: Content? = nil
  ) {
    self.model = model

    switch model.overlayStyle {
    case .dimmed, .transparent:
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

  // MARK: - Lifecycle

  open override func viewDidLoad() {
    super.viewDidLoad()

    self.setup()
    self.style()
    self.layout()
  }

  // MARK: - Setup

  /// Sets up the modal's subviews and gesture recognizers.
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

  /// Applies styling to the modal's components based on the model.
  open func style() {
    Self.Style.overlay(self.overlay, model: self.model)
    Self.Style.container(self.container, model: self.model)
    Self.Style.content(self.content, model: self.model)
    Self.Style.bodyWrapper(self.bodyWrapper)
  }

  // MARK: - Layout

  /// Configures the layout of the modal's components.
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
      footer.bottom(self.model.contentPaddings.bottom)
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
      constant: self.model.outerPaddings.top
    ).isActive = true
    self.container.leadingAnchor.constraint(
      greaterThanOrEqualTo: self.view.safeAreaLayoutGuide.leadingAnchor,
      constant: self.model.outerPaddings.leading
    ).isActive = true
    self.container.trailingAnchor.constraint(
      lessThanOrEqualTo: self.view.safeAreaLayoutGuide.trailingAnchor,
      constant: -self.model.outerPaddings.trailing
    ).isActive = true
    self.container.heightAnchor.constraint(
      greaterThanOrEqualToConstant: 80
    ).isActive = true

    let containerWidthConstraint = self.container.width(self.model.size.maxWidth).width
    containerWidthConstraint?.priority = .defaultHigh

    let bodyWrapperWidthConstraint = self.bodyWrapper.width(self.model.size.maxWidth).width
    bodyWrapperWidthConstraint?.priority = .defaultHigh

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
      case .transparent:
        view.backgroundColor = .clear
      case .blurred:
        (view as? UIVisualEffectView)?.effect = UIBlurEffect(style: .systemUltraThinMaterial)
      }
    }
    static func container(_ view: UIView, model: VM) {
      view.backgroundColor = UniversalColor.background.uiColor
      view.layer.cornerRadius = model.cornerRadius.value
    }
    static func content(_ view: UIView, model: VM) {
      view.backgroundColor = model.preferredBackgroundColor.uiColor
      view.layer.cornerRadius = model.cornerRadius.value
      view.clipsToBounds = true
    }
    static func bodyWrapper(_ scrollView: UIScrollView) {
      scrollView.delaysContentTouches = false
      scrollView.contentInsetAdjustmentBehavior = .never
      scrollView.automaticallyAdjustsScrollIndicatorInsets = false
    }
  }
}
