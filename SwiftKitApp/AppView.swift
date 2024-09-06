import SwiftUI

struct AppView: View {
  var body: some View {
    NavigationStack {
      List {
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
      }
      .navigationTitle("SwiftKit")
    }
  }
}

#Preview {
  AppView()
}
