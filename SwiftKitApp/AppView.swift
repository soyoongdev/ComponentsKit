//
//  AppView.swift
//  SwiftKitApp
//
//  Created by Mikhail on 19.08.2024.
//

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
