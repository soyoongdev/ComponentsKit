// Copyright © SwiftKit. All rights reserved.

import SwiftUI

struct AppView: View {
  var body: some View {
    NavigationStack {
      List {
        NavigationLink("Actions") {
          ButtonsView()
        }
      }
    }
  }
}

#Preview {
  AppView()
}
