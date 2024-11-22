import Foundation

/// A model that defines the appearance and behavior of a radio group component.
public struct RadioGroupVM<ID: Hashable> {
  /// The color of the selected radio button.
  public var color: UniversalColor = .primary

  /// The font used for the radio items' titles.
  public var font: UniversalFont?

  /// A Boolean value indicating whether the radio group is enabled or disabled.
  ///
  /// Defaults to `true`.
  public var isEnabled: Bool = true

  /// An array of items representing the options in the radio group.
  ///
  /// Must contain at least one item, and all items must have unique identifiers.
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

  /// The predefined size of the radio buttons.
  ///
  /// Defaults to `.medium`.
  public var size: ComponentSize = .medium

  /// Initializes a new instance of `RadioGroupVM` with default values.
  public init() {}
}

// MARK: - Shared Helpers

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
      return 1.5
    case .medium:
      return 2.0
    case .large:
      return 2.0
    }
  }
}

// MARK: - Validation

extension RadioGroupVM {
  /// Checks for duplicated item identifiers in the radio group.
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
