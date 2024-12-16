import SwiftUI

/// A SwiftUI component that displays a countdown.
public struct SUCountdown: View {
  // MARK: - Properties

  /// The countdown manager handling the countdown logic.
  @StateObject private var manager = CountdownManager()

  /// A model that defines the appearance properties.
  public var model: CountdownVM

  @State private var width: CGFloat = 70

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
        colonView.offset(y: colonOffset())
        self.styledTime(value: self.manager.hours, unit: .hours)
        colonView
        self.styledTime(value: self.manager.minutes, unit: .minutes)
        colonView
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
        self.lightStyledTime(value: self.manager.days, unit: .days)
        self.lightStyledTime(value: self.manager.hours, unit: .hours)
        self.lightStyledTime(value: self.manager.minutes, unit: .minutes)
        self.lightStyledTime(value: self.manager.seconds, unit: .seconds)
      }
    }
    .onAppear {
      self.manager.start(until: self.model.until)
      self.calculateWidth()
    }
    .onChange(of: self.model.until) { newDate in
      self.manager.stop()
      self.manager.start(until: newDate)
      self.calculateWidth()
    }
    .onChange(of: self.model.style) { _ in
      self.calculateWidth()
    }
    .onChange(of: self.model.size) { _ in
      self.calculateWidth()
    }
    .onChange(of: self.model.unitsPosition) { _ in
      self.calculateWidth()
    }
    .onChange(of: self.model.font) { _ in
      self.calculateWidth()
    }
    .onDisappear {
      self.manager.stop()
    }
  }

  @ViewBuilder
  private func styledTime(value: Int, unit: CountdownHelpers.Unit) -> some View {
    let nsAttrStr = self.model.unitText(value: value, unit: unit)
    let attrString = AttributedString(nsAttrStr)
    return Text(attrString)
      .foregroundColor(self.model.foregroundColor.color(for: colorScheme))
      .multilineTextAlignment(.center)
      .frame(width: self.width)
  }

  private var colonView: some View {
    Text(":")
      .font(self.model.preferredFont.font)
      .foregroundColor(.gray)
  }

  private func colonOffset() -> CGFloat {
    let mainFontHeight = self.model.preferredFont.uiFont.lineHeight
    let colonFontHeight = self.model.preferredFont.uiFont.lineHeight
    return (mainFontHeight - colonFontHeight)
  }

  private func lightStyledTime(value: Int, unit: CountdownHelpers.Unit) -> some
  View {
    return self.styledTime(value: value, unit: unit)
      .frame(width: self.width, height: self.model.height)
      .background(RoundedRectangle(cornerRadius: 8)
        .fill(self.model.backgroundColor.color(for: self.colorScheme))
      )
  }
  private func calculateWidth() {
    let values: [(Int, CountdownHelpers.Unit)] = [
      (self.manager.days, .days),
      (self.manager.hours, .hours),
      (self.manager.minutes, .minutes),
      (self.manager.seconds, .seconds)
    ]

    let widths = values.map { value, unit -> CGFloat in
      let nsAttrStr = self.model.unitText(value: value, unit: unit)
      return CountdownWidthCalculator.preferredWidth(for: nsAttrStr, model: self.model)
    }

    if let newMax = widths.max() {
      self.width = newMax
    } else {
      self.width = 55
    }
  }
}

extension View {
  func eraseToAnyView() -> AnyView {
    AnyView(self)
  }
}
