import SwiftUI

public struct SUCheckbox: View {
  struct CheckmarkAnimation {
    var partOne = 0.0
    var partTwo = 0.0
  }

  private var model: CheckboxVM
  private var onValueChange: (Bool) -> Void

  @Binding public var isSelected: Bool
  @State private var checkmarkAnimation: CheckmarkAnimation
  @State private var borderOpacity: CGFloat
  @Environment(\.colorScheme) private var colorScheme

  public init(
    isSelected: Binding<Bool>,
    model: CheckboxVM,
    onValueChange: @escaping (Bool) -> Void = { _ in }
  ) {
    self._isSelected = isSelected
    self.model = model
    self.onValueChange = onValueChange
    self.checkmarkAnimation = isSelected.wrappedValue
    ? .init(partOne: 1.0, partTwo: 1.0)
    : .init()
    self.borderOpacity = isSelected.wrappedValue ? 0.0 : 1.0
  }

  public var body: some View {
    HStack {
      ZStack {
        self.model.backgroundColor.color(for: self.colorScheme)
          .clipShape(
            RoundedRectangle(cornerRadius: self.model.cornerRadius.value(for: 24))
          )
          .scaleEffect(self.isSelected ? 1.0 : 0.0)
          .opacity(self.isSelected ? 1.0 : 0.0)
          .animation(.easeInOut(duration: 0.3), value: self.isSelected)

        Group {
          Path { path in
            path.move(to: .init(x: 6, y: 11))
            path.addLine(to: .init(x: 11, y: 17))
          }
          .trim(from: 0, to: self.checkmarkAnimation.partOne)
          .stroke(style: StrokeStyle(
            lineWidth: 2.0,
            lineCap: .round,
            lineJoin: .round
          ))

          Path { path in
            path.move(to: .init(x: 11, y: 17))
            path.addLine(to: .init(x: 18, y: 7))
          }
          .trim(from: 0, to: self.checkmarkAnimation.partTwo)
          .stroke(style: StrokeStyle(
            lineWidth: 2.0,
            lineCap: .round,
            lineJoin: .round
          ))
        }
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
          .opacity(self.model.isEnabled ? 1.0 : 0.5)
      }
    }
    .onTapGesture {
      self.isSelected.toggle()
    }
    .disabled(!self.model.isEnabled)
    .onChange(of: self.isSelected) { isSelected in
      self.onValueChange(isSelected)

      if isSelected {
        withAnimation(.linear(duration: 0.1).delay(0.3)) {
          self.checkmarkAnimation.partOne = 1.0
        }
        withAnimation(.linear(duration: 0.1).delay(0.4)) {
          self.checkmarkAnimation.partTwo = 1.0
        }
        withAnimation(.linear(duration: 0.1).delay(0.2)) {
          self.borderOpacity = 0.0
        }
      } else {
        self.checkmarkAnimation = .init()
        withAnimation(.linear(duration: 0.1)) {
          self.borderOpacity = 1.0
        }
      }
    }
  }
}
