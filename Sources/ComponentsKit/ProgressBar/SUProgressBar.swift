import SwiftUI

/// A SwiftUI component that displays a progress bar.
public struct SUProgressBar: View {
  // MARK: - Properties

  /// A model that defines the appearance properties.
  public var model: ProgressBarVM

  @Binding private var currentValue: CGFloat

  private var progress: CGFloat {
    let range = self.model.maxValue - self.model.minValue

    guard range > 0 else {
      return 0
    }

    let progress = (self.currentValue - self.model.minValue) / range
    return max(0, min(1, progress))
  }

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
            .frame(width: geometry.size.width * self.progress, height: self.model.barHeight)
          RoundedRectangle(cornerRadius: self.model.computedCornerRadius)
            .foregroundStyle(self.model.backgroundColor.color)
            .frame(width: geometry.size.width * (1 - self.progress), height: self.model.barHeight)
        }
        .animation(.spring, value: self.progress)

      case .filled:
        ZStack(alignment: .leading) {
          RoundedRectangle(cornerRadius: self.model.computedCornerRadius)
            .foregroundStyle(self.model.color.main.color)
            .frame(width: geometry.size.width, height: self.model.barHeight)

          RoundedRectangle(cornerRadius: self.model.innerCornerRadius)
            .foregroundStyle(self.model.color.contrast.color)
            .frame(width: (geometry.size.width - self.model.innerBarPadding * 2) * self.progress, height: self.model.barHeight - self.model.innerBarPadding * 2)
            .padding(.vertical, self.model.innerBarPadding)
            .padding(.horizontal, self.model.innerBarPadding)
        }
        .animation(.spring, value: self.progress)

      case .striped:
        ZStack(alignment: .leading) {
          RoundedRectangle(cornerRadius: self.model.computedCornerRadius)
            .foregroundStyle(self.model.color.main.color)
            .frame(width: geometry.size.width, height: self.model.barHeight)

          RoundedRectangle(cornerRadius: self.model.innerCornerRadius)
            .foregroundStyle(self.model.color.contrast.color)
            .frame(width: (geometry.size.width - self.model.innerBarPadding * 2) * self.progress, height: self.model.barHeight - self.model.innerBarPadding * 2)
            .padding(.vertical, self.model.innerBarPadding)
            .padding(.horizontal, self.model.innerBarPadding)

          StripesShape(model: self.model)
            .foregroundStyle(self.model.color.main.color)
            .cornerRadius(self.model.computedCornerRadius)
            .clipped()
        }
        .animation(.spring, value: self.progress)
      }
    }
    .frame(height: self.model.barHeight)
    .onAppear {
      self.model.validateMinMaxValues()
    }
  }
}

// MARK: - Properties

struct StripesShape: Shape {
  var model: ProgressBarVM

  func path(in rect: CGRect) -> Path {
    self.model.stripesPath(in: rect)
  }
}
