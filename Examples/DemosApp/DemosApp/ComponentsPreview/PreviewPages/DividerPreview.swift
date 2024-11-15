import ComponentsKit
import SwiftUI
import UIKit

struct DividerPreview: View {
  @State private var model = DividerVM()

  var body: some View {
    VStack {
      PreviewWrapper(title: "SwiftUI") {
        SUDivider(model: self.model)
      }
      Form {
        Picker("Orientation", selection: self.$model.orientation) {
          Text("Horizontal").tag(DividerVM.Orientation.horizontal)
          Text("Vertical").tag(DividerVM.Orientation.vertical)
        }
        SizePicker(selection: self.$model.size)
        UniversalColorPicker(
          title: "Color",
          selection: self.$model.color
        ) {
          Text("Default").tag(Palette.Base.divider)
        }
      }
    }
  }
}

#Preview {
  DividerPreview()
}
