import ComponentsKit
import SwiftUI
import UIKit

struct CircularProgressPreview: View {
  @State private var model = Self.initialModel
  @State private var currentValue: CGFloat = Self.initialValue
  
  private let circularProgress = UKCircularProgress(
    initialValue: Self.initialValue,
    model: Self.initialModel
  )
  
  private let timer = Timer
    .publish(every: 0.5, on: .main, in: .common)
    .autoconnect()
  
  var body: some View {
    VStack {
      PreviewWrapper(title: "UIKit") {
        self.circularProgress
          .preview
          .onAppear {
            self.circularProgress.currentValue = Self.initialValue
            self.circularProgress.model = Self.initialModel
          }
          .onChange(of: model) { newModel in
            self.circularProgress.model = newModel
          }
          .onChange(of: self.currentValue) { newValue in
            self.circularProgress.currentValue = newValue
          }
      }
      PreviewWrapper(title: "SwiftUI") {
        SUCircularProgress(currentValue: self.currentValue, model: self.model)
      }
      Form {
        ComponentColorPicker(selection: self.$model.color)
        CaptionFontPicker(selection: self.$model.font)
        Picker("Line Width", selection: self.$model.lineWidth) {
          Text("Default").tag(Optional<CGFloat>.none)
          Text("2").tag(Optional<CGFloat>.some(2))
          Text("4").tag(Optional<CGFloat>.some(4))
          Text("8").tag(Optional<CGFloat>.some(8))
        }
        SizePicker(selection: self.$model.size)
        Picker("Shape", selection: self.$model.shape) {
          Text("Circle").tag(CircularProgressVM.Shape.circle)
          Text("Arc").tag(CircularProgressVM.Shape.arc)
        }
      }
      .onReceive(self.timer) { _ in
        if self.currentValue < self.model.maxValue {
          let step = (self.model.maxValue - self.model.minValue) / 100
          self.currentValue = min(
            self.model.maxValue,
            self.currentValue + CGFloat(Int.random(in: 1...20)) * step
          )
        } else {
          self.currentValue = self.model.minValue
        }
        self.model.label = "\(Int(self.currentValue))%"
      }
    }
  }
  
  // MARK: - Helpers
  
  private static var initialValue: Double {
    return 0.0
  }
  
  private static var initialModel = CircularProgressVM {
    $0.label = "0%"
    $0.shape = .arc
  }
}

#Preview {
  CircularProgressPreview()
}
