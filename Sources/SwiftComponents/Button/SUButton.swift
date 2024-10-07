import SwiftUI

/// A SwiftUI component that performs an action when it is tapped by a user.
public struct SUButton: View {
  // MARK: Properties

  /// A model that defines the appearance properties.
  public var model: ButtonVM
  /// A closure that is triggered when the button is tapped.
  public var action: () -> Void

  /// A Boolean value indicating whether the button is pressed.
  @State public var isPressed: Bool = false

  @State private var viewFrame: CGRect = .zero
  @Environment(\.colorScheme) private var colorScheme

  // MARK: Initialization

  /// Initializer.
  /// - Parameters:
  ///   - model: A model that defines the appearance properties.
  ///   - action: A closure that is triggered when the button is tapped.
  public init(
    model: ButtonVM,
    action: @escaping () -> Void = {}
  ) {
    self.model = model
    self.action = action
  }

  // MARK: Body

  public var body: some View {
    Button("", action: {})
    Text(self.model.title)
      .font(self.model.preferredFont.font)
      .lineLimit(1)
      .padding(.leading, self.model.horizontalPadding)
      .padding(.trailing, self.model.horizontalPadding)
      .frame(maxWidth: self.model.width)
      .frame(height: self.model.height)
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
      .scaleEffect(
        self.isPressed ? self.model.animationScale.value : 1,
        anchor: .center
      )
  }
}

// MARK: - Helpers

private struct ViewFrameKey: PreferenceKey {
  static var defaultValue: CGRect = .zero

  static func reduce(value: inout CGRect, nextValue: () -> CGRect) {
    value = nextValue()
  }
}
