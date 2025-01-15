import Foundation

extension AvatarVM {
  public enum ImageSource: Hashable {
    case remote(_ url: URL)
    case local(_ name: String, _ bundle: Bundle? = nil)
  }
}
