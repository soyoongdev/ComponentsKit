// Copyright © SwiftKit. All rights reserved.

import Foundation

public struct AppColors {
  /// The color for the main background of your interface.
  let background: Color
  /// The color for content layered on top of the main background.
  let secondaryBackground: Color
  /// The color for text labels that contain primary content.
  let label: Color
  /// The color for text labels that contain secondary content.
  let secondaryLabel: Color
  /// The color for thin borders or divider lines that allows some underlying content to be visible.
  let divider: Color
  let overlay: Color // used for modal, popover, etc.
  let primary: ComponentColor
  let secondary: ComponentColor
  let accent: ComponentColor
  let success: ComponentColor
  let warning: ComponentColor
  let danger: ComponentColor

  public init(
    background: Color,
    secondaryBackground: Color,
    label: Color,
    secondaryLabel: Color,
    divider: Color,
    overlay: Color,
    primary: ComponentColor,
    secondary: ComponentColor,
    accent: ComponentColor,
    success: ComponentColor,
    warning: ComponentColor,
    danger: ComponentColor
  ) {
    self.background = background
    self.secondaryBackground = secondaryBackground
    self.label = label
    self.secondaryLabel = secondaryLabel
    self.divider = divider
    self.overlay = overlay
    self.primary = primary
    self.secondary = secondary
    self.accent = accent
    self.success = success
    self.warning = warning
    self.danger = danger
  }
}

// MARK: - AppColors + Default

extension AppColors {
  static let `default`: Self = .init(
    background: .init(universal: .uiColor(.systemBackground)),
    secondaryBackground: .init(universal: .uiColor(.secondarySystemBackground)),
    label: .init(universal: .uiColor(.label)),
    secondaryLabel: .init(universal: .uiColor(.secondaryLabel)),
    divider: .init(universal: .uiColor(.separator)),
    overlay: .init(universal: .uiColor(.systemGroupedBackground)),
    primary: .init(
      main: .init(universal: .uiColor(.label)),
      contrast: .init(universal: .uiColor(.systemBackground))
    ),
    secondary: .init(
      main: .init(universal: .uiColor(.lightGray)),
      contrast: .init(universal: .uiColor(.black))
    ),
    accent: .init(
      main: .init(universal: .uiColor(.systemBlue)),
      contrast: .init(universal: .uiColor(.white))
    ),
    success: .init(
      main: .init(universal: .uiColor(.systemGreen)),
      contrast: .init(universal: .uiColor(.black))
    ),
    warning: .init(
      main: .init(universal: .uiColor(.systemOrange)),
      contrast: .init(universal: .uiColor(.black))
    ),
    danger: .init(
      main: .init(universal: .uiColor(.systemRed)),
      contrast: .init(universal: .uiColor(.white))
    )
  )
}

// MARK: - AppColors + Config

extension AppColors {
  public enum Base {
    public static var background: Color {
      return SwiftKitConfig.shared.colors.background
    }
    public static var secondaryBackground: Color {
      return SwiftKitConfig.shared.colors.background
    }
    public static var divider: Color {
      return SwiftKitConfig.shared.colors.divider
    }
    public static var overlay: Color {
      return SwiftKitConfig.shared.colors.overlay
    }
  }
  public struct Text {
    public static var primary: Color {
      return SwiftKitConfig.shared.colors.label
    }
    public static var secondary: Color {
      return SwiftKitConfig.shared.colors.secondaryLabel
    }
    public static var accent: Color {
      return SwiftKitConfig.shared.colors.accent.main
    }
  }
  public struct Components {
    public static var primary: ComponentColor {
      return .primary
    }
    public static var secondary: ComponentColor {
      return .primary
    }
    public static var accent: ComponentColor {
      return .primary
    }
    public static var success: ComponentColor {
      return .primary
    }
    public static var warning: ComponentColor {
      return .primary
    }
    public static var danger: ComponentColor {
      return .primary
    }
  }
}

extension ComponentColor {
  public static var primary: Self {
    return SwiftKitConfig.shared.colors.primary
  }
  public static var secondary: Self {
    return SwiftKitConfig.shared.colors.secondary
  }
  public static var accent: Self {
    return SwiftKitConfig.shared.colors.accent
  }
  public static var success: Self {
    return SwiftKitConfig.shared.colors.success
  }
  public static var warning: Self {
    return SwiftKitConfig.shared.colors.warning
  }
  public static var danger: Self {
    return SwiftKitConfig.shared.colors.danger
  }
}
