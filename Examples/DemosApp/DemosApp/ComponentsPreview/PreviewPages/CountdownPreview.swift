import ComponentsKit
import SwiftUI
import UIKit

struct CountdownPreview: View {
  @State private var model: CountdownVM = {
    var vm = CountdownVM()
    vm.until = Date().addingTimeInterval(3600)
    vm.localization = UnitsLocalization.defaultLocalizations
    return vm
  }()
  @State private var selectedLocale = Locale(identifier: "en")

  var body: some View {
    VStack {
      PreviewWrapper(title: "SwiftUI") {
        SUCountdown(model: self.model)
      }
      Form {
        ComponentOptionalColorPicker(selection: self.$model.color)
        FontPicker(selection: self.$model.font)
        SizePicker(selection: self.$model.size)
        Picker("Units Position", selection: $model.unitsPosition) {
          Text("None").tag(CountdownUnitsPosition.none)
          Text("Bottom").tag(CountdownUnitsPosition.bottom)
          Text("Trailing").tag(CountdownUnitsPosition.trailing)
        }
        .onChange(of: self.model.unitsPosition) { newValue in
          if newValue != .bottom {
            self.model.style = .plain
          }
        }
        Picker("Style", selection: $model.style) {
          Text("Plain").tag(CountdownStyle.plain)
          Text("Light").tag(CountdownStyle.light)
        }
        .onChange(of: self.model.style) { newValue in
          if newValue == .light && self.model.unitsPosition != .bottom {
            self.model.unitsPosition = .bottom
          }
        }
        Picker("Locale", selection: self.$model.locale) {
          Text("Current").tag(Locale.current)
          Text("EN").tag(Locale.current)
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
        DatePicker("Until Date", selection: $model.until, in: Date()..., displayedComponents: [.date, .hourAndMinute])
          .datePickerStyle(.compact)
      }
    }
  }
}

#Preview {
  CountdownPreview()
}
