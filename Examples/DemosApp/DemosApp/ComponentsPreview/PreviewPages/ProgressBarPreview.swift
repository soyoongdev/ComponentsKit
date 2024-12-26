import ComponentsKit
import SwiftUI
import UIKit

struct ProgressBarPreview: View {
  @State private var model = ProgressBarVM()
  @State private var currentValue: CGFloat = 75
  
  var body: some View {
    VStack {
      PreviewWrapper(title: "SwiftUI") {
        SUProgressBar(currentValue: $currentValue, model: model)
      }
      Form {
        ComponentColorPicker(selection: self.$model.color)
        Stepper("Current Value", value: $currentValue, in: self.model.minValue...self.model.maxValue, step: 10)
        CornerRadiusPicker(selection: self.$model.cornerRadius) {
          Text("Custom: 2px").tag(ComponentRadius.custom(2))
        }
        SizePicker(selection: self.$model.size)
        Picker("Style", selection: $model.style) {
          Text("Light").tag(ProgressBarVM.Style.light)
          Text("Filled").tag(ProgressBarVM.Style.filled)
          Text("Striped").tag(ProgressBarVM.Style.striped)
        }
      }
    }
  }
}

#Preview {
  ProgressBarPreview()
}
