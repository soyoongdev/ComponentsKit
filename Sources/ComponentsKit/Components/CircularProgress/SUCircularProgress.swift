import SwiftUI

public struct SUCircularProgress: View {
  public var model: CircularProgressVM
  public var currentValue: CGFloat

  public init(
    model: CircularProgressVM = .init(),
    currentValue: CGFloat = 0
  ) {
    self.model = model
    self.currentValue = currentValue
  }

  public var body: some View {
    let normalized = self.model.progress(for: currentValue)

    switch self.model.style {
    case .light:
      ZStack {
        Circle()
          .stroke(
            self.model.color.main.color.opacity(0.3),
            lineWidth: self.model.circularLineWidth
          )
          .frame(width: self.model.preferredSize.width, height: self.model.preferredSize.height)

        Circle()
          .trim(from: 0, to: normalized)
          .stroke(
            self.model.color.main.color,
            style: StrokeStyle(
              lineWidth: self.model.circularLineWidth,
              lineCap: .round
            )
          )
          .rotationEffect(.degrees(-90))
          .frame(width: self.model.preferredSize.width, height: self.model.preferredSize.height)
          .animation(.easeOut, value: normalized)

        if let label = self.model.label {
          Text(label)
            .font(self.model.titleFont.font)
            .foregroundColor(self.model.color.main.color)
        }
      }

    case .striped:
      let gap: CGFloat = 0.07
      let gapHalf = gap / 2

      let progressArcStart: CGFloat = 0
      let progressArcEnd: CGFloat = max(0, min(1, normalized - gapHalf))

      let backgroundArcStart: CGFloat = max(0, min(1, normalized + gapHalf))
      let backgroundArcEnd: CGFloat = 1

      ZStack {
        Path { path in
          path.addArc(
            center: self.model.center,
            radius: self.model.radius,
            startAngle: .radians(0),
            endAngle: .radians(2 * .pi),
            clockwise: false
          )
        }
        .trim(from: backgroundArcStart, to: backgroundArcEnd)
        .stroke(
          self.model.color.main.color.opacity(0.3),
          style: StrokeStyle(
            lineWidth: self.model.circularLineWidth,
            lineCap: .round
          )
        )
        .rotationEffect(.degrees(-90))
        .frame(width: self.model.preferredSize.width, height: self.model.preferredSize.height)

        Path { path in
          path.addArc(
            center: self.model.center,
            radius: self.model.radius,
            startAngle: .radians(0),
            endAngle: .radians(2 * .pi),
            clockwise: false
          )
        }
        .trim(from: progressArcStart, to: progressArcEnd)
        .stroke(
          self.model.color.main.color,
          style: StrokeStyle(
            lineWidth: self.model.circularLineWidth,
            lineCap: .round
          )
        )
        .rotationEffect(.degrees(-90))
        .frame(width: self.model.preferredSize.width, height: self.model.preferredSize.height)
        .animation(.easeOut, value: normalized)

        if let label = self.model.label {
          Text(label)
            .font(self.model.titleFont.font)
            .foregroundColor(self.model.color.main.color)
        }
      }
    }
  }
}
