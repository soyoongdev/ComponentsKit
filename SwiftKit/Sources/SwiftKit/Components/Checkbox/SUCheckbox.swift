import SwiftUI

public struct SUCheckbox: View {
  private var model: CheckboxVM
  private var onValueChange: (Bool) -> Void

  @Binding public var isSelected: Bool
  @State private var checkmarkStroke: CGFloat
  @State private var borderOpacity: CGFloat
  @Environment(\.colorScheme) private var colorScheme

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

  public var body: some View {
    HStack {
      ZStack {
        self.model.backgroundColor.color(for: self.colorScheme)
          .clipShape(
            RoundedRectangle(cornerRadius: self.model.cornerRadius.value(for: 24))
          )
          .scaleEffect(self.isSelected ? 1.0 : 0.1)
          .opacity(self.isSelected ? 1.0 : 0.0)
          .animation(
            .easeInOut(duration: CheckboxAnimationDurations.background),
            value: self.isSelected
          )

        Path { path in
          path.move(to: .init(x: 6, y: 11))
          path.addLine(to: .init(x: 11, y: 17))
          path.addLine(to: .init(x: 18, y: 7))
        }
        .trim(from: 0, to: self.checkmarkStroke)
        .stroke(style: StrokeStyle(
          lineWidth: 2.0,
          lineCap: .round,
          lineJoin: .round
        ))
        .foregroundStyle(self.model.foregroundColor.color(for: self.colorScheme))
      }
      .overlay {
        RoundedRectangle(cornerRadius: self.model.cornerRadius.value(for: 24))
          .stroke(
            self.model.borderColor.color(for: self.colorScheme),
            lineWidth: self.model.borderWidth
          )
          .opacity(self.borderOpacity)
      }
      .frame(width: 24, height: 24, alignment: .center)

      if let title = self.model.title {
        Text(title)
          .foregroundStyle(self.model.titleColor.color(for: self.colorScheme))
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
