import SwiftUI
import UIKit

public struct SegmentedControlVM<ID: Hashable>: ComponentVM {
  public var color: ComponentColor?
  public var cornerRadius: ComponentRadius?
  public var font: Typography?
  public var isEnabled: Bool = true
  public var isFullWidth: Bool = false
  public var items: [SegmentedControlItemVM<ID>] = []
  public var size: ComponentSize = .medium

  public init() {}
}

// MARK: - Shared Helpers

extension SegmentedControlVM {
  var backgroundColor: ThemeColor {
    return .init(
      light: .rgba(r: 244, g: 244, b: 245, a: 1.0),
      dark: .rgba(r: 39, g: 39, b: 42, a: 1.0)
    ).withOpacity(
      self.isEnabled
      ? 1.0
      : SwiftKitConfig.shared.layout.disabledOpacity
    )
  }
  var selectedSegmentColor: ThemeColor {
    let selectedSegmentColor = self.color?.main ?? .init(
      light: .rgba(r: 255, g: 255, b: 255, a: 1.0),
      dark: .rgba(r: 62, g: 62, b: 69, a: 1.0)
    )
    return selectedSegmentColor.withOpacity(
      self.isEnabled
      ? 1.0
      : SwiftKitConfig.shared.layout.disabledOpacity
    )
  }
  func item(for id: ID) -> SegmentedControlItemVM<ID>? {
    return self.items.first(where: { $0.id == id })
  }
  func foregroundColor(id: ID, selectedId: ID) -> ThemeColor {
    let isItemEnabled = self.item(for: id)?.isEnabled == true
    let isSelected = id == selectedId && isItemEnabled
    let defaultColor = ThemeColor(
      light: .rgba(r: 0, g: 0, b: 0, a: 1.0),
      dark: .rgba(r: 255, g: 255, b: 255, a: 1.0)
    )

    guard isSelected else {
      return defaultColor.withOpacity(
        self.isEnabled && isItemEnabled
        ? 0.7
        : 0.7 * SwiftKitConfig.shared.layout.disabledOpacity
      )
    }

    let foregroundColor = self.color?.contrast ?? defaultColor
    return foregroundColor.withOpacity(
      self.isEnabled
      ? 1.0
      : SwiftKitConfig.shared.layout.disabledOpacity
    )
  }
  var preferredCornerRadius: ComponentRadius {
    if let cornerRadius {
      return cornerRadius
    }

    return switch self.size {
    case .small: .small
    case .medium: .medium
    case .large: .large
    }
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
  func preferredFont(for id: ID) -> Typography {
    if let itemFont = self.item(for: id)?.font {
      return itemFont
    } else if let font {
      return font
    }

    switch self.size {
    case .small:
      return Typography.Component.small
    case .medium:
      return Typography.Component.medium
    case .large:
      return Typography.Component.large
    }
  }
}
