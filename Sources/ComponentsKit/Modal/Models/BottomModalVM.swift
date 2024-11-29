import Foundation

/// A model that defines the appearance properties for a bottom modal component.
public struct BottomModalVM: ModalVM {
  public var backgroundColor: UniversalColor = Palette.Base.secondaryBackground

  public var closesOnOverlayTap: Bool = true

  public var contentPaddings: Paddings = .init(padding: 16)

  public var contentSpacing: CGFloat = 16

  public var cornerRadius: ModalRadius = .medium

  public var overlayStyle: ModalOverlayStyle = .dimmed

  public var outerPaddings: Paddings = .init(padding: 20)

  public var size: ModalSize = .medium

  public var transitionDuration: TimeInterval = 0.2

  public var isDraggable: Bool = true
  public var hidesOnSwap: Bool = true

  /// Initializes a new instance of `ModalVM` with default values.
  public init() {}
}
