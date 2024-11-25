import Foundation
import SwiftUICore

public enum ModalOverlayStyle {
  case dimmed
  case blurred
  case opaque
}

/// A model that defines generic appearance properties that can be in any modal component.
public protocol ModalVM: ComponentVM {
  var backgroundColor: UniversalColor { get set }
  var closesOnOverlayTap: Bool { get set }
  var contentPaddings: EdgeInsets { get set }
  var contentSpacing: CGFloat { get set }
  var cornerRadius: ModalRadius { get set }
  // TODO: [1] Implement close button
  var hasCloseButton: Bool { get set }
  var modalPaddings: EdgeInsets { get set }
  var overlayStyle: ModalOverlayStyle { get set }
  var size: ModalSize { get set }
}
