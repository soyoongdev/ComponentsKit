import ComponentsKit
import SwiftUI
import UIKit

struct BottomModalPreview: View {
  @State var model = BottomModalVM()

  @State var isModalPresented: Bool = false
  @State var isCheckboxSelected: Bool = false

  @State var hasHeader = true
  @State var contentBody: ModalPreviewHelpers.ContentBody = .shortText
  @State var contentFooter: ModalPreviewHelpers.ContentFooter? = .buttonAndCheckbox

  var body: some View {
    VStack {
      PreviewWrapper(title: "UIKit") {
        UKButton(model: .init { $0.title = "Show Modal" }) {
          UIApplication.shared.topViewController?.present(
            UKBottomModalController(
              model: self.model,
              header: ModalPreviewHelpers.ukHeader(hasHeader: self.hasHeader),
              body: ModalPreviewHelpers.ukBody(body: self.contentBody),
              footer: ModalPreviewHelpers.ukFooter(footer: self.contentFooter)
            ),
            animated: true
          )
        }
        .preview
      }

      Form {
        ModalPreviewHelpers.ContentSection(
          model: self.$model,
          hasHeader: self.$hasHeader,
          contentBody: self.$contentBody,
          contentFooter: self.$contentFooter
        )
        ModalPreviewHelpers.PropertiesSection(
          model: self.$model,
          footer: self.$contentFooter,
          additionalPickers: {
            Toggle("Draggable", isOn: self.$model.isDraggable)
            Toggle("Hides On Swap", isOn: self.$model.hidesOnSwap)
          }
        )
      }
    }
  }
}

#Preview {
  BottomModalPreview()
}
