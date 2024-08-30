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
      }
      .navigationTitle("SwiftKit")
    }
  }
}

#Preview {
  AppView()
}
