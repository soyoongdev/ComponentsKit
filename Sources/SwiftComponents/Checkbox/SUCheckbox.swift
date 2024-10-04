import SwiftUI

/// A SwiftUI component that can be selected by a user.
public struct SUCheckbox: View {
  // MARK: Properties

  /// A model that defines the appearance properties.
  private var model: CheckboxVM
  /// A closure that is triggered when the checkbox is selected or unselected.
  private var onValueChange: (Bool) -> Void

  /// A Binding Boolean value indicating whether the checkbox is selected.
  @Binding public var isSelected: Bool

  @State private var checkmarkStroke: CGFloat
  @State private var borderOpacity: CGFloat
  @Environment(\.colorScheme) private var colorScheme

  // MARK: Initialization

  /// Initializer.
  /// - Parameters:
  ///   - isSelected: A Binding Boolean value indicating whether the checkbox is selected.
  ///   - model: A model that defines the appearance properties.
  ///   - onValueChange: A closure that is triggered when the checkbox is selected or unselected.
  public init(
    isSelected: Binding<Bool>,
    model: CheckboxVM = .init(),
    onValueChange: @escaping (Bool) -> Void = { _ in }
  ) {
    self._isSelected = isSelected
    self.model = model
    self.onValueChange = onValueChange
    self.checkmarkStroke = isSelected.wrappedValue ? 1.0 : 0.0
    self.borderOpacity = isSelected.wrappedValue ? 0.0 : 1.0
  }

  // MARK: Body

  public var body: some View {
    HStack(spacing: self.model.spacing) {
      ZStack {
        self.model.backgroundColor.color(for: self.colorScheme)
          .clipShape(
            RoundedRectangle(cornerRadius: self.model.checkboxCornerRadius)
          )
          .scaleEffect(self.isSelected ? 1.0 : 0.1)
          .opacity(self.isSelected ? 1.0 : 0.0)
          .animation(
            .easeInOut(duration: CheckboxAnimationDurations.background),
            value: self.isSelected
          )

        Path { path in
          path.move(to: .init(
            x: self.model.checkboxSide / 4,
            y: 11 / 24 * self.model.checkboxSide
          ))
          path.addLine(to: .init(
            x: 11 / 24 * self.model.checkboxSide,
            y: 17 / 24 * self.model.checkboxSide
          ))
          path.addLine(to: .init(
            x: 3 / 4 * self.model.checkboxSide,
            y: 7 / 24 * self.model.checkboxSide
          ))
        }
        .trim(from: 0, to: self.checkmarkStroke)
        .stroke(style: StrokeStyle(
          lineWidth: self.model.checkmarkLineWidth,
          lineCap: .round,
          lineJoin: .round
        ))
        .foregroundStyle(self.model.foregroundColor.color(for: self.colorScheme))
      }
      .overlay {
        RoundedRectangle(cornerRadius: self.model.checkboxCornerRadius)
          .stroke(
            self.model.borderColor.color(for: self.colorScheme),
            lineWidth: self.model.borderWidth
          )
          .opacity(self.borderOpacity)
      }
      .frame(
        width: self.model.checkboxSide,
        height: self.model.checkboxSide,
        alignment: .center
      )

      if let title = self.model.title {
        Text(title)
          .foregroundStyle(self.model.titleColor.color(for: self.colorScheme))
          .font(self.model.titleFont.font)
      }
    }
    .onTapGesture {
      self.isSelected.toggle()
    }
    .disabled(!self.model.isEnabled)
    .onChange(of: self.isSelected) { isSelected in
      self.onValueChange(isSelected)

      if isSelected {
        withAnimation(
          .linear(duration: CheckboxAnimationDurations.checkmarkStroke)
          .delay(CheckboxAnimationDurations.checkmarkStrokeDelay)
        ) {
          self.checkmarkStroke = 1.0
        }
        withAnimation(
          .linear(duration: CheckboxAnimationDurations.borderOpacity)
          .delay(CheckboxAnimationDurations.selectedBorderDelay)
        ) {
          self.borderOpacity = 0.0
        }
      } else {
        self.checkmarkStroke = 0.0
        withAnimation(
          .linear(duration: CheckboxAnimationDurations.borderOpacity)
        ) {
          self.borderOpacity = 1.0
        }
      }
    }
  }
}
