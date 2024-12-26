import ComponentsKit
import SwiftUI
import UIKit

struct ProgressBarPreview: View {
  @State private var model = ProgressBarVM()
  @State private var currentValue: CGFloat = 0
  private let timer = Timer
    .publish(every: 0.1, on: .main, in: .common)
    .autoconnect()
  
  var body: some View {
    VStack {
      PreviewWrapper(title: "SwiftUI") {
        SUProgressBar(currentValue: $currentValue, model: self.model)
      }
      Form {
        ComponentColorPicker(selection: self.$model.color)
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
    .onReceive(timer) { _ in
      if self.currentValue < self.model.maxValue {
        self.currentValue += 1
      } else {
        self.currentValue = 0
      }
    }
  }
}

#Preview {
  ProgressBarPreview()
}
