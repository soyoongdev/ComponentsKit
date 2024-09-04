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
      }
      .navigationTitle("SwiftKit")
    }
  }
}

#Preview {
  AppView()
}
