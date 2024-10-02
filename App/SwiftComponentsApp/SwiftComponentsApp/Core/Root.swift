import SwiftUI

@main
struct Root: SwiftUI.App {
  @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

  var body: some Scene {
    WindowGroup {
      App()
    }
  }
}
