import Foundation

/// A model that defines generic appearance properties that can be in any modal component.
public protocol ModalVM: ComponentVM {
  var backgroundColor: UniversalColor { get set }
  var closesOnOverlayTap: Bool { get set }
  var contentPaddings: Paddings { get set }
  var contentSpacing: CGFloat { get set }
  var cornerRadius: ModalRadius { get set }
  var overlayStyle: ModalOverlayStyle { get set }
  var outerPaddings: Paddings { get set }
  var size: ModalSize { get set }
  var transitionDuration: TimeInterval { get set }
}
