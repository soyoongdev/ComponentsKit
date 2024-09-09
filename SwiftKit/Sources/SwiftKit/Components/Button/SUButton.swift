import SwiftUI

public struct SUButton: View {
  private var model: ButtonVM
  private var action: () -> Void

  @State private var viewFrame: CGRect = .zero
  @State private var isPressed: Bool = false

  @Environment(\.colorScheme) private var colorScheme

  public init(
    model: ButtonVM,
    action: @escaping () -> Void = {}
  ) {
    self.model = model
    self.action = action
  }

  public var body: some View {
    Text(self.model.title)
      .font(self.model.preferredFont.font)
      .lineLimit(1)
      .padding(.leading, self.model.horizontalPadding)
      .padding(.trailing, self.model.horizontalPadding)
      .frame(
        maxWidth: self.model.width,
        maxHeight: self.model.height
      )
      .foregroundStyle(self.model.foregroundColor.color(for: self.colorScheme))
      .background(
        GeometryReader { proxy in
          (self.model.backgroundColor?.color(for: self.colorScheme) ?? Color.clear)
            .preference(key: ViewFrameKey.self, value: proxy.frame(in: .local))
        }
      )
      .onPreferenceChange(ViewFrameKey.self) { value in
        self.viewFrame = value
      }
      .gesture(DragGesture(minimumDistance: 0.0)
        .onChanged { _ in
          self.isPressed = true
        }
        .onEnded { value in
          defer { self.isPressed = false }

          if self.viewFrame.contains(value.location) {
            self.action()
          }
        }
      )
      .disabled(!self.model.isEnabled)
      .clipShape(
        RoundedRectangle(
          cornerRadius: self.model.cornerRadius.value()
        )
      )
      .overlay {
        RoundedRectangle(
          cornerRadius: self.model.cornerRadius.value()
        )
        .stroke(
          self.model.borderColor?.color(for: self.colorScheme) ?? .clear,
          lineWidth: self.model.borderWidth
        )
      }
      .scaleEffect(self.isPressed ? 0.98 : 1, anchor: .center)
  }
}

// MARK: - Helpers

private struct ViewFrameKey: PreferenceKey {
  static var defaultValue: CGRect = .zero

  static func reduce(value: inout CGRect, nextValue: () -> CGRect) {
    value = nextValue()
  }
}
