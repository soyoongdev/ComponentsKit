import SwiftKit
import SwiftUI
import UIKit

private class Container: UIView {
  let loading = UKLoading(
    model: LoadingVM {
      $0.color = .danger
      $0.size = .medium
    }
  )
  let button = UKButton(
    model: ButtonVM {
      $0.title = "Toggle animation"
    }
  )

  override init(frame: CGRect) {
    super.init(frame: frame)

    self.setup()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func setup() {
    self.backgroundColor = Palette.Base.background.uiColor

    self.addSubview(self.loading)
    self.addSubview(self.button)

    self.button.action = { [weak self] in
      guard let self else { return }
      self.loading.model.update {
        $0.isAnimating.toggle()
//        $0.speed -= 0.2
      }
    }

    self.loading.size(60)
    self.loading.centerVertically()
    self.loading.centerHorizontally()

    self.button.centerHorizontally()
    self.button.below(of: self.loading, padding: 40)
  }
}

struct CheckboxesView: View {
  @State var isSelected = false
  @State var model = CheckboxVM {
    $0.title = "Checkbox"
    $0.color = .danger
  }

  var body: some View {
//    UIViewRepresenting {
//      Container()
//    }
    SUCheckbox(
      isSelected: self.$isSelected,
      model: self.model
    )
  }
}

#Preview {
  CheckboxesView()
}
