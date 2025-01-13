import Foundation

extension AvatarVM {
  public enum ImageRepresentable: Equatable {
    case url(_ url: URL)
    case system(_ name: String)
    case image(_ name: String, _ bundle: Bundle)
  }
}
