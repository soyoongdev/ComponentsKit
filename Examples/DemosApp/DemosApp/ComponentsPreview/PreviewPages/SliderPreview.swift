import SwiftUI
import ComponentsKit

struct SliderPreview: View {
  @State private var model = SliderVM {
    $0.style = .light
    $0.minValue = 0
    $0.maxValue = 100
    $0.cornerRadius = .full
  }
  @State private var currentValue: CGFloat = 30
  
  var body: some View {
    VStack {
      PreviewWrapper(title: "UIKit") {
        UKSlider(initialValue: self.currentValue, model: self.model)
          .preview
      }
      PreviewWrapper(title: "SwiftUI") {
        SUSlider(currentValue: self.$currentValue, model: self.model)
      }
      Form {
        ComponentColorPicker(selection: self.$model.color)
        ComponentRadiusPicker(selection: self.$model.cornerRadius) {
          Text("Custom: 2px").tag(ComponentRadius.custom(2))
        }
        SizePicker(selection: self.$model.size)
        Picker("Step", selection: self.$model.step) {
          Text("1").tag(CGFloat(1))
          Text("5").tag(CGFloat(5))
          Text("10").tag(CGFloat(10))
          Text("25").tag(CGFloat(25))
          Text("50").tag(CGFloat(50))
        }
        Picker("Style", selection: self.$model.style) {
          Text("Light").tag(SliderVM.Style.light)
          Text("Striped").tag(SliderVM.Style.striped)
        }
      }
    }
  }
}

#Preview {
  SliderPreview()
}
