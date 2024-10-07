import SwiftUI

/// A SwiftUI component that displays a field to input a text.
public struct SUInputField<FocusValue: Hashable>: View {
  // MARK: Properties

  /// A model that defines the appearance properties.
  public var model: InputFieldVM

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

  private var titlePosition: InputFieldTitlePosition {
    if self.model.placeholder.isNilOrEmpty,
       self.text.isEmpty,
       self.globalFocus != self.localFocus {
      return .center
    } else {
      return .top
    }
  }

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
    model: InputFieldVM = .init()
  ) {
    self._text = text
    self._globalFocus = globalFocus
    self.localFocus = localFocus
    self.model = model
  }

  // MARK: Body

  public var body: some View {
    ZStack(alignment: Alignment(
      horizontal: .leading,
      vertical: self.titlePosition == .top ? .top : .center
    )) {
      Text(self.model.attributedTitle(for: self.titlePosition))
        .font(self.model.titleFont(for: self.titlePosition).font)
        .foregroundStyle(
          self.model
            .titleColor(for: self.titlePosition)
            .color(for: self.colorScheme)
        )
        .padding(.top, self.titlePosition == .top ? self.model.verticalPadding : 0)
        .animation(.linear(duration: 0.1), value: self.titlePosition)

      Group {
        if self.model.isSecureInput {
          SecureField(text: self.$text, label: {
            Text(self.model.placeholder ?? "")
              .foregroundStyle(self.model.placeholderColor.color(for: self.colorScheme))
          })
        } else {
          TextField(text: self.$text, label: {
            Text(self.model.placeholder ?? "")
              .foregroundStyle(self.model.placeholderColor.color(for: self.colorScheme))
          })
        }
      }
      .tint(self.model.tintColor.color(for: self.colorScheme))
      .font(self.model.preferredFont.font)
      .foregroundStyle(self.model.foregroundColor.color(for: self.colorScheme))
      .focused(self.$globalFocus, equals: self.localFocus)
      .disabled(!self.model.isEnabled)
      .keyboardType(self.model.keyboardType)
      .submitLabel(self.model.submitType.submitLabel)
      .autocorrectionDisabled(!self.model.isAutocorrectionEnabled)
      .textInputAutocapitalization(self.model.autocapitalization.textInputAutocapitalization)
      .frame(height: self.model.inputFieldHeight)
      .padding(.bottom, self.model.verticalPadding)
      .padding(.top, self.model.inputFieldTopPadding)
    }
    .padding(.horizontal, self.model.horizontalPadding)
    .background(self.model.backgroundColor.color(for: self.colorScheme))
    .onTapGesture {
      self.globalFocus = self.localFocus
    }
    .clipShape(
      RoundedRectangle(
        cornerRadius: self.model.cornerRadius.value()
      )
    )
    .onChange(of: self.globalFocus) { _ in
      // NOTE: Workaround to force `globalFocus` value update properly
      // Without this workaround the title position changes to `center`
      // when the text is cleared
    }
  }
}

// MARK: - Boolean Focus Value

extension SUInputField where FocusValue == Bool {
  /// Initializer.
  /// - Parameters:
  ///   - text: A Binding value to control the inputted text.
  ///   - isFocused: A binding that controls whether this input field is focused or not.
  ///   - model: A model that defines the appearance properties.
  public init(
    text: Binding<String>,
    isFocused: FocusState<Bool>.Binding,
    model: InputFieldVM = .init()
  ) {
    self._text = text
    self._globalFocus = isFocused
    self.localFocus = true
    self.model = model
  }
}
