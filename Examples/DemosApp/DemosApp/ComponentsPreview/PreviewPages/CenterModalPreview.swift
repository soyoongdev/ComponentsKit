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
        UKButton(model: .init { $0.title = "Show Modal" }) {
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
        .preview
      }
      PreviewWrapper(title: "SwiftUI") {
        SUButton(model: .init { $0.title = "Show Modal" }) {
          self.isModalPresented = true
        }
        .centerModal(
          isPresented: self.$isModalPresented,
          model: self.model,
          header: {
            ModalPreviewHelpers.suHeader(hasHeader: self.hasHeader)
          },
          body: {
            ModalPreviewHelpers.suBody(body: self.contentBody)
          },
          footer: {
            ModalPreviewHelpers.suFooter(
              isPresented: self.$isModalPresented,
              isCheckboxSelected: self.$isCheckboxSelected,
              footer: self.contentFooter
            )
          }
        )
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
