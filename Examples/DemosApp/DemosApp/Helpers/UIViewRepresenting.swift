import SwiftUI
import UIKit

struct UIViewRepresenting<View: UIView>: UIViewRepresentable {
  private let view: View

  init(_ view: () -> View) {
    self.view = view()
  }

  func makeUIView(context: Context) -> View {
    return self.view
  }

  func updateUIView(_ view: View, context: Context) {}
}
