import SwiftComponents
import SwiftUI
import UIKit

struct ButtonPreview: View {
  @State private var model = ButtonVM {
    $0.title = "Button"
  }

  var body: some View {
    VStack {
      PreviewWrapper(title: "UIKit") {
        UKComponentPreview(model: self.model) {
          UKButton(model: self.model)
        }
      }
      PreviewWrapper(title: "SwiftUI") {
        SUButton(model: self.model)
      }
      Form {
        Picker("Animation Scale", selection: self.$model.animationScale) {
          Text("None").tag(AnimationScale.none)
          Text("Small").tag(AnimationScale.small)
          Text("Medium").tag(AnimationScale.medium)
          Text("Large").tag(AnimationScale.large)
          Text("Custom: 0.9").tag(AnimationScale.custom(0.9))
        }
        ComponentColorPicker(selection: self.$model.color)
        CornerRadiusPicker(selection: self.$model.cornerRadius) {
          Text("Custom: 20px").tag(ComponentRadius.custom(20))
        }
        FontPicker(selection: self.$model.font)
        Toggle("Enabled", isOn: self.$model.isEnabled)
        Toggle("Full Width", isOn: self.$model.isFullWidth)
        SizePicker(selection: self.$model.size)
        Picker("Style", selection: self.$model.style) {
          Text("Filled").tag(ButtonStyle.filled)
          Text("Plain").tag(ButtonStyle.plain)
          Text("Bordered with small border").tag(ButtonStyle.bordered(.small))
          Text("Bordered with medium border").tag(ButtonStyle.bordered(.medium))
          Text("Bordered with large border").tag(ButtonStyle.bordered(.large))
          Text("Bordered with custom border: 6px").tag(ButtonStyle.bordered(.custom(6)))
        }
      }
    }
  }
}

#Preview {
  ButtonPreview()
}
