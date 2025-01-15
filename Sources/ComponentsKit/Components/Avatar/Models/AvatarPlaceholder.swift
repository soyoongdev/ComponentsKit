import Foundation

extension AvatarVM {
  public enum Placeholder: Hashable {
    case text(String)
    case sfSymbol(_ name: String)
    case icon(_ name: String, _ bundle: Bundle? = nil)
  }
}
