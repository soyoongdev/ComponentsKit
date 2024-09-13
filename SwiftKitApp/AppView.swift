import SwiftUI

struct AppView: View {
  var body: some View {
    NavigationStack {
      List {
        Section("Components") {
          NavigationLink("Buttons") {
            ButtonsView()
          }
          NavigationLink("Loadings") {
            LoadingsView()
          }
          NavigationLink("Input Fields") {
            InputFieldsView()
          }
          NavigationLink("Checkboxes") {
            CheckboxesView()
          }
          NavigationLink("Segmented Controls") {
            SegmentedControlsView()
          }
        }

        Section("Demo") {
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
      .navigationTitle("SwiftKit")
      .navigationBarTitleDisplayMode(.inline)
    }
  }
}

#Preview {
  AppView()
}
