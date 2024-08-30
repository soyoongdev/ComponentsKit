import Foundation

public enum AlertButtonsLayout {
  public enum Distribution {
    case fillEqually
    case fillProportionally
  }

  case vertical
  case horizontal(Distribution = .fillEqually)
}
