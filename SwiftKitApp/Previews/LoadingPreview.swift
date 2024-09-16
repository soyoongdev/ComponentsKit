import SwiftKit
import SwiftUI
import UIKit

struct LoadingPreview: View {
  @State private var model = LoadingVM()

//  public var color: ComponentColor = .primary
//  public var isAnimating: Bool = true
//  public var lineWidth: CGFloat?
//  public var size: LoadingSize = .medium
//  public var speed: CGFloat = 1.0
//  public var style: LoadingStyle = .spinner

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
        Toggle("Animating", isOn: self.$model.isAnimating)
        ComponentColorPicker(selection: self.$model.color)
        SizePicker(selection: self.$model.size)
        HStack {
          Text("Speed")
          Slider(value: self.$model.speed, in: 0...2, step: 0.1)
        }
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
