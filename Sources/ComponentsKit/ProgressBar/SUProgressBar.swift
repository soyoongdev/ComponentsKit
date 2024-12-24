import SwiftUI

public struct SUProgressBar: View {
  var model: ProgressBarVM
  @Binding private var currentValue: CGFloat

  public init(currentValue: Binding<CGFloat>, model: ProgressBarVM) {
    self._currentValue = currentValue
    self.model = model
  }

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
        }
        .animation(.default, value: fraction)

      case .filled:
        ZStack(alignment: .leading) {
          RoundedRectangle(cornerRadius: model.computedCornerRadius)
            .foregroundColor(model.color.main.color)
            .frame(width: geometry.size.width, height: model.barHeight)
          
          RoundedRectangle(cornerRadius: model.computedCornerRadius)
            .foregroundColor((model.color.contrast ?? .foreground).color)
            .frame(width: (geometry.size.width - 6) * fraction, height: model.barHeight - 6)
            .padding(3)
        }
        .animation(.default, value: fraction)

      case .striped:
        ZStack(alignment: .leading) {
          RoundedRectangle(cornerRadius: model.computedCornerRadius)
            .foregroundColor(model.color.main.color)
            .frame(width: geometry.size.width, height: model.barHeight)

            RoundedRectangle(cornerRadius: model.computedCornerRadius)
              .foregroundColor(model.color.contrast.color)
              .frame(width: (geometry.size.width - 6) * fraction, height: model.barHeight - 6)
              .padding(3)

            StripesShape(model: model)
              .foregroundColor(model.color.main.color)
              .scaleEffect(1.3)
              .cornerRadius(model.computedCornerRadius)
              .frame(width: (geometry.size.width - 6) * fraction, height: model.barHeight - 6)
              .clipped()
              .padding(3)
        }
        .animation(.default, value: fraction)
      }
    }
    .frame(height: model.barHeight)
  }

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
