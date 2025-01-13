import Foundation

/// A model that defines the appearance properties for an avatar component.
public struct AvatarVM: ComponentVM {
  /// The corner radius of the button.
  ///
  /// Defaults to `.medium`.
  public var cornerRadius: ComponentRadius = .medium

  /// The image that should be displayed.
  public var image: ImageRepresentable?

  /// The placeholder that is displayed if the image is not provided or fails to load.
  public var placeholder: Placeholder = .icon(.system("person.circle"))

  /// The predefined size of the button.
  ///
  /// Defaults to `.medium`.
  public var size: ComponentSize = .medium

  /// Initializes a new instance of `AvatarVM` with default values.
  public init() {}
}
