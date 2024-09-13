import UIKit
import SwiftUI
import SwiftKit

struct UKComponentPreview<View, Model>: UIViewRepresentable where View: UKComponent, Model == View.Model {
  class Container: UIView {
    let component: View

    init(component: View) {
      self.component = component

      super.init(frame: .zero)

      self.addSubview(self.component)

      self.component.centerVertically()
      self.component.centerHorizontally()
    }

    required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }
  }

  let model: Model
  let view: View

  init(model: Model, view: () -> View) {
    self.view = view()
    self.model = model
  }

  func makeUIView(context: Context) -> Container {
    return Container(component: self.view)
  }

  func updateUIView(_ container: Container, context: Context) {
    container.component.model = self.model
  }
}
