import Foundation

/// Defines the visual styles for the countdown component.
public enum CountdownStyle: Equatable {
  public enum UnitsPosition: Equatable {
    case none
    case bottom
    case trailing
  }

  case plain(UnitsPosition)
  case light(UnitsPosition)

  public var unitsPosition: UnitsPosition {
    switch self {
    case .plain(let position), .light(let position):
      return position
    }
  }
}
