import SwiftKit
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
        Picker("Color", selection: self.$model.color) {
          Text("Primary").tag(ComponentColor.primary)
          Text("Secondary").tag(ComponentColor.secondary)
          Text("Accent").tag(ComponentColor.accent)
          Text("Success").tag(ComponentColor.success)
          Text("Warning").tag(ComponentColor.warning)
          Text("Danger").tag(ComponentColor.danger)
          Text("Custom").tag(ComponentColor(
            main: .init(universal: .uiColor(.systemPurple)),
            contrast: .init(universal: .uiColor(.systemYellow)))
          )
        }
        Picker("Corner Radius", selection: self.$model.cornerRadius) {
          Text("None").tag(ComponentRadius.none)
          Text("Small").tag(ComponentRadius.small)
          Text("Medium").tag(ComponentRadius.medium)
          Text("Large").tag(ComponentRadius.large)
          Text("Full").tag(ComponentRadius.full)
          Text("Custom: 2px").tag(ComponentRadius.custom(2))
        }
        Picker("Font", selection: self.$model.font) {
          Text("Default").tag(Optional<Typography>.none)
          Text("Small").tag(Typography.Component.small)
          Text("Medium").tag(Typography.Component.medium)
          Text("Large").tag(Typography.Component.large)
          Text("Custom: system bold of size 18").tag(Typography.system(size: 18, weight: .bold))
        }
        Toggle("Enabled", isOn: self.$model.isEnabled)
        Picker("Size", selection: self.$model.size) {
          Text("Small").tag(ComponentSize.small)
          Text("Medium").tag(ComponentSize.medium)
          Text("Large").tag(ComponentSize.large)
        }
      }
    }
  }
}

#Preview {
  CheckboxPreview()
}
