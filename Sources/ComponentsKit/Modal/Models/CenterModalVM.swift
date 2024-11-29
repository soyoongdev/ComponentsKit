import Foundation

/// A model that defines the appearance properties for a center modal component.
public struct CenterModalVM: ModalVM {
  public var backgroundColor: UniversalColor = Palette.Base.secondaryBackground

  public var closesOnOverlayTap: Bool = true

  public var contentPaddings: Paddings = .init(padding: 16)

  public var contentSpacing: CGFloat = 16

  public var cornerRadius: ModalRadius = .medium

  public var overlayStyle: ModalOverlayStyle = .dimmed

  public var outerPaddings: Paddings = .init(padding: 20)

  public var size: ModalSize = .medium

  public var transition: ModalTransition = .fast

  /// Initializes a new instance of `ModalVM` with default values.
  public init() {}
}
