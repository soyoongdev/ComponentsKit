import UIKit

public class UKBottomModalController: UKModalController<BottomModalVM> {
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

  public override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)

    UIView.animate(withDuration: ModalAnimation.duration) {
      self.container.transform = .identity
      self.overlay.alpha = 1
    }
  }

  public override func setup() {
    super.setup()

    self.container.addGestureRecognizer(UIPanGestureRecognizer(
      target: self,
      action: #selector(self.handleDragGesture)
    ))
  }

  public override func layout() {
    super.layout()

    self.container.bottom(self.model.outerPaddings.bottom, safeArea: true)
  }

  public override func dismiss(
    animated flag: Bool,
    completion: (() -> Void)? = nil
  ) {
    if flag {
      UIView.animate(withDuration: ModalAnimation.duration) {
        self.container.transform = .init(translationX: 0, y: self.view.screenBounds.height)
        self.overlay.alpha = 0
      } completion: { _ in
        super.dismiss(animated: false)
      }
    } else {
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
        UIView.animate(withDuration: ModalAnimation.duration) {
          self.container.transform = .identity
        }
      }
    case .failed, .cancelled:
      UIView.animate(withDuration: ModalAnimation.duration) {
        self.container.transform = .identity
      }
    default:
      break
    }
  }
}

// MARK: - UIViewController + Present Modal

extension UIViewController {
  public func present(
    _ vc: UKBottomModalController,
    animated: Bool,
    completion: (() -> Void)? = nil
  ) {
    if animated {
      vc.container.transform = .init(translationX: 0, y: self.view.screenBounds.height)
      vc.overlay.alpha = 0
    }
    self.present(vc as UIViewController, animated: false)
  }
}
