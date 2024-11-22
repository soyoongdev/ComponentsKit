import Foundation

public struct RadioGroupVM<ID: Hashable> {
  public var color: UniversalColor = .primary

  public var font: UniversalFont?

  public var isEnabled: Bool = true

  public var items: [RadioItemVM<ID>] = [] {
    didSet {
      guard self.items.isNotEmpty else {
        assertionFailure("Array of items must contain at least one item.")
        return
      }
      if let duplicatedId {
        assertionFailure("Items must have unique ids! Duplicated id: \(duplicatedId)")
      }
    }
  }

  public var size: ComponentSize = .medium

  public init() {}
}

extension RadioGroupVM {
  var circleSize: CGFloat {
    switch self.size {
    case .small:
      return 16
    case .medium:
      return 20
    case .large:
      return 24
    }
  }

  var innerCircleSize: CGFloat {
    switch self.size {
    case .small:
      return 10
    case .medium:
      return 12
    case .large:
      return 14
    }
  }

  var lineWidth: CGFloat {
    switch self.size {
    case .small:
      return 1
    case .medium:
      return 2
    case .large:
      return 2
    }
  }
}

extension RadioGroupVM {
  private var duplicatedId: ID? {
    var dict: [ID: Bool] = [:]
    for item in self.items {
      if dict[item.id].isNotNil {
        return item.id
      }
      dict[item.id] = true
    }
    return nil
  }
}
