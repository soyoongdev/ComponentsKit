import ComponentsKit
import Observation
import SwiftUI
import UIKit

struct TextInputPreviewPreview: View {
  @State private var model = TextInputVM {
    $0.placeholder = "Placeholder"
    $0.minRows = 1
    $0.maxRows = nil
  }

  @State private var text: String = ""
  @FocusState private var isFocused: Bool

  @ObservedObject private var textInput = PreviewTextInput()

  var body: some View {
    VStack {
      PreviewWrapper(title: "UIKit") {
        UKComponentPreview(model: self.model) {
          self.textInput
        }
      }
      PreviewWrapper(title: "SwiftUI") {
        SUTextInput(
          text: self.$text,
          isFocused: self.$isFocused,
          model: self.model
        )
      }
      Form {
        AutocapitalizationPicker(selection: self.$model.autocapitalization)
        Toggle("Autocorrection Enabled", isOn: self.$model.isAutocorrectionEnabled)
        ComponentOptionalColorPicker(selection: self.$model.color)
        CornerRadiusPicker(selection: self.$model.cornerRadius) {
          Text("Custom: 20px").tag(ComponentRadius.custom(20))
        }
        Toggle("Enabled", isOn: self.$model.isEnabled)
        FontPicker(selection: self.$model.font)
        KeyboardTypePicker(selection: self.$model.keyboardType)
        Picker("Max Rows", selection: self.$model.maxRows) {
          Text("2 Rows").tag(2)
          Text("3 Rows").tag(3)
          Text("No Limit").tag(Optional<Int>.none)
        }
        Picker("Min Rows", selection: self.$model.minRows) {
          Text("1 Row").tag(1)
          Text("2 Rows").tag(2)
        }
        Toggle("Placeholder", isOn: .init(
          get: {
            return self.model.placeholder != nil
          },
          set: { newValue in
            self.model.placeholder = newValue ? "Placeholder" : nil
          }
        ))
        SizePicker(selection: self.$model.size)
        SubmitTypePicker(selection: self.$model.submitType)
        UniversalColorPicker(
          title: "Tint Color",
          selection: self.$model.tintColor
        )
      }
    }
    .toolbar {
      ToolbarItem(placement: .primaryAction) {
        if (self.textInput.isEditing || self.isFocused) && !ProcessInfo.processInfo.isiOSAppOnMac {
          Button("Hide Keyboard") {
            self.isFocused = false
            self.textInput.resignFirstResponder()
          }
        }
      }
    }
  }
}

private final class PreviewTextInput: UKTextInput, ObservableObject {
  @Published var isEditing: Bool = false

  func textViewDidBeginEditing(_ textView: UITextView) {
    self.isEditing = true
  }
  func textViewDidEndEditing(_ textView: UITextView) {
    self.isEditing = false
  }
}

#Preview {
  TextInputPreviewPreview()
}
