import SwiftUI

class CountdownManager: ObservableObject {
  // MARK: - Published Properties

  @Published var days: Int = 0
  @Published var hours: Int = 0
  @Published var minutes: Int = 0
  @Published var seconds: Int = 0

  // MARK: - Properties

  private var timer: Timer?
  private var until: Date?

  // MARK: - Methods

  func start(until: Date) {
    self.until = until
    updateTime()
    timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
      self.updateTime()
    }
  }

  func stop() {
    timer?.invalidate()
    timer = nil
  }

  private func updateTime() {
    guard let until = until else { return }

    let now = Date()
    let calendar = Calendar.current
    let components = calendar.dateComponents(
      [.day, .hour, .minute, .second],
      from: now,
      to: until
    )
    days = max(0, components.day ?? 0)
    hours = max(0, components.hour ?? 0)
    minutes = max(0, components.minute ?? 0)
    seconds = max(0, components.second ?? 0)

    if now >= until {
      stop()
    }
  }
}
