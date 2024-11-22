import UIKit

public class UKBottomModalController: UKModalController<BottomModalVM> {
  public override init(
    model: BottomModalVM = .init(),
    content: (_ dismiss: @escaping (_ animated: Bool) -> Void) -> UIView
  ) {
    super.init(model: model, content: content)
  }

  required public init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  public override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)

    UIView.animate(withDuration: 0.3) {
      self.containerWrapper.transform = .identity
      self.overlay.alpha = 1
    }
  }

  public override func setup() {
    super.setup()

    self.containerWrapper.addGestureRecognizer(UIPanGestureRecognizer(
      target: self,
      action: #selector(self.handleDragGesture)
    ))
  }

  public override func layout() {
    super.layout()

    self.containerWrapper.bottom(20, safeArea: true)
  }

  public override func dismiss(
    animated flag: Bool,
    completion: (() -> Void)? = nil
  ) {
    if flag {
      UIView.animate(withDuration: 0.3) {
        self.containerWrapper.transform = .init(translationX: 0, y: self.view.screenBounds.height)
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
    let offset = self.calculateOffset(translation)

    switch gesture.state {
    case .changed:
      self.containerWrapper.transform = .init(translationX: 0, y: offset)
    case .ended:
      let viewHeight = self.containerWrapper.frame.height
      if abs(offset) > viewHeight / 2 || velocity > 250,
         self.model.hidesOnSwap {
        self.dismiss(animated: true)
      } else {
        UIView.animate(withDuration: 0.3) {
          self.containerWrapper.transform = .identity
        }
      }
    case .failed, .cancelled:
      UIView.animate(withDuration: 0.3) {
        self.containerWrapper.transform = .identity
      }
    default:
      break
    }
  }

  private func calculateOffset(_ translation: CGFloat) -> CGFloat {
    if translation > 0 {
      return self.model.hidesOnSwap
      ? translation
      : (self.model.isDraggable ? self.rubberBandClamp(translation) : 0)
    } else {
      return self.model.isDraggable
      ? -self.rubberBandClamp(abs(translation))
      : 0
    }
  }

  /// Calculates an offset with rubber band effect.
  private func rubberBandClamp(_ translation: CGFloat) -> CGFloat {
    let dim: CGFloat = 20
    let coef: CGFloat = 0.2
    return (1.0 - (1.0 / ((translation * coef / dim) + 1.0))) * dim
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
      vc.containerWrapper.transform = .init(translationX: 0, y: self.view.screenBounds.height)
      vc.overlay.alpha = 0
    }
    self.present(vc as UIViewController, animated: false)
  }
}
