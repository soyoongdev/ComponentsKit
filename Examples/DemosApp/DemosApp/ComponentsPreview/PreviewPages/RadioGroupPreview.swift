import ComponentsKit
import SwiftUI
import UIKit

struct RadioGroupPreview: View {
  @State private var selectedId: String? = nil
  @State private var model: RadioGroupVM<String> = {
    var model = RadioGroupVM<String>()
    model.items = [
      RadioItemVM(id: "option1") { item in
        item.title = "Option 1"
        item.isEnabled = false
      },
      RadioItemVM(id: "option2") { item in
        item.title = "Option 2"
      },
      RadioItemVM(id: "option3") { item in
        item.title = "Option 3"
      }
    ]
    return model
  }()
  
  var body: some View {
    VStack {
      PreviewWrapper(title: "SwiftUI") {
        SURadioGroup(selectedId: $selectedId, model: self.model)
      }
      Form {
        Picker("Color", selection: self.$model.color) {
          Text("Primary").tag(UniversalColor.primary)
          Text("Secondary").tag(UniversalColor.secondary)
          Text("Accent").tag(UniversalColor.accent)
          Text("Success").tag(UniversalColor.success)
          Text("Warning").tag(UniversalColor.warning)
          Text("Danger").tag(UniversalColor.danger)
          Text("Custom").tag(UniversalColor.universal(.uiColor(.systemPurple)))
        }
        Toggle("Enabled", isOn: self.$model.isEnabled)
        FontPicker(selection: self.$model.font)
        SizePicker(selection: self.$model.size)
      }
    }
  }
}

#Preview {
  RadioGroupPreview()
}
