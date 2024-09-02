import SwiftUI

public struct SULoading: View {
  private let model: LoadingVM
  private let strokeAnimationDuration = 1.5

  @State private var rotation: CGFloat = 0.0
  @State private var trimEnd: CGFloat = 0.0
  @State private var trimStart: CGFloat = 0.0

  public init(model: LoadingVM = .init()) {
    self.model = model
  }

  public var body: some View {
    Circle()
      .trim(
        from: self.trimStart,
        to: self.trimEnd
      )
      .stroke(
        SwiftUI.Color(self.model.color.main.uiColor),
        style: StrokeStyle(
          lineWidth: self.model.loadingLineWidth,
          lineCap: .round,
          lineJoin: .round,
          miterLimit: 0
        )
      )
      .frame(
        width: self.model.preferredSize.width,
        height: self.model.preferredSize.height
      )
      .rotationEffect(.radians(self.rotation))
      .animation(
        .linear(duration: 2.0)
        .repeatForever(autoreverses: false),
        value: self.rotation
      )
      .onAppear {
        self.rotation = 2 * .pi
        self.animateTrimEnd()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
          self.animateTrimStart()
        }
      }
  }

  private func animateTrimStart() {
    self.trimStart = 0.0

    withAnimation(
      .easeInOut(duration: strokeAnimationDuration * 0.475)
    ) {
      self.trimStart = 0.1
    }
    withAnimation(
      .easeInOut(duration: strokeAnimationDuration * 0.475)
      .delay(strokeAnimationDuration * 0.475)
    ) {
      self.trimStart = 0.8
    }
    withAnimation(
      .easeInOut(duration: strokeAnimationDuration * 0.1)
      .delay(strokeAnimationDuration * 0.95)
    ) {
      self.trimStart = 1.0
    }

    DispatchQueue.main.asyncAfter(deadline: .now() + strokeAnimationDuration) {
      self.animateTrimStart()
    }
  }

  private func animateTrimEnd() {
    self.trimEnd = 0.0

    withAnimation(
      .easeInOut(duration: strokeAnimationDuration * 0.475)
    ) {
      self.trimEnd = 0.8
    }
    withAnimation(
      .easeInOut(duration: strokeAnimationDuration * 0.475)
      .delay(strokeAnimationDuration * 0.475)
    ) {
      self.trimEnd = 0.95
    }
    withAnimation(
      .easeInOut(duration: strokeAnimationDuration * 0.1)
      .delay(strokeAnimationDuration * 0.95)
    ) {
      self.trimEnd = 1.0
    }

    DispatchQueue.main.asyncAfter(deadline: .now() + strokeAnimationDuration) {
      self.animateTrimEnd()
    }
  }
}
