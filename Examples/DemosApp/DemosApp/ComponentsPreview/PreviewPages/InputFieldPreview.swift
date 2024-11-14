import ComponentsKit
import Observation
import SwiftUI
import UIKit

struct InputFieldPreview: View {
  @State private var model = InputFieldVM {
    $0.title = "Title"
  }

  @State private var text: String = ""
  @FocusState private var isFocused: Bool

  private let inputField = UKInputField()
  private let inputFieldDelegate = InputFieldDelegate()

  var body: some View {
    VStack {
      PreviewWrapper(title: "UIKit") {
        UKComponentPreview(model: self.model) {
          self.inputField
        }
      }
      PreviewWrapper(title: "SwiftUI") {
        SUInputField(
          text: self.$text,
          isFocused: self.$isFocused,
          model: self.model
        )
      }
      Form {
        AutocapitalizationPicker(selection: self.$model.autocapitalization)
        AutocorrectionToggle(isOn: self.$model.isAutocorrectionEnabled)
        ComponentOptionalColorPicker(selection: self.$model.color)
        CornerRadiusPicker(selection: self.$model.cornerRadius) {
          Text("Custom: 20px").tag(ComponentRadius.custom(20))
        }
        EnabledToggle(isOn: self.$model.isEnabled)
        FontPicker(selection: self.$model.font)
        KeyboardTypePicker(selection: self.$model.keyboardType)
        PlaceholderToggle(placeholder: self.$model.placeholder)
        Toggle("Required", isOn: self.$model.isRequired)
        Toggle("Secure Input", isOn: self.$model.isSecureInput)
        SizePicker(selection: self.$model.size)
        SubmitTypePicker(selection: self.$model.submitType)
        UniversalColorPicker(
          title: "Tint Color",
          selection: self.$model.tintColor
        )
        Toggle("Title", isOn: .init(
          get: {
            return self.model.title != nil
          },
          set: { newValue in
            self.model.title = newValue ? "Title" : nil
          }
        ))
      }
    }
    .onAppear {
      self.inputField.textField.delegate = self.inputFieldDelegate
    }
    .toolbar {
      ToolbarItem(placement: .primaryAction) {
        if (self.inputFieldDelegate.isEditing || self.isFocused) && !ProcessInfo.processInfo.isiOSAppOnMac {
          Button("Hide Keyboard") {
            self.isFocused = false
            self.inputField.resignFirstResponder()
          }
        }
      }
    }
  }
}

@Observable
private final class InputFieldDelegate: NSObject, UITextFieldDelegate {
  var isEditing: Bool = false

  func textFieldDidBeginEditing(_ textField: UITextField) {
    self.isEditing = true
  }
  func textFieldDidEndEditing(_ textField: UITextField) {
    self.isEditing = false
  }
}

#Preview {
  InputFieldPreview()
}
