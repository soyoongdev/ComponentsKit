import ComponentsKit
import SwiftUI
import UIKit

struct BadgePreview: View {
  @State private var model = BadgeVM {
    $0.title = "Badge"
  }

  var body: some View {
    VStack {
      PreviewWrapper(title: "SwiftUI") {
        SUBadge(model: self.model)
      }
      Form {
        BadgeFontPicker(selection: self.$model.font)
        ComponentOptionalColorPicker(selection: self.$model.color)
        ComponentRadiusPicker(selection: self.$model.cornerRadius) {
          Text("Custom: 20px").tag(ComponentRadius.custom(20))
        }
        Picker("Style", selection: self.$model.style) {
          Text("Filled").tag(BadgeVM.Style.filled)
          Text("Light").tag(BadgeVM.Style.light)
        }
      }
    }
  }
}

#Preview {
  BadgePreview()
}
