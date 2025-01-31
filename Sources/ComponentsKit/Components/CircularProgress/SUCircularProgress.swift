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
        Path { path in
          path.addArc(
            center: self.model.center,
            radius: self.model.radius,
            startAngle: .radians(0),
            endAngle: .radians(2 * .pi),
            clockwise: false
          )
        }
        .stroke(
          self.model.color.main.color.opacity(0.3),
          lineWidth: self.model.circularLineWidth
        )
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

        if let label = self.model.label {
          Text(label)
            .font(self.model.titleFont.font)
            .foregroundColor(self.model.color.main.color)
        }
      }

    case .striped:
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
        .trim(from: self.model.backgroundArcStart(for: normalized), to: self.model.backgroundArcEnd(for: normalized))
        .stroke(
          .clear,
          style: StrokeStyle(
            lineWidth: self.model.circularLineWidth,
            lineCap: .round
          )
        )
        .overlay {
          StripesShapeCircularProgress(model: self.model)
            .foregroundColor(self.model.color.main.color)
            .mask {
              Path { maskPath in
                maskPath.addArc(
                  center: self.model.center,
                  radius: self.model.radius,
                  startAngle: .radians(0),
                  endAngle: .radians(2 * .pi),
                  clockwise: false
                )
              }
              .trim(from: self.model.backgroundArcStart(for: normalized), to: self.model.backgroundArcEnd(for: normalized))
              .stroke(
                style: StrokeStyle(
                  lineWidth: self.model.circularLineWidth,
                  lineCap: .round
                )
              )
            }
        }
        .rotationEffect(.degrees(-90))
        .frame(width: self.model.preferredSize.width,
               height: self.model.preferredSize.height)

        Path { path in
          path.addArc(
            center: self.model.center,
            radius: self.model.radius,
            startAngle: .radians(0),
            endAngle: .radians(2 * .pi),
            clockwise: false
          )
        }
        .trim(from: self.model.progressArcStart(for: normalized), to: self.model.progressArcEnd(for: normalized))
        .stroke(
          self.model.color.main.color,
          style: StrokeStyle(
            lineWidth: self.model.circularLineWidth,
            lineCap: .round
          )
        )
        .rotationEffect(.degrees(-90))
        .frame(width: self.model.preferredSize.width,
               height: self.model.preferredSize.height)

        if let label = self.model.label {
          Text(label)
            .font(self.model.titleFont.font)
            .foregroundColor(self.model.color.main.color)
        }
      }
    }
  }
}

struct StripesShapeCircularProgress: Shape, @unchecked Sendable {
  var model: CircularProgressVM

  func path(in rect: CGRect) -> Path {
    self.model.stripesPath(in: rect)
  }
}
