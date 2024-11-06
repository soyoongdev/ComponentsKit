import SwiftUI

public struct SUTextInput<FocusValue: Hashable>: View {
  // MARK: Properties

  /// A model that defines the appearance properties.
  public var model: InputTextVM

  /// A Binding value to control the inputted text.
  @Binding public var text: String?

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

  // MARK: Initialization

  /// Initializer.
  /// - Parameters:
  ///   - text: A Binding value to control the inputted text.
  ///   - globalFocus: The shared state controlling focus across multiple fields.
  ///   - localFocus: The unique value for this field to match against the global focus state to determine focus.
  ///   - model: A model that defines the appearance properties.
  public init(
    text: Binding<String?>,
    globalFocus: FocusState<FocusValue>.Binding,
    localFocus: FocusValue,
    model: InputTextVM = .init()
  ) {
    self._text = text
    self._globalFocus = globalFocus
    self.localFocus = localFocus
    self.model = model
  }

  // MARK: Body

  public var body: some View {
    VStack {
      // TODO: Block the ScrollView
      ScrollView {
        ZStack(alignment: .topLeading) {
          // Background color with rounded corners
          self.model.backgroundColor.color(for: self.colorScheme)
            .clipShape(RoundedRectangle(cornerRadius: self.model.cornerRadius.value()))

          // Placeholder text
          Text(self.model.placeholder ?? "")
            .foregroundStyle(self.model.placeholderColor.color(for: self.colorScheme))
            .opacity(self.model.placeholder == nil ? 1 : 0)

          // Text editor for user input
          TextEditor(text: Binding($text, replacingNilWith: ""))
          // TODO: Move minRows and maxRows parameters into the model
            .frame(minHeight: 60, maxHeight: 150, alignment: .leading)
            .foregroundStyle(
              self.model.foregroundColor.color(for: self.colorScheme)
            )
            .padding(self.model.horizontalPadding)
            .colorMultiply(self.model.backgroundColor.color(for: self.colorScheme))
        }
        // Configure appearance and behavior
        .tint(self.model.tintColor.color(for: self.colorScheme))
        .font(self.model.preferredFont.font)
        .foregroundStyle(self.model.placeholderColor.color(for: self.colorScheme))
        .focused(self.$globalFocus, equals: self.localFocus)
        .disabled(!self.model.isEnabled)
        .keyboardType(self.model.keyboardType)
        .submitLabel(self.model.submitType.submitLabel)
        .autocorrectionDisabled(!self.model.isAutocorrectionEnabled)
        .textInputAutocapitalization(self.model.autocapitalization.textInputAutocapitalization)
      }
    }
    .padding(.horizontal, self.model.horizontalPadding)
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
    text: Binding<String?>,
    isFocused: FocusState<Bool>.Binding,
    model: InputTextVM = .init()
  ) {
    self._text = text
    self._globalFocus = isFocused
    self.localFocus = true
    self.model = model
  }
}

/// Extension to Binding to handle optional values by replacing nil with a proxy value.
public extension Binding where Value: Equatable {
  /// Initializes a Binding by replacing nil values with a proxy value.
  /// - Parameters:
  ///   - source: The original optional Binding.
  ///   - nilProxy: The value to use in place of nil.
  init(_ source: Binding<Value?>, replacingNilWith nilProxy: Value) {
    self.init(
      get: { source.wrappedValue ?? nilProxy },
      set: { newValue in
        if newValue == nilProxy {
          source.wrappedValue = nil
        } else {
          source.wrappedValue = newValue
        }
      }
    )
  }
}

/// Preview provider for SUTextInput.
struct SUTextInput_Previews: PreviewProvider {
  static var previews: some View {
    SUTextInputPreviewWrapper()
      .previewLayout(.sizeThatFits)
  }
}

/// Wrapper view for previewing SUTextInput.
struct SUTextInputPreviewWrapper: View {
  @State private var text: String? = "Sample Text"
  @FocusState private var isFocused: Bool

  var body: some View {
    SUTextInput(
      text: $text,
      isFocused: $isFocused
    )
  }
}
