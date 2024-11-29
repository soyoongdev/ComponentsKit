import UIKit

/// A bottom-aligned modal controller.
public class UKBottomModalController: UKModalController<BottomModalVM> {
  // MARK: - Initialization

  /// Initializer.
  ///
  /// - Parameters:
  ///   - model: A model that defines the appearance properties.
  ///   - header: An optional content block for the modal's header.
  ///   - body: The main content block for the modal.
  ///   - footer: An optional content block for the modal's footer.
  public override init(
    model: BottomModalVM = .init(),
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

    self.container.transform = .init(translationX: 0, y: self.view.screenBounds.height)
    self.overlay.alpha = 0
  }

  public override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)

    UIView.animate(withDuration: self.model.transition.value) {
      self.container.transform = .identity
      self.overlay.alpha = 1
    }
  }

  // MARK: - Setup

  public override func setup() {
    super.setup()

    self.container.addGestureRecognizer(UIPanGestureRecognizer(
      target: self,
      action: #selector(self.handleDragGesture)
    ))
  }

  // MARK: - Layout

  public override func layout() {
    super.layout()

    self.container.bottom(self.model.outerPaddings.bottom, safeArea: true)
  }

  // MARK: - UIViewController Methods

  public override func dismiss(
    animated flag: Bool,
    completion: (() -> Void)? = nil
  ) {
    UIView.animate(withDuration: self.model.transition.value) {
      self.container.transform = .init(translationX: 0, y: self.view.screenBounds.height)
      self.overlay.alpha = 0
    } completion: { _ in
      super.dismiss(animated: false)
    }
  }
}

// MARK: - Interactions

extension UKBottomModalController {
  @objc private func handleDragGesture(_ gesture: UIPanGestureRecognizer) {
    let translation = gesture.translation(in: self.container).y
    let velocity = gesture.velocity(in: self.container).y
    let offset = ModalAnimation.bottomModalOffset(translation, model: self.model)

    switch gesture.state {
    case .changed:
      self.container.transform = .init(translationX: 0, y: offset)
    case .ended:
      let viewHeight = self.container.frame.height
      if ModalAnimation.shouldHideBottomModal(offset: offset, height: viewHeight, velocity: velocity, model: self.model) {
        self.dismiss(animated: true)
      } else {
        UIView.animate(withDuration: 0.2) {
          self.container.transform = .identity
        }
      }
    case .failed, .cancelled:
      UIView.animate(withDuration: 0.2) {
        self.container.transform = .identity
      }
    default:
      break
    }
  }
}

// MARK: - UIViewController + Present Bottom Modal

extension UIViewController {
  public func present(
    _ vc: UKBottomModalController,
    animated: Bool,
    completion: (() -> Void)? = nil
  ) {
    self.present(vc as UIViewController, animated: false)
  }
}
