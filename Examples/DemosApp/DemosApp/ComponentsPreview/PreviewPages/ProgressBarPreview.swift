import ComponentsKit
import SwiftUI
import UIKit

struct ProgressBarPreview: View {
  @State private var model = ProgressBarVM()
  @State private var currentValue: CGFloat = 50
  
  var body: some View {
    VStack {
      PreviewWrapper(title: "SwiftUI") {
        SUProgressBar(currentValue: $currentValue, model: model)
      }
      Form {
        ComponentColorPicker(selection: self.$model.color)
        Picker("Current Value", selection: $currentValue) {
          Text("0").tag(CGFloat(0))
          Text("25").tag(CGFloat(25))
          Text("50").tag(CGFloat(50))
          Text("75").tag(CGFloat(75))
          Text("100").tag(CGFloat(100))
        }
        SizePicker(selection: self.$model.size)
        Picker("Style", selection: $model.style) {
          Text("Light").tag(ProgressBarVM.ProgressBarStyle.light)
          Text("Filled").tag(ProgressBarVM.ProgressBarStyle.filled)
          Text("Striped").tag(ProgressBarVM.ProgressBarStyle.striped)
        }
      }
    }
  }
}

#Preview {
  ProgressBarPreview()
}
