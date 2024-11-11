import SwiftUI

public struct SUTextInput<FocusValue: Hashable>: View {
  // MARK: Properties

  /// A model that defines the appearance properties.
  public var model: TextInputVM

  /// A Binding value to control the inputted text.
  @Binding public var text: String

  /// The shared state controlling focus across multiple fields.
  ///
  /// When this input field's localFocus value matches the globalFocus, the input field becomes focused.
  /// This allows for managing the focus state for many fields in a centralized manner.
  @FocusState.Binding public var globalFocus: FocusValue

  /// The unique value for this field to match against the global focus state to determine whether the field
  /// is focused.
  ///
  /// Determines the local focus value for this particular input field. It is compared with globalFocus to
  /// decide if this input field should be focused. If globalFocus matches the value of localFocus, the
  /// input field gains focus, allowing the user to interact with it.
  ///
  /// - Warning: The localFocus value must be unique to each input field, to ensure that different
  /// fields within the same view can be independently focused based on the shared globalFocus.
  public var localFocus: FocusValue

  @Environment(\.colorScheme) private var colorScheme

  @State var textEditorHeight: CGFloat = 0

  // MARK: Initialization

  /// Initializer.
  /// - Parameters:
  ///   - text: A Binding value to control the inputted text.
  ///   - globalFocus: The shared state controlling focus across multiple fields.
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

  // MARK: Body

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
            .font(self.model.preferredFont.font)
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
              .font(self.model.preferredFont.font)
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
  ///   - isFocused: A binding that controls whether this input field is focused or not.
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
