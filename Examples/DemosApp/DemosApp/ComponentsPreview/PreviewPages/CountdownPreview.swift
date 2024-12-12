import ComponentsKit
import SwiftUI
import UIKit

struct CountdownPreview: View {
  @State private var model = CountdownVM()

  enum BaseStyle: String, CaseIterable {
    case plain, light
  }

  enum PositionOption: String, CaseIterable {
    case none, bottom, trailing
  }

  @State private var selectedBaseStyle: BaseStyle = .light
  @State private var selectedUnitsPosition: UnitsPosition = .bottom

  var body: some View {
    VStack {
      PreviewWrapper(title: "SwiftUI") {
        SUCountdown(model: self.model)
      }
      Form {
        ComponentOptionalColorPicker(selection: self.$model.color)
        FontPicker(selection: self.$model.font)
        SizePicker(selection: self.$model.size)

        Picker("Units Position", selection: $selectedUnitsPosition) {
          Text("None").tag(UnitsPosition.none)
          Text("Bottom").tag(UnitsPosition.bottom)
          Text("Trailing").tag(UnitsPosition.trailing)
        }
        .onChange(of: self.selectedUnitsPosition) { _ in
          self.updateModel()
        }

        Picker("Style", selection: $selectedBaseStyle) {
          Text("Plain").tag(BaseStyle.plain)
          Text("Light").tag(BaseStyle.light)
        }
        .onChange(of: self.selectedBaseStyle) { _ in
          self.updateModel()
        }

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

        DatePicker("Until Date", selection: $model.until, in: Date()..., displayedComponents: [.date, .hourAndMinute])
          .datePickerStyle(.compact)
      }
    }
    .onAppear {
      self.updateModel()
    }
  }

  private func updateModel() {
    switch self.selectedBaseStyle {
    case .plain:
      self.model.style = .plain
    case .light:
      self.model.style = .light
    }
    self.model.unitsPosition = self.selectedUnitsPosition
  }
}

#Preview {
  CountdownPreview()
}
