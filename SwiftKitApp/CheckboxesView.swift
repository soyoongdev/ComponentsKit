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
  lazy var button = UKButton(model: .init {
    $0.title = "Add / remove label"
  }) {
    self.checkbox.model.update {
      if $0.title.isNil {
        $0.title = "Checkbox"
      } else {
        $0.title = nil
      }
    }
  }

  override init(frame: CGRect) {
    super.init(frame: frame)

    self.setup()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func setup() {
    self.addSubview(self.checkbox)
    self.addSubview(self.button)

    self.checkbox.centerVertically()
    self.checkbox.centerHorizontally()

    self.button.centerHorizontally()
    self.button.below(of: self.checkbox, padding: 20)
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
