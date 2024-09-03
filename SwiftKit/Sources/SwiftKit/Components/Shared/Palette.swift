import Foundation

public struct Palette: Updatable {
  /// TheThemeColor for the main background of your interface.
  public var background: ThemeColor = .init(
    universal: .uiColor(.systemBackground)
  )
  /// TheThemeColor for content layered on top of the main background.
  public var secondaryBackground: ThemeColor = .init(
    universal: .uiColor(.secondarySystemBackground)
  )
  /// TheThemeColor for text labels that contain primary content.
  public var label: ThemeColor = .init(
    universal: .uiColor(.label)
  )
  /// TheThemeColor for text labels that contain secondary content.
  public var secondaryLabel: ThemeColor = .init(
    universal: .uiColor(.secondaryLabel)
  )
  /// TheThemeColor for thin borders or divider lines that allows some underlying content to be visible.
  public var divider: ThemeColor = .init(
    universal: .uiColor(.separator)
  )
  // used for modal, popover, etc.
  public var overlay: ThemeColor = .init(
    universal: .uiColor(.systemGroupedBackground)
  )
  public var primary: ComponentColor = .init(
    main: .init(universal: .uiColor(.label)),
    contrast: .init(universal: .uiColor(.systemBackground))
  )
  public var secondary: ComponentColor = .init(
    main: .init(universal: .uiColor(.lightGray)),
    contrast: .init(universal: .uiColor(.black))
  )
  public var accent: ComponentColor = .init(
    main: .init(universal: .uiColor(.systemBlue)),
    contrast: .init(universal: .uiColor(.white))
  )
  public var success: ComponentColor = .init(
    main: .init(universal: .uiColor(.systemGreen)),
    contrast: .init(universal: .uiColor(.black))
  )
  public var warning: ComponentColor = .init(
    main: .init(universal: .uiColor(.systemOrange)),
    contrast: .init(universal: .uiColor(.black))
  )
  public var danger: ComponentColor = .init(
    main: .init(universal: .uiColor(.systemRed)),
    contrast: .init(universal: .uiColor(.white))
  )

  public init() {}
}

// MARK: - Palette + Config

extension Palette {
  public enum Base {
    public static var background: ThemeColor {
      return SwiftKitConfig.shared.colors.background
    }
    public static var secondaryBackground: ThemeColor {
      return SwiftKitConfig.shared.colors.background
    }
    public static var divider: ThemeColor {
      return SwiftKitConfig.shared.colors.divider
    }
    public static var overlay: ThemeColor {
      return SwiftKitConfig.shared.colors.overlay
    }
  }
  public struct Text {
    public static var primary: ThemeColor {
      return SwiftKitConfig.shared.colors.label
    }
    public static var secondary: ThemeColor {
      return SwiftKitConfig.shared.colors.secondaryLabel
    }
    public static var accent: ThemeColor {
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
