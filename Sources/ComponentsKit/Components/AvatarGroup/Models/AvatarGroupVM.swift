import UIKit

/// A model that defines the appearance properties for an avatar group component.
public struct AvatarGroupVM: ComponentVM {
  /// The color of the placeholder.
  public var color: ComponentColor?

  /// The corner radius of the avatar.
  ///
  /// Defaults to `.full`.
  public var cornerRadius: ComponentRadius = .full

  /// The array of avatars in the group.
  public var items: [AvatarItemVM] = []

  /// The maximum number of visible avatars
  ///
  /// Defaults to `5`.
  public var maxVisibleAvatars: Int = 5

  /// The predefined size of the avatar.
  ///
  /// Defaults to `.medium`.
  public var size: ComponentSize = .medium

  /// Initializes a new instance of `AvatarVM` with default values.
  public init() {}
}
