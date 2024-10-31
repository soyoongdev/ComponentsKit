import ComponentsKit
import SwiftUI

struct App: View {
  var body: some View {
    NavigationStack {
      List {
        Section("Login") {
          NavigationLink("SwiftUI") {
            SwiftUILogin()
          }
          NavigationLink("UIKit") {
            UIViewControllerRepresenting {
              UIKitLogin()
            }
          }
        }
      }
      .navigationTitle("Examples")
      .navigationBarTitleDisplayMode(.inline)
    }
  }
}

// MARK: - Preview

#Preview {
  App()
}
