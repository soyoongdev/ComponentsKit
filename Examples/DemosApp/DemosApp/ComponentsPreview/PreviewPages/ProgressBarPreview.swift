import ComponentsKit
import SwiftUI
import UIKit

struct ProgressBarPreview: View {
  @State private var model = Self.initialModel
  
  private let progressBar = UKProgressBar(model: Self.initialModel)
  
  private let timer = Timer
    .publish(every: 0.5, on: .main, in: .common)
    .autoconnect()
  
  var body: some View {
    VStack {
      PreviewWrapper(title: "UIKit") {
        self.progressBar
          .preview
          .onAppear {
            self.progressBar.model = Self.initialModel
          }
          .onChange(of: self.model) { newValue in
            self.progressBar.model = newValue
          }
      }
      PreviewWrapper(title: "SwiftUI") {
        SUProgressBar(model: self.model)
      }
      Form {
        ComponentColorPicker(selection: self.$model.color)
        ComponentRadiusPicker(selection: self.$model.cornerRadius) {
          Text("Custom: 2px").tag(ComponentRadius.custom(2))
        }
        SizePicker(selection: self.$model.size)
        Picker("Style", selection: self.$model.style) {
          Text("Light").tag(ProgressBarVM.Style.light)
          Text("Filled").tag(ProgressBarVM.Style.filled)
          Text("Striped").tag(ProgressBarVM.Style.striped)
        }
      }
    }
    .onReceive(self.timer) { _ in
      if self.model.currentValue < self.model.maxValue {
        let step = (self.model.maxValue - self.model.minValue) / 100
        self.model.currentValue = min(
          self.model.maxValue,
          self.model.currentValue + CGFloat(Int.random(in: 1...20)) * step
        )
      } else {
        self.model.currentValue = self.model.minValue
      }
    }
  }
  
  // MARK: - Helpers
  
  private static var initialModel: ProgressBarVM {
    return .init()
  }
}

#Preview {
  ProgressBarPreview()
}
