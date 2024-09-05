import SwiftUI

public struct SUInputField: View {
  // MARK: Properties

  private var model: InputFieldVM
  private var onValueChange: (String) -> Void

  @Binding public var text: String
  @FocusState.Binding public var isSelected: Bool

  @Environment(\.colorScheme) private var colorScheme

  private var titlePosition: InputFieldTitlePosition {
    if self.model.placeholder.isNilOrEmpty,
       self.text.isEmpty,
       !self.isSelected {
      return .center
    } else {
      return .top
    }
  }

  // MARK: Initialization

  public init(
    text: Binding<String>,
    isSelected: FocusState<Bool>.Binding,
    model: InputFieldVM = .init(),
    onValueChange: @escaping (String) -> Void = { _ in }
  ) {
    self._text = text
    self._isSelected = isSelected
    self.model = model
    self.onValueChange = onValueChange
  }

  // MARK: Body

  public var body: some View {
    ZStack {
      HStack {
        Text(self.model.title)
          .font(self.model.titleFont(for: self.titlePosition).font)
          .foregroundStyle(self.model.titleColor(for: self.titlePosition).color(for: self.colorScheme))
          .padding(.bottom, self.titlePosition == .top ? 34 : 0)
          .animation(.linear(duration: 0.1), value: self.titlePosition)
        Spacer()
      }
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
        .font(self.model.font.font)
        .foregroundStyle(self.model.foregroundColor.color(for: self.colorScheme))
        .focused(self.$isSelected)
        .disabled(!self.model.isEnabled)
        .keyboardType(self.model.keyboardType)
        .submitLabel(self.model.submitType.submitLabel)
        .frame(height: 30)
        .padding(.bottom, 12)
        .padding(.top, 36)
    }
    .padding(.horizontal, self.model.horizontalPadding)
    .background(self.model.backgroundColor.color(for: self.colorScheme))
    .onTapGesture {
      self.isSelected = true
    }
    .clipShape(
      RoundedRectangle(
        cornerRadius: self.model.cornerRadius.value(for: 78)
      )
    )
    .onChange(of: self.text) { newValue in
      self.onValueChange(newValue)
    }
    .onChange(of: self.isSelected) { _ in
      // NOTE: Workaround to force `isSelected` value update properly
    }
  }
}
