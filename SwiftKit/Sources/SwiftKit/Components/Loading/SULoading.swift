import SwiftUI
import Combine

public struct SULoading: View {
  private var model: LoadingVM

  @State private var rotationAnimationTimer: AnyCancellable?
  @State private var rotationAngle: CGFloat = 0.0

  public init(model: LoadingVM = .init()) {
    self.model = model
  }

  public var body: some View {
    Path { path in
      path.addArc(
        center: self.model.center,
        radius: self.model.radius,
        startAngle: .degrees(0),
        endAngle: .degrees(360),
        clockwise: true
      )
    }
      .trim(from: 0, to: 0.75)
      .stroke(
        SwiftUI.Color(self.model.color.main.uiColor),
        style: StrokeStyle(
          lineWidth: self.model.loadingLineWidth,
          lineCap: .round,
          lineJoin: .round,
          miterLimit: 0
        )
      )
      .rotationEffect(.degrees(self.rotationAngle))
      .frame(
        width: self.model.preferredSize.width,
        height: self.model.preferredSize.height,
        alignment: .center
      )
      .rotationEffect(.radians(2 * .pi * 0.15))
      .onAppear {
        self.startRotationAnimation()
      }
      .onChange(of: self.model.isAnimating) { isAnimating in
        if isAnimating {
          self.startRotationAnimation()
        } else {
          self.removeRotationAnimation()
        }
      }
      .onChange(of: self.model.speed) { _ in
        self.removeRotationAnimation()
        self.startRotationAnimation()
      }
  }

  private func startRotationAnimation() {
    self.rotationAnimationTimer = Timer
      .publish(every: 0.1, on: .main, in: .common)
      .autoconnect()
      .receive(on: DispatchQueue.main)
      .sink { _ in
        withAnimation {
          self.rotationAngle += 40 * max(0, self.model.speed)
        }
      }
  }

  private func removeRotationAnimation() {
    self.rotationAnimationTimer?.cancel()
    self.rotationAnimationTimer = nil
  }
}
