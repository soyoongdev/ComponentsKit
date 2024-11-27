import ComponentsKit
import SwiftUI
import UIKit

struct RadioGroupPreview: View {
  @State private var selectedId: String?
  @State private var model: RadioGroupVM<String> = {
    var model = RadioGroupVM<String>()
    model.items = [
      RadioItemVM(id: "option1") { item in
        item.title = "Option 1"
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
      PreviewWrapper(title: "UIKit") {
        UKComponentPreview(model: self.model) {
          UKRadioGroup(model: self.model)
        }
      }
      PreviewWrapper(title: "SwiftUI") {
        SURadioGroup(selectedId: $selectedId, model: self.model)
      }
      Form {
        AnimationScalePicker(selection: self.$model.animationScale)
        Toggle("Enabled", isOn: self.$model.isEnabled)
        FontPicker(selection: self.$model.font)
        SizePicker(selection: self.$model.size)
        UniversalColorPicker(title: "Color", selection: self.$model.color)
      }
    }
  }
}

#Preview {
  RadioGroupPreview()
}
