import SwiftUI

/// A SwiftUI component that displays the progress of a task or operation in a circular form.
public struct SUCircularProgress: View {
  // MARK: - Properties

  /// A model that defines the appearance properties.
  public var model: CircularProgressVM

  /// The current progress value.
  public var currentValue: CGFloat

  private var progress: CGFloat {
    self.model.progress(for: self.currentValue)
  }

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
    ZStack {
      // Background part
      Path { path in
        path.addArc(
          center: self.model.center,
          radius: self.model.radius,
          startAngle: .radians(self.model.startAngle),
          endAngle: .radians(self.model.endAngle),
          clockwise: false
        )
      }
      .stroke(
        self.model.color.background.color,
        style: StrokeStyle(
          lineWidth: self.model.circularLineWidth,
          lineCap: self.model.lineCap.cgLineCap
        )
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
          startAngle: .radians(self.model.startAngle),
          endAngle: .radians(self.model.endAngle),
          clockwise: false
        )
      }
      .trim(from: 0, to: self.progress)
      .stroke(
        self.model.color.main.color,
        style: StrokeStyle(
          lineWidth: self.model.circularLineWidth,
          lineCap: self.model.lineCap.cgLineCap
        )
      )
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
    .animation(
      Animation.linear(duration: self.model.animationDuration),
      value: self.progress
    )
  }
}
