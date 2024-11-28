import Foundation

enum ModalAnimation {
  static let duration: TimeInterval = 0.2

  /// Calculates an offset with rubber band effect.
  static func rubberBandClamp(_ translation: CGFloat) -> CGFloat {
    let dim: CGFloat = 20
    let coef: CGFloat = 0.2
    return (1.0 - (1.0 / ((translation * coef / dim) + 1.0))) * dim
  }

  static func bottomModalOffset(_ translation: CGFloat, model: BottomModalVM) -> CGFloat {
    if translation > 0 {
      return model.hidesOnSwap
      ? translation
      : (model.isDraggable ? Self.rubberBandClamp(translation) : 0)
    } else {
      return model.isDraggable
      ? -Self.rubberBandClamp(abs(translation))
      : 0
    }
  }

  static func shouldHideBottomModal(
    offset: CGFloat,
    height: CGFloat,
    velocity: CGFloat,
    model: BottomModalVM
  ) -> Bool {
    guard model.hidesOnSwap else {
      return false
    }

    return abs(offset) > height / 2 || velocity > 250
  }
}
