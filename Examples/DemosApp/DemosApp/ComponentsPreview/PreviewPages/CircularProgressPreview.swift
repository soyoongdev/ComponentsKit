import ComponentsKit
import SwiftUI
import UIKit

struct CircularProgressPreview: View {
  @State private var model = CircularProgressVM {
    $0.label = "0"
    $0.style = .light
    $0.minValue = 0
    $0.maxValue = 100
  }

  @State private var progress: CGFloat = 0

  var body: some View {
    VStack {
      PreviewWrapper(title: "SwiftUI") {
        SUCircularProgress(currentValue: self.progress, model: self.model)
      }
      Form {
        ComponentColorPicker(selection: self.$model.color)
        Picker("Font", selection: self.$model.font) {
          Text("Default").tag(Optional<UniversalFont>.none)
          Text("Small").tag(UniversalFont.smButton)
          Text("Medium").tag(UniversalFont.mdButton)
          Text("Large").tag(UniversalFont.lgButton)
          Text("Custom: system bold of size 16").tag(UniversalFont.system(size: 16, weight: .bold))
        }
        Picker("Line Width", selection: self.$model.lineWidth) {
          Text("Default").tag(Optional<CGFloat>.none)
          Text("2").tag(Optional<CGFloat>.some(2))
          Text("4").tag(Optional<CGFloat>.some(4))
          Text("8").tag(Optional<CGFloat>.some(8))
        }
        SizePicker(selection: self.$model.size)
        Picker("Style", selection: self.$model.style) {
          Text("Light").tag(CircularProgressVM.Style.light)
          Text("Striped").tag(CircularProgressVM.Style.striped)
        }
        HStack {
          Text("Min")
          Slider(value: self.$progress, in: self.model.minValue...self.model.maxValue, step: 1) {
          }
          Text("Max")
            .onChange(of: self.progress) { newValue in
            self.model.label = "\(Int(newValue))"
          }
        }
      }
    }
  }
}

#Preview {
  CircularProgressPreview()
}
