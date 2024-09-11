import SwiftKit
import SwiftUI
import UIKit

private class Container: UIView {
  enum Items {
    case iPhone
    case iPad
    case mac
    case watch
  }

  let segmentedControl = UKSegmentedControl<Items>(
    selectedId: .iPhone,
    model: .init {
      $0.items = [
        .init(id: .iPhone) {
          $0.title = "iPhone"
        },
        .init(id: .iPad) {
          $0.title = "iPad"
        },
        .init(id: .mac) {
          $0.title = "Mackbook"
        }
      ]
//      $0.isFullWidth = true
      $0.color = .accent
      $0.size = .medium
    }
  )
  let button = UKButton(model: .init {
    $0.title = "toggle width"
  })

  override init(frame: CGRect) {
    super.init(frame: frame)

    self.button.action = {
      self.segmentedControl.model.update {
        $0.isFullWidth.toggle()
      }
    }

    self.addSubview(self.segmentedControl)
    self.addSubview(self.button)

    self.segmentedControl.centerVertically(-50)
    self.segmentedControl.centerHorizontally()

    self.button.below(of: self.segmentedControl, padding: 20)
    self.button.centerHorizontally()
//    self.segmentedControl.horizontally(20)

    self.segmentedControl.onSelectionChange = { id in
      print("Value: \(id)")
    }
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

struct SegmentedControlsView: View {
  enum Items {
    case iPhone
    case iPad
    case mac
  }

  @State private var selectedId = Items.mac
  @State private var model = SegmentedControlVM<Items> {
    $0.items = [
      .init(id: .iPhone) {
        $0.title = "iPhone"
//        $0.isEnabled = false
      },
      .init(id: .iPad) {
        $0.title = "iPad"
      },
      .init(id: .mac) {
        $0.title = "Mackbook Pro"
      }
    ]
    $0.color = .accent
    $0.size = .medium
//    $0.isFullWidth = true
//    $0.isEnabled = false
  }

  var body: some View {
//    SUSegmentedControl(
//      selectedId: self.$selectedId,
//      model: self.model
//    )
//    .padding()

    UIViewRepresenting {
      Container()
    }
  }
}

#Preview {
  SegmentedControlsView()
}
