import ComponentsKit
import SwiftUI
import UIKit

struct CardPreview: View {
  @State private var model = CardVM()
  
  var body: some View {
    VStack {
      PreviewWrapper(title: "UIKit") {
        UKCard(model: self.model, content: {
          let label = UILabel()
          label.text = "Hello World!"
          return label
        })
          .preview
      }
      Form {
        Picker("Background Color", selection: self.$model.backgroundColor) {
          Text("Default").tag(Optional<UniversalColor>.none)
          Text("Accent Background").tag(ComponentColor.accent.background)
          Text("Success Background").tag(ComponentColor.success.background)
          Text("Warning Background").tag(ComponentColor.warning.background)
          Text("Danger Background").tag(ComponentColor.danger.background)
        }
        Picker("Content Paddings", selection: self.$model.contentPaddings) {
          Text("12px").tag(Paddings(padding: 12))
          Text("16px").tag(Paddings(padding: 16))
          Text("20px").tag(Paddings(padding: 20))
        }
        ContainerRadiusPicker(selection: self.$model.cornerRadius) {
          Text("Custom 4px").tag(ContainerRadius.custom(4))
        }
      }
    }
  }
}

#Preview {
  CardPreview()
}
