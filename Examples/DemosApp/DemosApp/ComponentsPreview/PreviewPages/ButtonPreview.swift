import ComponentsKit
import SwiftUI
import UIKit

struct ButtonPreview: View {
  @State private var model = ButtonVM {
    $0.title = "Button"
  }

  var body: some View {
    VStack {
      PreviewWrapper(title: "UIKit") {
        UKButton(model: self.model)
          .preview
      }
      PreviewWrapper(title: "SwiftUI") {
        SUButton(model: self.model)
      }
      Form {
        AnimationScalePicker(selection: self.$model.animationScale)
        ComponentOptionalColorPicker(selection: self.$model.color)
        ComponentRadiusPicker(selection: self.$model.cornerRadius) {
          Text("Custom: 20px").tag(ComponentRadius.custom(20))
        }
        ButtonFontPicker(selection: self.$model.font)
        Toggle("Enabled", isOn: self.$model.isEnabled)
        Toggle("Full Width", isOn: self.$model.isFullWidth)
        SizePicker(selection: self.$model.size)
        Picker("Style", selection: self.$model.style) {
          Text("Filled").tag(ButtonStyle.filled)
          Text("Plain").tag(ButtonStyle.plain)
          Text("Light").tag(ButtonStyle.light)
          Text("Bordered with small border").tag(ButtonStyle.bordered(.small))
          Text("Bordered with medium border").tag(ButtonStyle.bordered(.medium))
          Text("Bordered with large border").tag(ButtonStyle.bordered(.large))
        }
      }
    }
  }
}

#Preview {
  ButtonPreview()
}
