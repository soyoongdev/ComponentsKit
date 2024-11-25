import Foundation
import SwiftUICore

/// A model that defines the appearance properties for a center modal component.
public struct CenterModalVM: ModalVM {
  public var backgroundColor: UniversalColor = Palette.Base.background

  public var closesOnOverlayTap: Bool = true

  public var contentPaddings: EdgeInsets = .init(top: 16, leading: 16, bottom: 16, trailing: 16)

  public var contentSpacing: CGFloat = 16

  public var hasCloseButton: Bool = false

  public var overlayStyle: ModalOverlayStyle = .dimmed

  /// Initializes a new instance of `ModalVM` with default values.
  public init() {}
}
