import Foundation

public struct Palette: Initializable, Updatable {
  /// The UniversalColor for the main background of your interface.
  public var background: UniversalColor = .universal(.uiColor(.systemBackground))
  /// The UniversalColor for content layered on top of the main background.
  public var secondaryBackground: UniversalColor = .universal(.uiColor(.secondarySystemBackground))
  /// The UniversalColor for text labels that contain primary content.
  public var label: UniversalColor = .universal(.uiColor(.label))
  /// The UniversalColor for text labels that contain secondary content.
  public var secondaryLabel: UniversalColor = .universal(.uiColor(.secondaryLabel))
  /// The UniversalColor for thin borders or divider lines that allows some underlying content to be visible.
  public var divider: UniversalColor = .universal(.uiColor(.separator))
  public var primary: ComponentColor = .init(
    main: .universal(.uiColor(.label)),
    contrast: .universal(.uiColor(.systemBackground))
  )
  public var secondary: ComponentColor = .init(
    main: .universal(.uiColor(.lightGray)),
    contrast: .universal(.uiColor(.black))
  )
  public var accent: ComponentColor = .init(
    main: .universal(.uiColor(.systemBlue)),
    contrast: .universal(.uiColor(.white))
  )
  public var success: ComponentColor = .init(
    main: .universal(.uiColor(.systemGreen)),
    contrast: .universal(.uiColor(.black))
  )
  public var warning: ComponentColor = .init(
    main: .universal(.uiColor(.systemOrange)),
    contrast: .universal(.uiColor(.black))
  )
  public var danger: ComponentColor = .init(
    main: .universal(.uiColor(.systemRed)),
    contrast: .universal(.uiColor(.white))
  )

  public init() {}
}

// MARK: - Palette + Config

extension Palette {
  public enum Base {
    public static var background: UniversalColor {
      return SwiftComponentsConfig.shared.colors.background
    }
    public static var secondaryBackground: UniversalColor {
      return SwiftComponentsConfig.shared.colors.background
    }
    public static var divider: UniversalColor {
      return SwiftComponentsConfig.shared.colors.divider
    }
  }
  public enum Text {
    public static var primary: UniversalColor {
      return SwiftComponentsConfig.shared.colors.label
    }
    public static var secondary: UniversalColor {
      return SwiftComponentsConfig.shared.colors.secondaryLabel
    }
    public static var accent: UniversalColor {
      return SwiftComponentsConfig.shared.colors.accent.main
    }
  }
  public enum Components {
    public static var primary: ComponentColor {
      return .primary
    }
    public static var secondary: ComponentColor {
      return .secondary
    }
    public static var accent: ComponentColor {
      return .accent
    }
    public static var success: ComponentColor {
      return .success
    }
    public static var warning: ComponentColor {
      return .warning
    }
    public static var danger: ComponentColor {
      return .danger
    }
  }
}

extension ComponentColor {
  public static var primary: Self {
    return SwiftComponentsConfig.shared.colors.primary
  }
  public static var secondary: Self {
    return SwiftComponentsConfig.shared.colors.secondary
  }
  public static var accent: Self {
    return SwiftComponentsConfig.shared.colors.accent
  }
  public static var success: Self {
    return SwiftComponentsConfig.shared.colors.success
  }
  public static var warning: Self {
    return SwiftComponentsConfig.shared.colors.warning
  }
  public static var danger: Self {
    return SwiftComponentsConfig.shared.colors.danger
  }
}

extension UniversalColor {
  public static var primary: Self {
    return SwiftComponentsConfig.shared.colors.primary.main
  }
  public static var secondary: Self {
    return SwiftComponentsConfig.shared.colors.secondary.main
  }
  public static var accent: Self {
    return SwiftComponentsConfig.shared.colors.accent.main
  }
  public static var success: Self {
    return SwiftComponentsConfig.shared.colors.success.main
  }
  public static var warning: Self {
    return SwiftComponentsConfig.shared.colors.warning.main
  }
  public static var danger: Self {
    return SwiftComponentsConfig.shared.colors.danger.main
  }
}
