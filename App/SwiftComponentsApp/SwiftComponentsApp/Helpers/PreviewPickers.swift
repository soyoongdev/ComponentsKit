import SwiftComponents
import SwiftUI

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
  @Binding var selection: ComponentRadius?
  @ViewBuilder var custom: () -> Custom

  var body: some View {
    Picker("Corner Radius", selection: self.$selection) {
      Text("Default").tag(Optional<ComponentRadius>.none)
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
