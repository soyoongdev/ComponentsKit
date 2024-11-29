import ComponentsKit
import SwiftUI
import UIKit

struct ModalPreviewHelpers {
  // MARK: - Enums

  enum ContentBody {
    case shortText
    case longText
  }
  enum ContentFooter {
    case button
    case buttonAndCheckbox
  }

  // MARK: - Preview Sections

  struct ContentSection<VM: ModalVM>: View {
    @Binding var model: VM
    @Binding var hasHeader: Bool
    @Binding var contentBody: ContentBody
    @Binding var contentFooter: ContentFooter?

    var body: some View {
      Section("Content") {
        Picker("Header", selection: self.$hasHeader) {
          Text("Text").tag(true)
          Text("None").tag(false)
        }
        Picker("Body", selection: self.$contentBody) {
          Text("Short Text").tag(ContentBody.shortText)
          Text("Long Text").tag(ContentBody.longText)
        }
        Picker("Footer", selection: .init(
          get: {
            return self.contentFooter
          },
          set: { newValue in
            if newValue == nil {
              self.model.closesOnOverlayTap = true
            }
            self.contentFooter = newValue
          }
        )) {
          Text("Button").tag(ContentFooter.button)
          Text("Button and Checkbox").tag(ContentFooter.buttonAndCheckbox)
          Text("None").tag(Optional<ContentFooter>.none)
        }
      }
    }
  }

  struct PropertiesSection<VM: ModalVM, Pickers: View>: View {
    @Binding var model: VM
    @Binding var footer: ContentFooter?
    @ViewBuilder var additionalPickers: () -> Pickers

    var body: some View {
      Section("Properties") {
        Picker("Background Color", selection: self.$model.backgroundColor) {
          Text("Primary").tag(Palette.Base.background)
          Text("Secondary").tag(Palette.Base.secondaryBackground)
          Text("Custom").tag(UniversalColor.success.withOpacity(0.5))
        }
        Toggle("Closes On Overlay Tap", isOn: self.$model.closesOnOverlayTap)
          .disabled(self.footer == nil)
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
        Picker("Transition Duration", selection: self.$model.transitionDuration) {
          Text("0").tag(TimeInterval(0))
          Text("0.2").tag(TimeInterval(0.2))
          Text("0.3").tag(TimeInterval(0.3))
          Text("0.5").tag(TimeInterval(0.5))
        }
        self.additionalPickers()
      }
    }
  }

  // MARK: - Shared UI

  private static let headerTitle = "Header"
  private static let headerFont: UniversalFont = .system(size: 20, weight: .bold)

  private static let bodyShortText = "Lorem ipsum dolor sit amet, consectetur adipiscing elit."
  private static let bodyLongText = """
Lorem ipsum odor amet, consectetuer adipiscing elit. Vitae vehicula pellentesque lectus orci fames. Cras suscipit dui tortor penatibus turpis ultrices. Laoreet montes adipiscing ante dapibus facilisis. Lorem per fames nec duis quis eleifend imperdiet. Tincidunt id interdum adipiscing eros dis quis platea varius. Potenti eleifend eu molestie laoreet varius sapien. Adipiscing nascetur platea penatibus curabitur tempus nibh laoreet porttitor. Augue et curabitur cras sed semper inceptos nunc montes mollis.

Lectus arcu pellentesque inceptos tempor fringilla nascetur. Erat curae convallis integer mi, quis facilisi tortor. Phasellus aliquam molestie vehicula odio in dis maximus diam elit. Rutrum gravida amet euismod feugiat fusce. Est egestas velit vulputate senectus sociosqu fringilla eget nibh. Nam pellentesque aenean mi platea tincidunt quam sem purus. Himenaeos suspendisse nec sapien habitasse ultricies maecenas libero odio. Rutrum senectus maximus ultrices, ad nam ultricies placerat.

Enim habitant laoreet inceptos scelerisque senectus, tellus molestie ut. Eros risus nibh morbi eu aenean. Velit ligula magnis aliquet at luctus. Dapibus vestibulum consectetur euismod vitae per ultrices litora quis. Aptent eleifend dapibus urna lacinia felis nisl. Sit amet fusce nullam feugiat posuere. Urna amet curae velit fermentum interdum vestibulum penatibus. Penatibus vivamus sem ultricies pellentesque congue id mattis diam. Aliquam efficitur mi gravida sollicitudin; amet imperdiet. Rutrum mollis risus justo tortor in duis cursus.
"""
  private static let bodyFont: UniversalFont = .system(size: 18, weight: .regular)

  private static let footerButtonVM = ButtonVM {
    $0.title = "Close"
    $0.isFullWidth = true
  }
  private static let footerCheckboxVM = CheckboxVM {
    $0.title = "Agree and continue"
  }

  // MARK: - UIKit

  static func ukHeader(hasHeader: Bool) -> UKModalController.Content? {
    guard hasHeader else {
      return nil
    }

    return { _ in
      let title = UILabel()
      title.text = self.headerTitle
      title.font = self.headerFont.uiFont
      return title
    }
  }

  static func ukBody(body: ContentBody) -> UKModalController.Content {
    return { _ in
      let subtitle = UILabel()
      switch body {
      case .shortText:
        subtitle.text = self.bodyShortText
      case .longText:
        subtitle.text = self.bodyLongText
      }
      subtitle.numberOfLines = 0
      subtitle.font = self.bodyFont.uiFont
      return subtitle
    }
  }

  static func ukFooter(footer: ContentFooter?) -> UKModalController.Content? {
    return footer.map { footer in
      return { dismiss in
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16

        let button = UKButton(
          model: self.footerButtonVM,
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
            model: self.footerCheckboxVM,
            onValueChange: { isSelected in
              button.model.isEnabled = isSelected
            }
          )
          stackView.insertArrangedSubview(checkbox, at: 0)
        }

        return stackView
      }
    }
  }
}
