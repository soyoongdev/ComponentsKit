import ComponentsKit
import SwiftUI
import UIKit

struct CenterModalPreview: View {
  enum ModalBody {
    case shortText
    case longText
  }
  enum ModalFooter {
    case button
    case buttonAndCheckbox
  }

  @State private var model = CenterModalVM()
  @State private var hasHeader: Bool = true
  @State private var modalBody: ModalBody = .shortText
  @State private var modalFooter: ModalFooter? = .buttonAndCheckbox

  private let shortText = "Lorem ipsum dolor sit amet, consectetur adipiscing elit."
  private let longText = """
Lorem ipsum odor amet, consectetuer adipiscing elit. Vitae vehicula pellentesque lectus orci fames. Cras suscipit dui tortor penatibus turpis ultrices. Laoreet montes adipiscing ante dapibus facilisis. Lorem per fames nec duis quis eleifend imperdiet. Tincidunt id interdum adipiscing eros dis quis platea varius. Potenti eleifend eu molestie laoreet varius sapien. Adipiscing nascetur platea penatibus curabitur tempus nibh laoreet porttitor. Augue et curabitur cras sed semper inceptos nunc montes mollis.

Lectus arcu pellentesque inceptos tempor fringilla nascetur. Erat curae convallis integer mi, quis facilisi tortor. Phasellus aliquam molestie vehicula odio in dis maximus diam elit. Rutrum gravida amet euismod feugiat fusce. Est egestas velit vulputate senectus sociosqu fringilla eget nibh. Nam pellentesque aenean mi platea tincidunt quam sem purus. Himenaeos suspendisse nec sapien habitasse ultricies maecenas libero odio. Rutrum senectus maximus ultrices, ad nam ultricies placerat.

Enim habitant laoreet inceptos scelerisque senectus, tellus molestie ut. Eros risus nibh morbi eu aenean. Velit ligula magnis aliquet at luctus. Dapibus vestibulum consectetur euismod vitae per ultrices litora quis. Aptent eleifend dapibus urna lacinia felis nisl. Sit amet fusce nullam feugiat posuere. Urna amet curae velit fermentum interdum vestibulum penatibus. Penatibus vivamus sem ultricies pellentesque congue id mattis diam. Aliquam efficitur mi gravida sollicitudin; amet imperdiet. Rutrum mollis risus justo tortor in duis cursus.
"""

  var body: some View {
    VStack {
      PreviewWrapper(title: "UIKit") {
        UKComponentPreview(model: .init { $0.title = "Show Modal" }) {
          UKButton {
            UIApplication.shared.topViewController?.present(
              UKCenterModalController(
                model: self.model,
                header: self.hasHeader
                ? { _ in
                  let title = UILabel()
                  title.text = "Header"
                  title.font = .systemFont(ofSize: 20, weight: .bold)
                  return title
                }
                : nil,
                body: { _ in
                  let subtitle = UILabel()
                  switch self.modalBody {
                  case .shortText:
                    subtitle.text = self.shortText
                  case .longText:
                    subtitle.text = self.longText
                  }
                  subtitle.numberOfLines = 0
                  subtitle.font = .systemFont(ofSize: 18, weight: .regular)
                  return subtitle
                },
                footer: self.modalFooter.map { footer in
                  return { dismiss in
                    let stackView = UIStackView()
                    stackView.axis = .vertical
                    stackView.spacing = 16

                    let button = UKButton(
                      model: .init {
                        $0.title = "Close"
                      },
                      action: { dismiss(true) }
                    )
                    stackView.addArrangedSubview(button)

                    switch footer {
                    case .button:
                      button.model.isEnabled = true
                    case .buttonAndCheckbox:
                      button.model.isEnabled = false
                      let checkbox = UKCheckbox(
                        initialValue: false,
                        model: .init {
                          $0.title = "Agree and continue"
                        },
                        onValueChange: { isSelected in
                          button.model.isEnabled = isSelected
                        }
                      )
                      stackView.insertArrangedSubview(checkbox, at: 0)
                    }

                    return stackView
                  }
                }
              ),
              animated: true
            )
          }
        }
      }
      Form {
        Section("Content") {
          Picker("Header", selection: self.$hasHeader) {
            Text("Text").tag(true)
            Text("None").tag(false)
          }
          Picker("Body", selection: self.$modalBody) {
            Text("Short Text").tag(ModalBody.shortText)
            Text("Long Text").tag(ModalBody.longText)
          }
          Picker("Footer", selection: .init(
            get: {
              return self.modalFooter
            },
            set: { newValue in
              if newValue == nil {
                self.model.closesOnOverlayTap = true
              }
              self.modalFooter = newValue
            }
          )) {
            Text("Button").tag(ModalFooter.button)
            Text("Button and Checkbox").tag(ModalFooter.buttonAndCheckbox)
            Text("None").tag(Optional<ModalFooter>.none)
          }
        }

        Section("Properties") {
          Picker("Background Color", selection: self.$model.backgroundColor) {
            Text("Primary").tag(Palette.Base.background)
            Text("Secondary").tag(Palette.Base.secondaryBackground)
            Text("Custom").tag(UniversalColor.success.withOpacity(0.5))
          }
          Toggle("Closes On Overlay Tap", isOn: self.$model.closesOnOverlayTap)
            .disabled(self.modalFooter == nil)
          Picker("Outer Paddings", selection: self.$model.outerPaddings) {
            Text("12px").tag(Paddings(padding: 12))
            Text("16px").tag(Paddings(padding: 16))
            Text("20px").tag(Paddings(padding: 20))
          }
          Picker("Content Spacing", selection: self.$model.contentSpacing) {
            Text("8px").tag(CGFloat(8))
            Text("12px").tag(CGFloat(12))
            Text("16px").tag(CGFloat(16))
          }
          Picker("Content Paddings", selection: self.$model.contentPaddings) {
            Text("12px").tag(Paddings(padding: 12))
            Text("16px").tag(Paddings(padding: 16))
            Text("20px").tag(Paddings(padding: 20))
          }
          Picker("Corner Radius", selection: self.$model.cornerRadius) {
            Text("None").tag(ModalRadius.none)
            Text("Small").tag(ModalRadius.small)
            Text("Medium").tag(ModalRadius.medium)
            Text("Large").tag(ModalRadius.large)
            Text("Custom 30px").tag(ModalRadius.custom(30))
          }
          Picker("Overlay Style", selection: self.$model.overlayStyle) {
            Text("Blurred").tag(ModalOverlayStyle.blurred)
            Text("Dimmed").tag(ModalOverlayStyle.dimmed)
            Text("Opaque").tag(ModalOverlayStyle.opaque)
          }
          Picker("Size", selection: self.$model.size) {
            Text("Small").tag(ModalSize.small)
            Text("Medium").tag(ModalSize.medium)
            Text("Large").tag(ModalSize.large)
            Text("Full").tag(ModalSize.full)
          }
        }
      }
    }
  }
}

#Preview {
  ButtonPreview()
}
