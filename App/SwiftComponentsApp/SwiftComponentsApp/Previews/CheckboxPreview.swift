import SwiftComponents
import SwiftUI
import UIKit

struct CheckboxPreview: View {
  @State private var model = CheckboxVM {
    $0.title = "Checkbox"
  }

  @State private var isSelected: Bool = false

  var body: some View {
    VStack {
      PreviewWrapper(title: "UIKit") {
        UKComponentPreview(model: self.model) {
          UKCheckbox(
            initialValue: false,
            model: self.model
          )
        }
      }
      PreviewWrapper(title: "SwiftUI") {
        SUCheckbox(
          isSelected: self.$isSelected,
          model: self.model
        )
      }
      Form {
        Picker("Title", selection: self.$model.title) {
          Text("None").tag(Optional<String>.none)
          Text("Short").tag("Checkbox")
          Text("Long").tag("Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.")
        }
        ComponentColorPicker(selection: self.$model.color)
        CornerRadiusPicker(selection: self.$model.cornerRadius) {
          Text("Custom: 2px").tag(ComponentRadius.custom(2))
        }
        FontPicker(selection: self.$model.font)
        Toggle("Enabled", isOn: self.$model.isEnabled)
        SizePicker(selection: self.$model.size)
      }
    }
  }
}

#Preview {
  CheckboxPreview()
}
