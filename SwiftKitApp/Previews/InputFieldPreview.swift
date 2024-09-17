import SwiftKit
import SwiftUI
import UIKit

struct InputFieldPreview: View {
  @State private var model = InputFieldVM {
    $0.title = "Title"
  }

  @State private var text: String = ""
  @FocusState private var isSelected: Bool

  var body: some View {
    VStack {
      PreviewWrapper(title: "UIKit") {
        UKComponentPreview(model: self.model) {
          UKInputField(model: self.model)
        }
      }
      PreviewWrapper(title: "SwiftUI") {
        SUInputField(
          text: self.$text,
          isSelected: self.$isSelected,
          model: self.model
        )
      }
      Form {
        Picker("Autocapitalization", selection: self.$model.autocapitalization) {
          Text("Never").tag(InputFieldTextAutocapitalization.never)
          Text("Characters").tag(InputFieldTextAutocapitalization.characters)
          Text("Words").tag(InputFieldTextAutocapitalization.words)
          Text("Sentences").tag(InputFieldTextAutocapitalization.sentences)
        }
        Toggle("Autocorrection Enabled", isOn: self.$model.isAutocorrectionEnabled)
        ComponentOptionalColorPicker(selection: self.$model.color)
        FontPicker(selection: self.$model.font)

        CornerRadiusPicker(selection: self.$model.cornerRadius) {
          Text("Custom: 20px").tag(ComponentRadius.custom(20))
        }
        Toggle("Enabled", isOn: self.$model.isEnabled)
        FontPicker(selection: self.$model.font)
        Picker("Keyboard Type", selection: self.$model.keyboardType) {
          Text("Default").tag(UIKeyboardType.default)
          Text("asciiCapable").tag(UIKeyboardType.asciiCapable)
          Text("numbersAndPunctuation").tag(UIKeyboardType.numbersAndPunctuation)
          Text("URL").tag(UIKeyboardType.URL)
          Text("numberPad").tag(UIKeyboardType.numberPad)
          Text("phonePad").tag(UIKeyboardType.phonePad)
          Text("namePhonePad").tag(UIKeyboardType.namePhonePad)
          Text("emailAddress").tag(UIKeyboardType.emailAddress)
          Text("decimalPad").tag(UIKeyboardType.decimalPad)
          Text("twitter").tag(UIKeyboardType.twitter)
          Text("webSearch").tag(UIKeyboardType.webSearch)
          Text("asciiCapableNumberPad").tag(UIKeyboardType.asciiCapableNumberPad)
        }
        Toggle("Placeholder", isOn: .init(
          get: {
            return self.model.placeholder.isNotNilAndEmpty
          },
          set: { newValue in
            if newValue {
              self.model.placeholder = "Placeholder"
            } else {
              self.model.placeholder = nil
            }
          }
        ))
        Toggle("Required", isOn: self.$model.isRequired)
        Toggle("Secure Input", isOn: self.$model.isSecureInput)
        SizePicker(selection: self.$model.size)
        Picker("Submit Type", selection: self.$model.submitType) {
          Text("done").tag(SubmitType.done)
          Text("go").tag(SubmitType.go)
          Text("join").tag(SubmitType.join)
          Text("route").tag(SubmitType.route)
          Text("return").tag(SubmitType.return)
          Text("next").tag(SubmitType.next)
          Text("continue").tag(SubmitType.continue)
        }
        UniversalColorPicker(
          title: "Tint Color",
          selection: self.$model.tintColor
        )
      }
    }
  }
}

#Preview {
  InputFieldPreview()
}
