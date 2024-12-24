import Foundation

/// A model that defines the appearance properties for an alert.
public struct AlertVM: ComponentVM {
  public var title: String = ""

  public var message: String = ""

  public var primaryButton: AlertButtonVM?

  public var secondaryButton: AlertButtonVM?

  /// The background color of the modal.
  public var backgroundColor: UniversalColor?

  /// A Boolean value indicating whether the modal should close when tapping on the overlay.
  ///
  /// Defaults to `true`.
  public var closesOnOverlayTap: Bool = false

  /// The padding applied to the modal's content area.
  ///
  /// Defaults to a padding value of `16` for all sides.
  public var contentPaddings: Paddings = .init(padding: 16)

  /// The corner radius of the modal.
  ///
  /// Defaults to `.medium`.
  public var cornerRadius: ContainerRadius = .medium

  /// The style of the overlay displayed behind the modal.
  ///
  /// Defaults to `.dimmed`.
  public var overlayStyle: ModalOverlayStyle = .dimmed

  /// The transition duration of the modal's appearance and dismissal animations.
  ///
  /// Defaults to `.fast`.
  public var transition: ModalTransition = .fast

  /// Initializes a new instance of `AlertVM` with default values.
  public init() {}
}

// MARK: - Helpers

extension AlertVM {
  var modalVM: CenterModalVM {
    return CenterModalVM {
      $0.backgroundColor = self.backgroundColor
      $0.closesOnOverlayTap = self.closesOnOverlayTap
      $0.contentPaddings = self.contentPaddings
      $0.cornerRadius = self.cornerRadius
      $0.overlayStyle = self.overlayStyle
      $0.transition = self.transition
      $0.size = .small
    }
  }

  var primaryButtonVM: ButtonVM? {
    return self.primaryButton.map(self.mapAlertButtonVM)
  }

  var secondaryButtonVM: ButtonVM? {
    return self.secondaryButton.map(self.mapAlertButtonVM)
  }

  private func mapAlertButtonVM(_ model: AlertButtonVM) -> ButtonVM {
    return ButtonVM {
      $0.title = model.title
      $0.animationScale = model.animationScale
      $0.color = model.color
      $0.cornerRadius = model.cornerRadius
      $0.style = model.style
    }
  }
}

extension AlertVM {
  static let buttonsSpacing: CGFloat = 12
}
