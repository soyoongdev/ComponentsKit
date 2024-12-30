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
      PreviewWrapper(title: "UIKit") {
        UKProgressBarRepresentable(currentValue: $currentValue, model: self.model)
      }
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

struct UKProgressBarRepresentable: UIViewRepresentable {
  @Binding var currentValue: CGFloat
  var model: ProgressBarVM
  
  func makeUIView(context: Context) -> UKProgressBar {
    let progressBar = UKProgressBar(currentValue: currentValue, model: model)
    return progressBar
  }
  
  func updateUIView(_ uiView: UKProgressBar, context: Context) {
    uiView.currentValue = currentValue
    uiView.model = model
    uiView.setNeedsLayout()
  }
  
  static func dismantleUIView(_ uiView: UKProgressBar, coordinator: ()) {
  }
}

#Preview {
  ProgressBarPreview()
}
