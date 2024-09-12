import SwiftUI

public struct SUInputField<FocusValue: Hashable>: View {
  // MARK: Properties

  private var model: InputFieldVM
  private var onValueChange: (String) -> Void

  @Binding public var text: String
  @FocusState.Binding public var globalFocus: FocusValue
  private var localFocus: FocusValue

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

  public init(
    text: Binding<String>,
    globalFocus: FocusState<FocusValue>.Binding,
    localFocus: FocusValue,
    model: InputFieldVM = .init(),
    onValueChange: @escaping (String) -> Void = { _ in }
  ) {
    self._text = text
    self._globalFocus = globalFocus
    self.localFocus = localFocus
    self.model = model
    self.onValueChange = onValueChange
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
    .onChange(of: self.text) { newValue in
      self.onValueChange(newValue)
    }
    .onChange(of: self.globalFocus) { _ in
      // NOTE: Workaround to force `globalFocus` value update properly
      // Without this workaround the title position changes to `center`
      // when the text is cleared
    }
  }
}

// MARK: - Boolean Focus Value

extension SUInputField where FocusValue == Bool {
  public init(
    text: Binding<String>,
    isSelected: FocusState<Bool>.Binding,
    model: InputFieldVM = .init(),
    onValueChange: @escaping (String) -> Void = { _ in }
  ) {
    self._text = text
    self._globalFocus = isSelected
    self.localFocus = true
    self.model = model
    self.onValueChange = onValueChange
  }
}
