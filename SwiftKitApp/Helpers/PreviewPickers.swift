import SwiftKit
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
        main: .init(universal: .uiColor(.systemPurple)),
        contrast: .init(universal: .uiColor(.systemYellow)))
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
        main: .init(universal: .uiColor(.systemPurple)),
        contrast: .init(universal: .uiColor(.systemYellow)))
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
  @Binding var selection: Typography?

  var body: some View {
    Picker("Font", selection: self.$selection) {
      Text("Default").tag(Optional<Typography>.none)
      Text("Small").tag(Typography.Component.small)
      Text("Medium").tag(Typography.Component.medium)
      Text("Large").tag(Typography.Component.large)
      Text("Custom: system bold of size 18").tag(Typography.system(size: 18, weight: .bold))
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

// MARK: - ThemeColorPicker

struct ThemeColorPicker: View {
  let title: String
  @Binding var selection: ThemeColor

  var body: some View {
    Picker(self.title, selection: self.$selection) {
      Text("Primary").tag(ThemeColor.primary)
      Text("Secondary").tag(ThemeColor.secondary)
      Text("Accent").tag(ThemeColor.accent)
      Text("Success").tag(ThemeColor.success)
      Text("Warning").tag(ThemeColor.warning)
      Text("Danger").tag(ThemeColor.danger)
      Text("Custom").tag(ThemeColor(universal: .uiColor(.systemPurple)))
    }
  }
}
