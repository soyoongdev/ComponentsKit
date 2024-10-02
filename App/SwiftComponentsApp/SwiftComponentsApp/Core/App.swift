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
        }

        Section("Demos") {
          NavigationLink("SwiftUI Login") {
            SwiftUILogin()
          }
          NavigationLink("UIKit Login") {
            UIViewControllerRepresenting {
              UIKitLogin()
            }
          }
        }
      }
      .navigationTitle("SwiftComponents")
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
