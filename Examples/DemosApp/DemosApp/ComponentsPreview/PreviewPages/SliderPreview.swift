import SwiftUI
import ComponentsKit

struct SliderPreview: View {
  @State private var model = Self.initialModel
  @State private var currentValue: CGFloat = Self.initialValue
  
  var body: some View {
    VStack {
      PreviewWrapper(title: "UIKit") {
        UKSlider(model: self.model)
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
  
  // MARK: - Helpers
  
  private static var initialValue: CGFloat {
    50
  }
  
  private static var initialModel: SliderVM {
    var model = SliderVM()
    model.style = .light
    model.minValue = 0
    model.maxValue = 100
    model.cornerRadius = .full
    return model
  }
}

#Preview {
  SliderPreview()
}
