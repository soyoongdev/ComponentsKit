import SwiftUI

/// A SwiftUI component that displays a multi-line text input form.
public struct SUTextInput<FocusValue: Hashable>: View {
  // MARK: - Properties

  /// A model that defines the appearance properties.
  public var model: TextInputVM

  /// A Binding value to control the inputted text.
  @Binding public var text: String

  /// The shared focus state used to manage focus across multiple text inputs and input fields.
  ///
  /// When the `localFocus` value matches `globalFocus`, this text input becomes focused.
  /// This enables centralized focus management for multiple text inputs and input fields within a single view.
  @FocusState.Binding public var globalFocus: FocusValue

  /// The unique value for this text input to match against the global focus state to determine whether the text input is focused.
  ///
  /// Determines the local focus value for this particular text input. It is compared with globalFocus to
  /// decide if this text input should be focused. If globalFocus matches the value of localFocus, the
  /// text input gains focus, allowing the user to interact with it.
  ///
  /// - Warning: The localFocus value must be unique to each text input and input field, to ensure that different
  /// text inputs and input fields within the same view can be independently focused based on the shared globalFocus.
  public var localFocus: FocusValue

  @Environment(\.colorScheme) private var colorScheme
  @State private var textEditorHeight: CGFloat = 0

  // MARK: - Initialization

  /// Initializer.
  /// - Parameters:
  ///   - text: A Binding value to control the inputted text.
  ///   - globalFocus: The shared state controlling focus across multiple text inputs and input fields.
  ///   - localFocus: The unique value for this field to match against the global focus state to determine focus.
  ///   - model: A model that defines the appearance properties.
  public init(
    text: Binding<String>,
    globalFocus: FocusState<FocusValue>.Binding,
    localFocus: FocusValue,
    model: TextInputVM = .init()
  ) {
    self._text = text
    self._globalFocus = globalFocus
    self.localFocus = localFocus
    self.model = model
  }

  // MARK: - Body

  public var body: some View {
    GeometryReader { scrollViewGeometry in
      ScrollView {
        ZStack(alignment: .topLeading) {
          TextEditor(text: self.$text)
            .contentMargins(self.model.contentPadding)
            .transparentScrollBackground()
            .frame(
              minHeight: self.model.minTextInputHeight,
              maxHeight: min(self.model.maxTextInputHeight, scrollViewGeometry.size.height)
            )
            .fixedSize(horizontal: false, vertical: true)
            .lineSpacing(0)
            .font(self.model.font?.font ?? .body)
            .foregroundStyle(self.model.foregroundColor.color(for: self.colorScheme))
            .tint(self.model.tintColor.color(for: self.colorScheme))
            .focused(self.$globalFocus, equals: self.localFocus)
            .disabled(!self.model.isEnabled)
            .keyboardType(self.model.keyboardType)
            .submitLabel(self.model.submitType.submitLabel)
            .autocorrectionDisabled(!self.model.isAutocorrectionEnabled)
            .textInputAutocapitalization(self.model.autocapitalization.textInputAutocapitalization)

          if let placeholder = self.model.placeholder,
             self.text.isEmpty {
            Text(placeholder)
              .font(self.model.font?.font ?? .body)
              .foregroundStyle(
                self.model.placeholderColor.color(for: self.colorScheme)
              )
              .padding(self.model.contentPadding)
          }
        }
        .background(
          GeometryReader { textEditorGeometry in
            Color.clear
              .onAppear {
                self.textEditorHeight = textEditorGeometry.size.height
              }
              .onChange(of: self.text) { _ in
                self.textEditorHeight = textEditorGeometry.size.height
              }
              .onChange(of: self.model.maxTextInputHeight) { _ in
                self.textEditorHeight = textEditorGeometry.size.height
              }
              .onChange(of: self.model.minTextInputHeight) { _ in
                self.textEditorHeight = textEditorGeometry.size.height
              }
          }
        )
      }
      .frame(height: self.textEditorHeight)
      .background(self.model.backgroundColor.color(for: self.colorScheme))
      .onTapGesture {
        self.globalFocus = self.localFocus
      }
      .clipShape(
        RoundedRectangle(
          cornerRadius: self.model.adaptedCornerRadius.value()
        )
      )
      .position(
        x: scrollViewGeometry.frame(in: .local).midX,
        y: scrollViewGeometry.frame(in: .local).midY
      )
    }
  }
}

// MARK: - Helpers

extension View {
  fileprivate func transparentScrollBackground() -> some View {
    if #available(iOS 16.0, *) {
      return self.scrollContentBackground(.hidden)
    } else {
      return self.onAppear {
        UITextView.appearance().backgroundColor = .clear
      }
    }
  }

  fileprivate func contentMargins(_ value: CGFloat) -> some View {
    // By default, `TextEditor` has a horizontal content margin. We cannot know the exact value
    // since the implementation details are hidden, but approximately it is equal to 5.
    let defaultHorizontalContentMargin: CGFloat = 5
    return self.onAppear {
      UITextView.appearance().textContainerInset = .init(
        top: value,
        left: value - defaultHorizontalContentMargin,
        bottom: value,
        right: value - defaultHorizontalContentMargin
      )
      UITextView.appearance().textContainer.lineFragmentPadding = 0
    }
  }
}

// MARK: - Boolean Focus Value

extension SUTextInput where FocusValue == Bool {
  /// Initializer.
  /// - Parameters:
  ///   - text: A Binding value to control the inputted text.
  ///   - isFocused: A binding that controls whether this text input is focused or not.
  ///   - model: A model that defines the appearance properties.
  public init(
    text: Binding<String>,
    isFocused: FocusState<Bool>.Binding,
    model: TextInputVM = .init()
  ) {
    self._text = text
    self._globalFocus = isFocused
    self.localFocus = true
    self.model = model
  }
}
