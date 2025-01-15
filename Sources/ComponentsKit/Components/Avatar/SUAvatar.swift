import SwiftUI

/// A SwiftUI component that displays a profile picture, initials or fallback icon for a user.
public struct SUAvatar: View {
  // MARK: - Properties

  /// A model that defines the appearance properties.
  public var model: AvatarVM

  @StateObject private var imageManager: AvatarImageManager

  // MARK: - Initialization

  /// Initializer.
  /// - Parameters:
  ///   - model: A model that defines the appearance properties.
  public init(model: AvatarVM) {
    self.model = model
    self._imageManager = StateObject(
      wrappedValue: AvatarImageManager(model: model)
    )
  }

  // MARK: - Body

  public var body: some View {
    Image(uiImage: self.imageManager.avatarImage)
      .resizable()
      .aspectRatio(contentMode: .fill)
      .frame(
        width: self.model.preferredSize.width,
        height: self.model.preferredSize.height
      )
      .clipShape(
        RoundedRectangle(cornerRadius: self.model.cornerRadius.value())
      )
      .onChange(of: self.model) { newValue in
        self.imageManager.update(model: newValue, size: newValue.preferredSize)
      }
  }
}
