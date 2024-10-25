import SwiftUI
import UIKit

/// A model that defines the appearance properties for a segmented control component.
public struct SegmentedControlVM<ID: Hashable>: ComponentVM {
  /// The color of the segmented control.
  public var color: ComponentColor?

  /// The corner radius of the segmented control.
  ///
  /// Defaults to `.medium`.
  public var cornerRadius: ComponentRadius = .medium

  /// The font used for the segmented control items' titles.
  public var font: UniversalFont?

  /// A Boolean value indicating whether the segmented control is enabled or disabled.
  ///
  /// Defaults to `true`.
  public var isEnabled: Bool = true

  /// A Boolean value indicating whether the segmented control should take the full width of its superview.
  ///
  /// Defaults to `false`.
  public var isFullWidth: Bool = false

  /// The array of items in the segmented control.
  ///
  /// It must contain at least one item and all items must have unique identifiers.
  public var items: [SegmentedControlItemVM<ID>] = [] {
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

  /// The predefined size of the segmented control.
  ///
  /// Defaults to `.medium`.
  public var size: ComponentSize = .medium

  /// Initializes a new instance of `SegmentedControlVM` with default values.
  public init() {}
}

// MARK: - Shared Helpers

extension SegmentedControlVM {
  var backgroundColor: UniversalColor {
    return .init(
      light: .rgba(r: 244, g: 244, b: 245, a: 1.0),
      dark: .rgba(r: 39, g: 39, b: 42, a: 1.0)
    ).withOpacity(
      self.isEnabled
      ? 1.0
      : ComponentsKitConfig.shared.layout.disabledOpacity
    )
  }
  var selectedSegmentColor: UniversalColor {
    let selectedSegmentColor = self.color?.main ?? .init(
      light: .rgba(r: 255, g: 255, b: 255, a: 1.0),
      dark: .rgba(r: 62, g: 62, b: 69, a: 1.0)
    )
    return selectedSegmentColor.withOpacity(
      self.isEnabled
      ? 1.0
      : ComponentsKitConfig.shared.layout.disabledOpacity
    )
  }
  func item(for id: ID) -> SegmentedControlItemVM<ID>? {
    return self.items.first(where: { $0.id == id })
  }
  func foregroundColor(id: ID, selectedId: ID) -> UniversalColor {
    let isItemEnabled = self.item(for: id)?.isEnabled == true
    let isSelected = id == selectedId && isItemEnabled
    let defaultColor = UniversalColor(
      light: .rgba(r: 0, g: 0, b: 0, a: 1.0),
      dark: .rgba(r: 255, g: 255, b: 255, a: 1.0)
    )

    guard isSelected else {
      return defaultColor.withOpacity(
        self.isEnabled && isItemEnabled
        ? 0.7
        : 0.7 * ComponentsKitConfig.shared.layout.disabledOpacity
      )
    }

    let foregroundColor = self.color?.contrast ?? defaultColor
    return foregroundColor.withOpacity(
      self.isEnabled
      ? 1.0
      : ComponentsKitConfig.shared.layout.disabledOpacity
    )
  }
  var horizontalInnerPaddings: CGFloat? {
    guard !self.isFullWidth else {
      return 0
    }
    return switch self.size {
    case .small: 8
    case .medium: 12
    case .large: 16
    }
  }
  var outerPaddings: CGFloat {
    return 4
  }
  var width: CGFloat? {
    return self.isFullWidth ? 10_000 : nil
  }
  var height: CGFloat {
    return switch self.size {
    case .small: 36
    case .medium: 50
    case .large: 70
    }
  }
  func preferredFont(for id: ID) -> UniversalFont {
    if let itemFont = self.item(for: id)?.font {
      return itemFont
    } else if let font {
      return font
    }

    switch self.size {
    case .small:
      return UniversalFont.Component.small
    case .medium:
      return UniversalFont.Component.medium
    case .large:
      return UniversalFont.Component.large
    }
  }
}

// MARK: - UIKit Helpers

extension SegmentedControlVM {
  func shouldUpdateLayout(_ oldModel: Self) -> Bool {
    return self.items != oldModel.items
    || self.size != oldModel.size
    || self.isFullWidth != oldModel.isFullWidth
    || self.font != oldModel.font
  }
}

// MARK: - Validation

extension SegmentedControlVM {
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
