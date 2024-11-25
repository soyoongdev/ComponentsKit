import Foundation
import SwiftUICore

/// A model that defines the appearance properties for a bottom modal component.
public struct BottomModalVM: ModalVM {
  public var backgroundColor: UniversalColor = Palette.Base.secondaryBackground

  public var closesOnOverlayTap: Bool = true

  public var contentPaddings: EdgeInsets = .init(top: 16, leading: 16, bottom: 16, trailing: 16)

  public var contentSpacing: CGFloat = 16

  public var cornerRadius: ModalRadius = .medium

  public var overlayStyle: ModalOverlayStyle = .dimmed

  public var modalPaddings: EdgeInsets = .init(top: 20, leading: 20, bottom: 20, trailing: 20)

  public var size: ModalSize = .medium

  public var isDraggable: Bool = true
  public var hidesOnSwap: Bool = true

  /// Initializes a new instance of `ModalVM` with default values.
  public init() {}
}
