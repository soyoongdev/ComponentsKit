import SwiftUI

/// A SwiftUI component that displays a progress bar.
public struct SUProgressBar: View {
  // MARK: - Properties

  /// A model that defines the appearance properties.
  public var model: ProgressBarVM

  @Binding private var currentValue: CGFloat

  // MARK: - Initializer

  /// Initializer.
  /// - Parameters:
  ///   - currentValue: A binding to the current value.
  ///   - model: A model that defines the appearance properties.
  public init(
    currentValue: Binding<CGFloat>,
    model: ProgressBarVM
  ) {
    self._currentValue = currentValue
    self.model = model
  }

  // MARK: - Body

  public var body: some View {
    GeometryReader { geometry in
      switch model.style {
      case .light:
        HStack(spacing: 4) {
          Rectangle()
            .foregroundColor(model.barColor.color)
            .frame(width: geometry.size.width * fraction, height: model.barHeight)
            .cornerRadius(model.computedCornerRadius)
          Rectangle()
            .foregroundColor(model.backgroundColor.color)
            .frame(width: geometry.size.width * (1 - fraction), height: model.barHeight)
            .cornerRadius(model.computedCornerRadius)
            .scaleEffect(fraction == 0 ? 0 : 1, anchor: .leading)
        }
        .animation(.spring, value: fraction)

      case .filled:
        ZStack(alignment: .leading) {
          RoundedRectangle(cornerRadius: model.computedCornerRadius)
            .foregroundColor(model.color.main.color)
            .frame(width: geometry.size.width, height: model.barHeight)

          RoundedRectangle(cornerRadius: model.computedCornerRadius)
            .foregroundColor((model.color.contrast ?? .foreground).color)
            .frame(width: (geometry.size.width - 6) * fraction, height: model.barHeight - 6)
            .padding(3)
            .scaleEffect(fraction == 0 ? 0 : 1, anchor: .leading)
        }
        .animation(.spring, value: fraction)

      case .striped:
        ZStack(alignment: .leading) {
          RoundedRectangle(cornerRadius: model.computedCornerRadius)
            .foregroundColor(model.color.main.color)
            .frame(width: geometry.size.width, height: model.barHeight)

          RoundedRectangle(cornerRadius: model.computedCornerRadius)
            .foregroundColor(model.color.contrast.color)
            .frame(width: (geometry.size.width - 6) * fraction, height: model.barHeight - 6)
            .padding(3)
            .scaleEffect(fraction == 0 ? 0 : 1, anchor: .leading)

          StripesShape(model: model)
            .foregroundColor(model.color.main.color)
            .scaleEffect(1.2)
            .cornerRadius(model.computedCornerRadius)
            .clipped()
        }
        .animation(.spring, value: fraction)
      }
    }
    .frame(height: model.barHeight)
  }

  // MARK: - Properties

  private var fraction: CGFloat {
    let range = model.maxValue - model.minValue
    guard range != 0 else { return 0 }
    let fraction = (currentValue - model.minValue) / range
    return max(0, min(1, fraction))
  }
}


struct StripesShape: Shape {
  var model: ProgressBarVM

  func path(in rect: CGRect) -> Path {
    model.stripesPath(in: rect)
  }
}
