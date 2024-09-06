import SwiftKit
import SwiftUI
import UIKit

private class Container: UIView {
  let checkbox = UKCheckbox(
    initialValue: false,
    model: .init {
      $0.title = "Checkbox"
//      $0.title = "Mi nombre es Mikhail Chelbaev y me dirijo a ustedes para solicitar la consideración de mi caso respecto a un documento del registro comercial de EE. UU. sin apostilla."
//      $0.color = .danger
//      $0.isEnabled = false
    }
  )

  override init(frame: CGRect) {
    super.init(frame: frame)

    self.setup()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func setup() {
    self.addSubview(self.checkbox)

    self.checkbox.centerVertically()
    self.checkbox.centerHorizontally()
  }
}

struct CheckboxesView: View {
  @State var isSelected = false
  @State var model = CheckboxVM {
    $0.title = "Checkbox"
    $0.color = .danger
  }

  var body: some View {
    UIViewRepresenting {
      Container()
    }
//    SUCheckbox(
//      isSelected: self.$isSelected,
//      model: self.model
//    )
  }
}

#Preview {
  CheckboxesView()
}
