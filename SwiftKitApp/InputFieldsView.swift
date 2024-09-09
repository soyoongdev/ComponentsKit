import SwiftKit
import SwiftUI
import UIKit

private class Container: UIView {
  let inputField = UKInputField(
    initialText: "",
    model: .init {
      $0.title = "Email"
//      $0.placeholder = "Input your email"
      $0.keyboardType = .emailAddress
      $0.submitType = .next
      $0.isRequired = true
    }
  )
  let clearTextButton = UKButton(
    model: .init {
      $0.title = "Clear text"
    }
  )

  override init(frame: CGRect) {
    super.init(frame: frame)

    self.addSubview(self.inputField)
    self.addSubview(self.clearTextButton)

    self.inputField.centerVertically(-50)
    self.inputField.horizontally(20)

    self.clearTextButton.below(of: self.inputField, padding: 20)
    self.clearTextButton.horizontally(20)

    self.clearTextButton.action = {
      self.inputField.text = ""
    }

    self.inputField.onValueChange = { text in
      print("Text: \(text)")
    }

    self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.handleTap)))
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  @objc private func handleTap() {
    self.inputField.isSelected = false
  }
}

struct InputFieldsView: View {
  @State private var inputFieldVM = InputFieldVM {
    $0.title = "Email"
//    $0.placeholder = "Input your email"
//    $0.color = .danger
    $0.keyboardType = .emailAddress
    $0.submitType = .next
  }
  @State private var text = "Hello"
  @FocusState private var isSelected: Bool

  var body: some View {
    VStack(spacing: 20) {
      SUInputField(
        text: self.$text,
        isSelected: self.$isSelected,
        model: self.inputFieldVM,
        onValueChange: {
          print("Text: \($0)")
        }
      )
      HStack {
        SUButton(model: .init {
          $0.title = "Hide keyboard"
          $0.size = .medium
          $0.isFullWidth = true
        }) {
          self.isSelected = false
        }
        SUButton(model: .init {
          $0.title = "Clear text"
          $0.size = .medium
          $0.isFullWidth = true
        }) {
          self.text = ""
        }
        SUButton(model: .init {
          $0.title = "Is secure"
          $0.size = .medium
          $0.isFullWidth = true
        }) {
          self.inputFieldVM.isSecureInput.toggle()
        }
      }
    }
    .padding(.horizontal)

//    UIViewRepresenting {
//      Container()
//    }
  }
}

#Preview {
  InputFieldsView()
}
