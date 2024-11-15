import ComponentsKit
import SwiftUI

// MARK: - AutocapitalizationPicker

struct AutocapitalizationPicker: View {
  @Binding var selection: TextAutocapitalization

  var body: some View {
    Picker("Autocapitalization", selection: $selection) {
      Text("Never").tag(TextAutocapitalization.never)
      Text("Characters").tag(TextAutocapitalization.characters)
      Text("Words").tag(TextAutocapitalization.words)
      Text("Sentences").tag(TextAutocapitalization.sentences)
    }
  }
}

// MARK: - ComponentColorPicker

struct ComponentColorPicker: View {
  @Binding var selection: ComponentColor

  var body: some View {
    Picker("Color", selection: self.$selection) {
      Text("Primary").tag(ComponentColor.primary)
      Text("Secondary").tag(ComponentColor.secondary)
      Text("Accent").tag(ComponentColor.accent)
      Text("Success").tag(ComponentColor.success)
      Text("Warning").tag(ComponentColor.warning)
      Text("Danger").tag(ComponentColor.danger)
      Text("Custom").tag(ComponentColor(
        main: .universal(.uiColor(.systemPurple)),
        contrast: .universal(.uiColor(.systemYellow)))
      )
    }
  }
}

// MARK: - ComponentOptionalColorPicker

struct ComponentOptionalColorPicker: View {
  @Binding var selection: ComponentColor?

  var body: some View {
    Picker("Color", selection: self.$selection) {
      Text("Default").tag(Optional<ComponentColor>.none)
      Text("Primary").tag(ComponentColor.primary)
      Text("Secondary").tag(ComponentColor.secondary)
      Text("Accent").tag(ComponentColor.accent)
      Text("Success").tag(ComponentColor.success)
      Text("Warning").tag(ComponentColor.warning)
      Text("Danger").tag(ComponentColor.danger)
      Text("Custom").tag(ComponentColor(
        main: .universal(.uiColor(.systemPurple)),
        contrast: .universal(.uiColor(.systemYellow)))
      )
    }
  }
}

// MARK: - CornerRadiusPicker

struct CornerRadiusPicker<Custom: View>: View {
  @Binding var selection: ComponentRadius
  @ViewBuilder var custom: () -> Custom

  var body: some View {
    Picker("Corner Radius", selection: self.$selection) {
      Text("None").tag(ComponentRadius.none)
      Text("Small").tag(ComponentRadius.small)
      Text("Medium").tag(ComponentRadius.medium)
      Text("Large").tag(ComponentRadius.large)
      Text("Full").tag(ComponentRadius.full)
      self.custom()
    }
  }
}

// MARK: - FontPicker

struct FontPicker: View {
  @Binding var selection: UniversalFont?

  var body: some View {
    Picker("Font", selection: self.$selection) {
      Text("Default").tag(Optional<UniversalFont>.none)
      Text("Small").tag(UniversalFont.Component.small)
      Text("Medium").tag(UniversalFont.Component.medium)
      Text("Large").tag(UniversalFont.Component.large)
      Text("Custom: system bold of size 18").tag(UniversalFont.system(size: 18, weight: .bold))
    }
  }
}

// MARK: - KeyboardTypePicker

struct KeyboardTypePicker: View {
  @Binding var selection: UIKeyboardType

  var body: some View {
    Picker("Keyboard Type", selection: $selection) {
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
  }
}

// MARK: - SizePicker

struct SizePicker: View {
  @Binding var selection: ComponentSize

  var body: some View {
    Picker("Size", selection: self.$selection) {
      Text("Small").tag(ComponentSize.small)
      Text("Medium").tag(ComponentSize.medium)
      Text("Large").tag(ComponentSize.large)
    }
  }
}

// MARK: - SubmitTypePicker

struct SubmitTypePicker: View {
  @Binding var selection: SubmitType

  var body: some View {
    Picker("Submit Type", selection: $selection) {
      Text("done").tag(SubmitType.done)
      Text("go").tag(SubmitType.go)
      Text("join").tag(SubmitType.join)
      Text("route").tag(SubmitType.route)
      Text("return").tag(SubmitType.return)
      Text("next").tag(SubmitType.next)
      Text("continue").tag(SubmitType.continue)
    }
  }
}

// MARK: - UniversalColorPicker

struct UniversalColorPicker: View {
  let title: String
  @Binding var selection: UniversalColor

  var body: some View {
    Picker(self.title, selection: self.$selection) {
      Text("Primary").tag(UniversalColor.primary)
      Text("Secondary").tag(UniversalColor.secondary)
      Text("Accent").tag(UniversalColor.accent)
      Text("Success").tag(UniversalColor.success)
      Text("Warning").tag(UniversalColor.warning)
      Text("Danger").tag(UniversalColor.danger)
      Text("Custom").tag(UniversalColor.universal(.uiColor(.systemPurple)))
    }
  }
}
