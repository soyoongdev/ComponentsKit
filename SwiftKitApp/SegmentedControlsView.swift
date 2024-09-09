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

struct SegmentedControlsView: View {
  @State private var selectedIndex = 1
  @State private var model = SegmentedControlVM {
    $0.items = [
      .init {
        $0.title = "iPhone"
//        $0.isEnabled = false
      },
      .init {
        $0.title = "iPad"
      },
      .init {
        $0.title = "Mackbook Pro"
      }
    ]
    $0.color = .success
    $0.size = .medium
//    $0.isFullWidth = true
//    $0.isEnabled = false
  }

  var body: some View {
    SUSegmentedControl(
      selectedIndex: self.$selectedIndex,
      model: self.model
    )
    .padding()

//    UIViewRepresenting {
//      Container()
//    }
  }
}

#Preview {
  SegmentedControlsView()
}
