import SwiftUI

/// A SwiftUI component that displays a countdown.
public struct SUCountdown: View {
  // MARK: - Properties

  /// The countdown manager handling the countdown logic.
  @StateObject private var manager: CountdownManager

  /// A model that defines the appearance properties.
  public var model: CountdownVM

  // MARK: - Initializers

  public init(model: CountdownVM = CountdownVM()) {
    self.model = model
    _manager = StateObject(wrappedValue: CountdownManager())
  }

  @Environment(\.colorScheme) private var colorScheme

  // MARK: - Body

  public var body: some View {
    VStack {
      switch self.model.unitsPosition {
      case .trailing:
        self.trailingLayout

      case .bottom:
        self.bottomLayout

      case .none:
        self.noneLayout
      }
    }
    .onAppear {
      self.manager.start(until: self.model.until)
    }
    .onChange(of: model.until) { newDate in
      self.manager.stop()
      self.manager.start(until: newDate)
    }
    .onDisappear {
      self.manager.stop()
    }
  }

  // MARK: - Layouts

  private var trailingLayout: some View {
    HStack(spacing: 2) {
      self.styledCountdownText(for: self.manager.days)
      self.colonView()
      self.styledCountdownText(for: self.manager.hours)
      self.colonView()
      self.styledCountdownText(for: self.manager.minutes)
      self.colonView()
      self.styledCountdownText(for: self.manager.seconds)
    }
  }

  private var bottomLayout: some View {
    HStack(spacing: 10) {
      self.styledCountdownUnitView(value: self.manager.days, unit: .days)
      if self.model.style != .light { self.colonView().padding(.bottom, 16) }
      self.styledCountdownUnitView(value: self.manager.hours, unit: .hours)
      if self.model.style != .light { self.colonView().padding(.bottom, 16) }
      self.styledCountdownUnitView(value: self.manager.minutes, unit: .minutes)
      if self.model.style != .light { self.colonView().padding(.bottom, 16) }
      self.styledCountdownUnitView(value: self.manager.seconds, unit: .seconds)
    }
  }

  private var noneLayout: some View {
    HStack(spacing: 4) {
      self.styledCountdownText(for: self.manager.days)
      self.colonView()
      self.styledCountdownText(for: self.manager.hours)
      self.colonView()
      self.styledCountdownText(for: self.manager.minutes)
      self.colonView()
      self.styledCountdownText(for: self.manager.seconds)
    }
  }

  // MARK: - Methods

  private func formattedTimeWithUnits() -> String {
    let localization = model.localization[model.locale] ?? UnitsLocalization.defaultLocalization

    return String(
      format: "%02d %@ : %02d %@ : %02d %@ : %02d %@",
      self.manager.days,
      localization.days.short,
      self.manager.hours,
      localization.hours.short,
      self.manager.minutes,
      localization.minutes.short,
      self.manager.seconds,
      localization.seconds.short
    )
  }

  private func styledCountdownUnitView(value: Int, unit: Unit) -> some View {
    Group {
      if self.model.style == .light && self.model.unitsPosition == .bottom {
        self.countdownUnitView(value: value, unit: unit)
          .frame(width: 55, height: self.model.height)
          .background(
            RoundedRectangle(cornerRadius: 8)
              .fill(self.model.backgroundColor.color(for: self.colorScheme))
          )
      } else {
        self.countdownUnitView(value: value, unit: unit)
      }
    }
  }

  private func localizedUnit(_ unit: Unit) -> String {
    let localization = self.model.localization[self.model.locale]
    ?? UnitsLocalization.defaultLocalizations[self.model.locale]
    ?? UnitsLocalization.defaultLocalization

    switch unit {
    case .days:
      return localization.days.long
    case .hours:
      return localization.hours.long
    case .minutes:
      return localization.minutes.long
    case .seconds:
      return localization.seconds.long
    }
  }

  private func countdownUnitView(value: Int, unit: Unit) -> some View {
    VStack(spacing: 2) {
      self.styledCountdownText(for: value)
      Text(self.localizedUnit(unit))
        .font(self.model.unitFont.font)
        .foregroundStyle(
          self.model.foregroundColor.color(for: self.colorScheme)
        )
    }
  }

  private func colonView() -> some View {
    Text(":")
      .font(self.model.preferredFont.font)
      .foregroundColor(.gray)
  }

  private func styledCountdownText(for value: Int) -> some View {
    Text(String(format: "%02d", value))
      .font(self.model.preferredFont.font)
      .foregroundStyle(
        self.model.foregroundColor.color(for: self.colorScheme)
      )
  }
}
