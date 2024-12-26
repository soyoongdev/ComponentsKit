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
    model: ProgressBarVM = .init()
  ) {
    self._currentValue = currentValue
    self.model = model
  }

  // MARK: - Body

  public var body: some View {
    GeometryReader { geometry in
      switch self.model.style {
      case .light:
        HStack(spacing: 4) {
          RoundedRectangle(cornerRadius: self.model.computedCornerRadius)
            .foregroundStyle(self.model.barColor.color)
            .frame(width: geometry.size.width * self.fraction, height: self.model.barHeight)
          Rectangle()
            .foregroundStyle(self.model.backgroundColor.color)
            .frame(width: geometry.size.width * (1 - self.fraction), height: self.model.barHeight)
            .cornerRadius(self.model.computedCornerRadius)
        }
        .animation(.spring, value: self.fraction)

      case .filled:
        ZStack(alignment: .leading) {
          RoundedRectangle(cornerRadius: self.model.computedCornerRadius)
            .foregroundStyle(self.model.color.main.color)
            .frame(width: geometry.size.width, height: self.model.barHeight)

          RoundedRectangle(cornerRadius: self.model.computedCornerRadius)
            .foregroundStyle((self.model.color.contrast ?? .foreground).color)
            .frame(width: (geometry.size.width - 6) * self.fraction, height: self.model.barHeight - 6)
            .padding(.vertical, self.model.contentPaddings.top)
            .padding(.horizontal, self.model.contentPaddings.trailing)
        }
        .animation(.spring, value: self.fraction)

      case .striped:
        ZStack(alignment: .leading) {
          RoundedRectangle(cornerRadius: self.model.computedCornerRadius)
            .foregroundStyle(self.model.color.main.color)
            .frame(width: geometry.size.width, height: self.model.barHeight)

          RoundedRectangle(cornerRadius: self.model.computedCornerRadius)
            .foregroundStyle(self.model.color.contrast.color)
            .frame(width: (geometry.size.width - 6) * self.fraction, height: self.model.barHeight - 6)
            .padding(.vertical, self.model.contentPaddings.top)
            .padding(.horizontal, self.model.contentPaddings.trailing)

          StripesShape(model: self.model)
            .foregroundStyle(self.model.color.main.color)
            .scaleEffect(1.2)
            .cornerRadius(self.model.computedCornerRadius)
            .clipped()
        }
        .animation(.spring, value: self.fraction)
      }
    }
    .frame(height: self.model.barHeight)
    .onAppear {
      self.model.validateMinMaxValues()
    }
  }

  // MARK: - Properties

  private var fraction: CGFloat {
    let range = self.model.maxValue - self.model.minValue
    guard range != 0 else { return 0 }
    let fraction = (self.currentValue - self.model.minValue) / range
    return max(0, min(1, fraction))
  }
}

struct StripesShape: Shape {
  var model: ProgressBarVM

  func path(in rect: CGRect) -> Path {
    self.model.stripesPath(in: rect)
  }
}
