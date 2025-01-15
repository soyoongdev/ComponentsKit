import SwiftUI

/// A SwiftUI component that displays a profile picture, initials or fallback icon for a user.
public struct SUAvatar: View {
  // MARK: - Properties

  /// A model that defines the appearance properties.
  public var model: AvatarVM

  @State private var loadedImage: UIImage?

  // MARK: - Initialization

  /// Initializer.
  /// - Parameters:
  ///   - model: A model that defines the appearance properties.
  public init(model: AvatarVM) {
    self.model = model
  }

  // MARK: - Body

  public var body: some View {
    Group {
      if let source = self.model.imageSrc {
        switch source {
        case .remote:
          if let loadedImage {
            Image(uiImage: loadedImage)
              .resizable()
              .transition(.opacity)
          } else {
            self.placeholder
          }
        case let .local(name, bundle):
          Image(name, bundle: bundle)
            .resizable()
        }
      } else {
        self.placeholder
      }
    }
    .aspectRatio(contentMode: .fill)
    .frame(
      width: self.model.preferredSize.width,
      height: self.model.preferredSize.height
    )
    .clipShape(
      RoundedRectangle(cornerRadius: self.model.cornerRadius.value())
    )
    .onAppear {
      if let imageURL = self.model.imageURL {
        self.downloadImage(url: imageURL)
      }
    }
    .onChange(of: self.model.imageSrc) { newValue in
      switch newValue {
      case .remote(let url):
        self.downloadImage(url: url)
      case .local, .none:
        break
      }
    }
  }

  // MARK: - Subviews

  private var placeholder: some View {
    Image(uiImage: self.model.placeholderImage(
      for: self.model.preferredSize
    ))
      .resizable()
  }

  // MARK: - Helpers

  private func downloadImage(url: URL) {
    Task { @MainActor in
      let image = await ImageLoader.download(url: url)
      withAnimation {
        self.loadedImage = image
      }
    }
  }
}
