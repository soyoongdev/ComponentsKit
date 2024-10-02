import SwiftComponents
import SwiftUI
import UIKit

struct LoadingPreview: View {
  @State private var model = LoadingVM()

  var body: some View {
    VStack {
      PreviewWrapper(title: "UIKit") {
        UKComponentPreview(model: self.model) {
          UKLoading(model: self.model)
        }
      }
      PreviewWrapper(title: "SwiftUI") {
        SULoading(model: self.model)
      }
      Form {
        ComponentColorPicker(selection: self.$model.color)
        Picker("Line Width", selection: self.$model.lineWidth) {
          Text("Default").tag(Optional<CGFloat>.none)
          Text("Custom: 6px").tag(CGFloat(6.0))
        }
        SizePicker(selection: self.$model.size)
        Picker("Style", selection: self.$model.style) {
          Text("Spinner").tag(LoadingStyle.spinner)
        }
      }
    }
  }
}

#Preview {
  LoadingPreview()
}
