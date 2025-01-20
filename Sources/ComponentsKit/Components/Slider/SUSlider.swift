import SwiftUI

/// A SwiftUI component that displays a slider.
public struct SUSlider: View {
  // MARK: - Properties

  /// A model that defines the appearance properties.
  public var model: SliderVM

  /// A binding to control the current value.
  @Binding public var currentValue: CGFloat

  private var progress: CGFloat {
    self.model.progress(for: self.currentValue)
  }

  // MARK: - Initializer

  /// Initializer.
  /// - Parameters:
  ///   - currentValue: A binding to the current value.
  ///   - model: A model that defines the appearance properties.
  public init(
    currentValue: Binding<CGFloat>,
    model: SliderVM = .init()
  ) {
    self._currentValue = currentValue
    self.model = model
  }

  // MARK: - Body

  public var body: some View {
    GeometryReader { geometry in
      let handleWidth = self.model.handleSize.width
      let handleHeight = self.model.handleSize.height

      let sliderHeight = self.model.trackHeight

      let containerHeight = max(sliderHeight, handleHeight)

      // Calculate the width available for the track, excluding handle width + spacing
      let sliderWidth = max(0, geometry.size.width - handleWidth - (2 * self.model.trackSpacing))

      // The track width based on the progress
      let leftWidth = progress * sliderWidth
      let rightWidth = sliderWidth - leftWidth

      ZStack(alignment: .center) {
        HStack(spacing: self.model.trackSpacing) {
          // Progress segment
          RoundedRectangle(cornerRadius: self.model.cornerRadius(for: sliderHeight))
            .foregroundStyle(self.model.color.main.color)
            .frame(width: max(leftWidth, 0))

          // Handle
          RoundedRectangle(cornerRadius: self.model.cornerRadius(for: handleHeight))
            .foregroundStyle(self.model.color.main.color)
            .frame(width: handleWidth, height: handleHeight)
            .overlay(
              Group {
                if self.model.size == .large {
                  RoundedRectangle(cornerRadius: self.model.cornerRadius(for: self.model.handleOverlaySide))
                    .foregroundStyle(self.model.color.contrast.color)
                    .frame(width: self.model.handleOverlaySide, height: self.model.handleOverlaySide)
                }
              }
            )
            .gesture(
              DragGesture(minimumDistance: 0)
                .onChanged { value in
                  let newOffset = leftWidth + value.translation.width
                  let clampedOffset = min(max(newOffset, 0), sliderWidth)

                  self.currentValue = self.model.steppedValue(for: clampedOffset, trackWidth: sliderWidth)
                }
            )

          // Remaining segment
          switch self.model.style {
          case .light:
            RoundedRectangle(cornerRadius: self.model.cornerRadius(for: sliderHeight))
              .foregroundStyle(self.model.backgroundColor.color)
              .frame(width: max(rightWidth, 0))

          case .striped:
            ZStack {
              RoundedRectangle(cornerRadius: self.model.cornerRadius(for: sliderHeight))
                .foregroundStyle(self.model.color.contrast.color)

              StripesShapeSlider(model: self.model)
                .foregroundStyle(self.model.color.main.color)
                .cornerRadius(self.model.cornerRadius(for: sliderHeight))
            }
            .frame(width: max(rightWidth, 0))
          }
        }
        .frame(height: sliderHeight)
      }
      .frame(width: geometry.size.width, height: containerHeight)
      // Center the slider vertically within the available space
      .frame(maxHeight: .infinity, alignment: .center)
    }
    .onAppear {
      self.model.validateMinMaxValues()
    }
  }
}

// MARK: - Helpers

struct StripesShapeSlider: Shape {
  var model: SliderVM

  func path(in rect: CGRect) -> Path {
    self.model.stripesPath(in: rect)
  }
}
