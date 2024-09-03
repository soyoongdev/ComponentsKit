import UIKit
import SwiftUI

struct UIViewRepresenting<View>: UIViewRepresentable where View: UIView {
  private let view: View

  init(_ view: () -> View) {
    self.view = view()
  }

  func makeUIView(context: Context) -> View {
    return self.view
  }

  func updateUIView(_ view: View, context: Context) {}
}
