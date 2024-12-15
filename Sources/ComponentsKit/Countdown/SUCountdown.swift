import SwiftUI

/// A SwiftUI component that displays a countdown.
public struct SUCountdown: View {
  // MARK: - Properties

  /// The countdown manager handling the countdown logic.
  @StateObject private var manager = CountdownManager()

  /// A model that defines the appearance properties.
  public var model: CountdownVM

  @State private var maxWidth: CGFloat = 0

  @Environment(\.colorScheme) private var colorScheme

  // MARK: - Initializer

  /// Initializer.
  /// - Parameters:
  ///   - model: A model that defines the appearance properties.
  public init(model: CountdownVM = .init()) {
    self.model = model
  }

  // MARK: - Body

  public var body: some View {
    HStack(spacing: self.model.style == .light ? 10 : 6) {
      switch (self.model.style, self.model.unitsPosition) {
      case (.plain, .bottom):
        self.styledTime(value: self.manager.days, unit: .days)
        self.styledTime(value: self.manager.hours, unit: .hours)
        self.styledTime(value: self.manager.minutes, unit: .minutes)
        self.styledTime(value: self.manager.seconds, unit: .seconds)

      case (.plain, .hidden), (.plain, .trailing):
        self.styledTime(value: self.manager.days, unit: .days)
        self.colonView
        self.styledTime(value: self.manager.hours, unit: .hours)
        self.colonView
        self.styledTime(value: self.manager.minutes, unit: .minutes)
        self.colonView
        self.styledTime(value: self.manager.seconds, unit: .seconds)

      case (.light, _):
        self.styledTime(value: self.manager.days, unit: .days)
        self.styledTime(value: self.manager.hours, unit: .hours)
        self.styledTime(value: self.manager.minutes, unit: .minutes)
        self.styledTime(value: self.manager.seconds, unit: .seconds)
      }
    }
    .onAppear {
      self.manager.start(until: self.model.until)
      self.calculateMaxWidth()
    }
    .onChange(of: self.model.until) { newDate in
      self.manager.stop()
      self.manager.start(until: newDate)
      self.calculateMaxWidth()
    }
    .onDisappear {
      self.manager.stop()
    }
  }

  private func styledTime(value: Int, unit: CountdownHelpers.Unit) -> some View {
    let attrString = self.model.unitText(value: value, unit: unit)
    let text = Text(attrString)
      .foregroundColor(self.model.foregroundColor.color(for: colorScheme))

    switch (self.model.style, self.model.unitsPosition) {
    case (.plain, .hidden), (.plain, .trailing):
      return text.eraseToAnyView()

    case (.plain, .bottom):
      return text
        .multilineTextAlignment(.center)
        .eraseToAnyView()

    case (.light, _):
      let wrapped = self.lightBackground {
        text
          .multilineTextAlignment(.center)
      }
      return wrapped.eraseToAnyView()
    }
  }

  private var colonView: some View {
    Text(":")
      .font(self.model.preferredFont.font)
      .foregroundColor(.gray)
  }

  private func lightBackground<Content: View>(@ViewBuilder _ content: () -> Content) -> some View {
    content()
      .frame(width: self.maxWidth, height: self.model.height)
      .background(
        RoundedRectangle(cornerRadius: 8)
          .fill(self.model.backgroundColor.color(for: self.colorScheme))
      )
  }

  private func calculateMaxWidth() {
    func stringForUnit(value: Int, unit: CountdownHelpers.Unit) -> String {
      let attrStr = model.unitText(value: value, unit: unit)
      return String(attrStr.characters)
    }

    let values: [(Int, CountdownHelpers.Unit)] = [
      (self.manager.days, .days),
      (self.manager.hours, .hours),
      (self.manager.minutes, .minutes),
      (self.manager.seconds, .seconds)
    ]

    let widths = values.map { value, unit -> CGFloat in
      let text = stringForUnit(value: value, unit: unit)
      return CountdownWidthCalculator.preferredWidth(for: text, model: model)
    }

    if let newMax = widths.max() {
      self.maxWidth = newMax
    } else {
      self.maxWidth = 55
    }
  }
}

extension View {
  func eraseToAnyView() -> AnyView {
    AnyView(self)
  }
}
