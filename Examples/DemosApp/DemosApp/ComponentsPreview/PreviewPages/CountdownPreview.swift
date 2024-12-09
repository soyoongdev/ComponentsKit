import ComponentsKit
import SwiftUI
import UIKit

struct CountdownPreview: View {
  @State private var model = CountdownVM(
    until: Date().addingTimeInterval(3600),
    localization: defaultLocalizations
  )
  @State private var tempUntil = Date()
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
          Text("None").tag(UnitsPosition.none)
          Text("Bottom").tag(UnitsPosition.bottom)
          Text("Trailing").tag(UnitsPosition.trailing)
        }
        .onChange(of: model.unitsPosition) { newValue in
          if newValue != .bottom {
            model.style = .plain
          }
        }
        Picker("Style", selection: $model.style) {
          Text("Plain").tag(CountdownStyle.plain)
          Text("Light").tag(CountdownStyle.light)
        }
        .onChange(of: model.style) { newValue in
          if newValue == .light && model.unitsPosition != .bottom {
            model.unitsPosition = .bottom
          }
        }
        Picker("Localization", selection: $selectedLocale) {
          ForEach(defaultLocalizations.keys.sorted(by: { $0.identifier < $1.identifier }), id: \.self) { locale in
            Text(locale.localizedString(forIdentifier: locale.identifier) ?? locale.identifier)
              .tag(locale)
          }
        }
        .onChange(of: selectedLocale) { newLocale in
          model.locale = newLocale
        }
        DatePicker("Select Date and Time", selection: $tempUntil, in: Date()..., displayedComponents: [.date, .hourAndMinute])
          .datePickerStyle(.compact)
      }
    }
    .toolbar {
      ToolbarItem(placement: .navigationBarTrailing) {
        if tempUntil > Date() {
          Button("Update Timer") {
            model.until = tempUntil
          }
        }
      }
    }
  }
}

#Preview {
  CountdownPreview()
}
