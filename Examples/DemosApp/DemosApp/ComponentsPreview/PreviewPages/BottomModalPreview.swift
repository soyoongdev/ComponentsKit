import ComponentsKit
import SwiftUI
import UIKit

struct BottomModalPreview: View {
  @State var model = BottomModalVM()

  var body: some View {
    ModalPreview(
      model: self.$model,
      presentController: { header, body, footer in
        UIApplication.shared.topViewController?.present(
          UKBottomModalController(
            model: self.model,
            header: header,
            body: body,
            footer: footer
          ),
          animated: true
        )
      },
      additionalPickers: {
        Toggle("Draggable", isOn: self.$model.isDraggable)
        Toggle("Hides On Swap", isOn: self.$model.hidesOnSwap)
      }
    )
  }
}

#Preview {
  BottomModalPreview()
}
