import ComponentsKit
import SwiftUI
import UIKit

struct CountdownPreview: View {
  @State private var model = CountdownVM()

  var body: some View {
    VStack {
      PreviewWrapper(title: "UIKit") {
        UKCountdown(model: self.model)
        .preview
      }
      PreviewWrapper(title: "SwiftUI") {
        SUCountdown(model: self.model)
      }
      Form {
        ComponentOptionalColorPicker(selection: self.$model.color)
        FontPicker(selection: self.$model.font)
        Picker("Locale", selection: self.$model.locale) {
          Text("Current").tag(Locale.current)
          Text("EN").tag(Locale(identifier: "en"))
          Text("ES").tag(Locale(identifier: "es"))
          Text("FR").tag(Locale(identifier: "fr"))
          Text("DE").tag(Locale(identifier: "de"))
          Text("ZH").tag(Locale(identifier: "zh"))
          Text("JA").tag(Locale(identifier: "ja"))
          Text("RU").tag(Locale(identifier: "ru"))
          Text("AR").tag(Locale(identifier: "ar"))
          Text("HI").tag(Locale(identifier: "hi"))
          Text("PT").tag(Locale(identifier: "pt"))
        }
        SizePicker(selection: self.$model.size)
        Picker("Style", selection: self.$model.style) {
          Text("Plain").tag(CountdownVM.Style.plain)
          Text("Light").tag(CountdownVM.Style.light)
        }
        Picker("Units Style", selection: self.$model.unitsStyle) {
          Text("None").tag(CountdownVM.UnitsStyle.hidden)
          Text("Bottom").tag(CountdownVM.UnitsStyle.bottom)
          Text("Trailing").tag(CountdownVM.UnitsStyle.trailing)
        }
        DatePicker("Until Date", selection: self.$model.until, in: Date()..., displayedComponents: [.date, .hourAndMinute])
          .datePickerStyle(.compact)
      }
    }
  }
}

#Preview {
  CountdownPreview()
}
