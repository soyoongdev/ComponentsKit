import SwiftKit
import SwiftUI
import UIKit

struct ButtonPreview: View {
  @State private var model = ButtonVM {
    $0.title = "Tap me please"
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
          Text("Custom: 20px").tag(ComponentRadius.custom(20))
        }
        Picker("Font", selection: self.$model.font) {
          Text("Default").tag(Optional<Typography>.none)
          Text("Small").tag(Typography.Component.small)
          Text("Medium").tag(Typography.Component.medium)
          Text("Large").tag(Typography.Component.large)
          Text("Custom: system bold of size 18").tag(Typography.system(size: 18, weight: .bold))
        }
        Toggle("Enabled", isOn: self.$model.isEnabled)
        Toggle("Full Width", isOn: self.$model.isFullWidth)
        Picker("Size", selection: self.$model.size) {
          Text("Small").tag(ComponentSize.small)
          Text("Medium").tag(ComponentSize.medium)
          Text("Large").tag(ComponentSize.large)
        }
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
