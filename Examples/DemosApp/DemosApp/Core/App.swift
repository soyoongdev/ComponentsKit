import ComponentsKit
import SwiftUI

struct App: View {
  var body: some View {
    NavigationStack {
      List {
        Section("Components") {
          NavigationLinkWithTitle("Button") {
            ButtonPreview()
          }
          NavigationLinkWithTitle("Checkbox") {
            CheckboxPreview()
          }
          NavigationLinkWithTitle("Input Field") {
            InputFieldPreview()
          }
          NavigationLinkWithTitle("Loading") {
            LoadingPreview()
          }
          NavigationLinkWithTitle("Segmented Control") {
            SegmentedControlPreview()
          }
          NavigationLinkWithTitle("Text Field") {
            TextInputPreviewPreview()
          }
        }

        Section("Login Demo") {
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

// MARK: - Helper

private struct NavigationLinkWithTitle<Destination: View>: View {
  let title: String
  @ViewBuilder let destination: () -> Destination

  init(_ title: String, destination: @escaping () -> Destination) {
    self.title = title
    self.destination = destination
  }

  var body: some View {
    NavigationLink(self.title) {
      self.destination()
        .navigationTitle(self.title)
    }
  }
}

// MARK: - Preview

#Preview {
  App()
}
