import ComponentsKit
import SwiftUI
import UIKit

struct DividerPreview: View {
  @State private var model = DividerVM()

  var body: some View {
    VStack {
      PreviewWrapper(title: "UIKit") {
        UKDivider(model: self.model)
          .preview
      }
      PreviewWrapper(title: "SwiftUI") {
        SUDivider(model: self.model)
      }
      Form {
        Picker("Color", selection: self.$model.color) {
          Text("Default").tag(Optional<ComponentColor>.none)
          Text("Primary").tag(ComponentColor.primary)
          Text("Accent").tag(ComponentColor.accent)
          Text("Success").tag(ComponentColor.success)
          Text("Warning").tag(ComponentColor.warning)
          Text("Danger").tag(ComponentColor.danger)
          Text("Custom").tag(ComponentColor(
            main: .universal(.uiColor(.systemPurple)),
            contrast: .universal(.uiColor(.systemYellow))
          ))
        }
        Picker("Orientation", selection: self.$model.orientation) {
          Text("Horizontal").tag(DividerVM.Orientation.horizontal)
          Text("Vertical").tag(DividerVM.Orientation.vertical)
        }
        SizePicker(selection: self.$model.size)
      }
    }
  }
}

#Preview {
  DividerPreview()
}
