import SwiftUI

public struct SUCountdown: View {
  @StateObject private var manager: CountdownManager

  public var model: CountdownVM

  public init(model: CountdownVM = CountdownVM()) {
    self.model = model
    _manager = StateObject(wrappedValue: CountdownManager())
  }

  @Environment(\.colorScheme) private var colorScheme

  public var body: some View {
    VStack {
      if model.unitsPosition == .trailing {
        Text(formattedTimeWithUnits())
          .font(model.preferredFont.font)
          .foregroundStyle(
            model.foregroundColor.color(for: colorScheme)
          )
      } else if model.unitsPosition == .bottom {
        HStack(spacing: 10) {
          styledCountdownUnitView(value: manager.days, unit: "day")
          if model.style != .light { colonView().padding(.bottom, 16) }
          styledCountdownUnitView(value: manager.hours, unit: "hour")
          if model.style != .light { colonView().padding(.bottom, 16) }
          styledCountdownUnitView(value: manager.minutes, unit: "minute")
          if model.style != .light { colonView().padding(.bottom, 16) }
          styledCountdownUnitView(value: manager.seconds, unit: "second")
        }
      } else if model.unitsPosition == .none {
        HStack(spacing: 4) {
          Text(String(format: "%02d", manager.days))
            .font(model.preferredFont.font)
            .foregroundStyle(
              model.foregroundColor.color(for: colorScheme)
            )
          if model.style != .light { colonView() }
          Text(String(format: "%02d", manager.hours))
            .font(model.preferredFont.font)
            .foregroundStyle(
              model.foregroundColor.color(for: colorScheme)
            )
          if model.style != .light { colonView() }
          Text(String(format: "%02d", manager.minutes))
            .font(model.preferredFont.font)
            .foregroundStyle(
              model.foregroundColor.color(for: colorScheme)
            )
          if model.style != .light { colonView() }
          Text(String(format: "%02d", manager.seconds))
            .font(model.preferredFont.font)
            .foregroundStyle(
              model.foregroundColor.color(for: colorScheme)
            )
        }
      }
    }
    .onAppear {
      manager.start(until: model.until)
    }
    .onChange(of: model.until) { newDate in
      manager.stop()
      manager.start(until: newDate)
    }
    .onDisappear {
      manager.stop()
    }
  }

  private func formattedTimeWithUnits() -> String {
    return String(format: "%02d d : %02d h : %02d m : %02d s", manager.days, manager.hours, manager.minutes, manager.seconds)
  }

  private func styledCountdownUnitView(value: Int, unit: String) -> some View {
    Group {
      if model.style == .light && model.unitsPosition == .bottom {
        countdownUnitView(value: value, unit: unit)
          .padding(8)
          .background(
            RoundedRectangle(cornerRadius: 8)
              .fill(model.backgroundColor.color(for: colorScheme))
          )
      } else {
        countdownUnitView(value: value, unit: unit)
      }
    }
  }

  private func countdownUnitView(value: Int, unit: String) -> some View {
    VStack(spacing: 2) {
      Text(String(format: "%02d", value))
        .font(model.preferredFont.font)
        .foregroundStyle(
          model.foregroundColor.color(for: colorScheme)
        )
      Text(unit)
        .font(.system(size: 8))
        .foregroundStyle(
          model.foregroundColor.color(for: colorScheme)
        )
    }
  }

  private func colonView() -> some View {
    Text(":")
      .font(model.preferredFont.font)
      .foregroundColor(.gray)
  }
}
