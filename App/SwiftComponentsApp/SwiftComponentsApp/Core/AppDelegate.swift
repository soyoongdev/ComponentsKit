import SwiftComponents
import UIKit

final class AppDelegate: NSObject, UIApplicationDelegate {
  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
  ) -> Bool {
    setupSwiftComponents()

    return true
  }
}

// MARK: - SwiftComponents Configuration

private func setupSwiftComponents() {
  // Configure colors or layout
//  SwiftComponentsConfig.shared.update {
//    $0.colors.primary = ...
//    $0.layout.componentFont.medium = ...
//  }
}

// Add more colors

extension Palette {
  enum Brand {
    static let blue: UniversalColor = .themed(
      light: .hex("#3684F8"),
      dark: .hex("#0058DB")
    )
    static let purple: UniversalColor = .themed(
      light: .hex("#A920FD"),
      dark: .hex("#7800C1")
    )
  }
}
