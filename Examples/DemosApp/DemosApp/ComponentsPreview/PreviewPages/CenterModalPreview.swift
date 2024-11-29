import ComponentsKit
import SwiftUI
import UIKit

struct CenterModalPreview: View {
  @State var model = CenterModalVM()

  @State var isModalPresented: Bool = false
  @State var isCheckboxSelected: Bool = false

  @State var hasHeader = true
  @State var contentBody: ModalPreviewHelpers.ContentBody = .shortText
  @State var contentFooter: ModalPreviewHelpers.ContentFooter? = .buttonAndCheckbox

  var body: some View {
    VStack {
      PreviewWrapper(title: "UIKit") {
        UKComponentPreview(model: .init { $0.title = "Show Modal" }) {
          UKButton {
            UIApplication.shared.topViewController?.present(
              UKCenterModalController(
                model: self.model,
                header: ModalPreviewHelpers.ukHeader(hasHeader: self.hasHeader),
                body: ModalPreviewHelpers.ukBody(body: self.contentBody),
                footer: ModalPreviewHelpers.ukFooter(footer: self.contentFooter)
              ),
              animated: true
            )
          }
        }
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
            EmptyView()
          }
        )
      }
    }
  }
}

#Preview {
  CenterModalPreview()
}
