import SwiftUI

/// A SwiftUI component that displays a circular progress.
public struct SUCircularProgress: View {
  // MARK: - Properties

  /// A model that defines the appearance properties.
  public var model: CircularProgressVM

  /// The current progress value.
  public var currentValue: CGFloat

  // MARK: - Initializer

  /// Initializer.
  /// - Parameters:
  ///   - currentValue: Current progress.
  ///   - model: A model that defines the appearance properties.
  public init(
    currentValue: CGFloat = 0,
    model: CircularProgressVM = .init()
  ) {
    self.currentValue = currentValue
    self.model = model
  }

  // MARK: - Body

  public var body: some View {
    let normalized = self.model.progress(for: currentValue)

    switch self.model.style {
    case .light:
      ZStack {
        // Background part
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
        .frame(
          width: self.model.preferredSize.width,
          height: self.model.preferredSize.height
        )

        // Foreground part
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
        .frame(
          width: self.model.preferredSize.width,
          height: self.model.preferredSize.height
        )

        // Optional label
        if let label = self.model.label {
          Text(label)
            .font(self.model.titleFont.font)
            .foregroundColor(self.model.color.main.color)
        }
      }

    case .striped:
      ZStack {
        // Striped background part
        Path { path in
          path.addArc(
            center: self.model.center,
            radius: self.model.radius,
            startAngle: .radians(0),
            endAngle: .radians(2 * .pi),
            clockwise: false
          )
        }
        .trim(
          from: self.model.backgroundArcStart(for: normalized),
          to: self.model.backgroundArcEnd(for: normalized)
        )
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
              .trim(
                from: self.model.backgroundArcStart(for: normalized),
                to: self.model.backgroundArcEnd(for: normalized)
              )
              .stroke(
                style: StrokeStyle(
                  lineWidth: self.model.circularLineWidth,
                  lineCap: .round
                )
              )
            }
        }
        .rotationEffect(.degrees(-90))
        .frame(
          width: self.model.preferredSize.width,
          height: self.model.preferredSize.height
        )

        // Foreground part
        Path { path in
          path.addArc(
            center: self.model.center,
            radius: self.model.radius,
            startAngle: .radians(0),
            endAngle: .radians(2 * .pi),
            clockwise: false
          )
        }
        .trim(
          from: self.model.progressArcStart(for: normalized),
          to: self.model.progressArcEnd(for: normalized)
        )
        .stroke(
          self.model.color.main.color,
          style: StrokeStyle(
            lineWidth: self.model.circularLineWidth,
            lineCap: .round
          )
        )
        .rotationEffect(.degrees(-90))
        .frame(
          width: self.model.preferredSize.width,
          height: self.model.preferredSize.height
        )

        // Optional label
        if let label = self.model.label {
          Text(label)
            .font(self.model.titleFont.font)
            .foregroundColor(self.model.color.main.color)
        }
      }
    }
  }
}

// MARK: - Helpers

struct StripesShapeCircularProgress: Shape, @unchecked Sendable {
  var model: CircularProgressVM

  func path(in rect: CGRect) -> Path {
    self.model.stripesPath(in: rect)
  }
}
