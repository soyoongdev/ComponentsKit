import SwiftUI

struct AppView: View {
  var body: some View {
    NavigationStack {
      List {
        Section("Components") {
          NavigationLink("Buttons") {
            ButtonsView()
          }
          NavigationLink("Alerts") {
            AlertsView()
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
