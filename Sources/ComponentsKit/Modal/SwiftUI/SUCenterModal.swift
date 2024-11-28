import SwiftUI

public struct SUCenterModal<VM: ModalVM, Header: View, Body: View, Footer: View>: View {
  let model: VM

  @Binding var isPresented: Bool
  @State private var isVisible: Bool = false

  @ViewBuilder let contentHeader: () -> Header
  @ViewBuilder let contentBody: () -> Body
  @ViewBuilder let contentFooter: () -> Footer

  @State private var contentOpacity: CGFloat = 0

  public init(
    isPresented: Binding<Bool>,
    model: VM,
    @ViewBuilder header: @escaping () -> Header = { EmptyView() },
    @ViewBuilder body: @escaping () -> Body,
    @ViewBuilder footer: @escaping () -> Footer = { EmptyView() }
  ) {
    self._isPresented = isPresented
    self.model = model
    self.contentHeader = header
    self.contentBody = body
    self.contentFooter = footer
  }

  public var body: some View {
    ZStack(alignment: .center) {
      ModalOverlay(isPresented: self.$isPresented, isVisible: self.$isVisible, model: self.model)

      ModalContent(model: self.model, header: self.contentHeader, body: self.contentBody, footer: self.contentFooter)
    }
    .opacity(self.contentOpacity)
    .animation(.linear(duration: 0.2), value: self.contentOpacity)
    .onAppear {
      self.isVisible = true
    }
    .onChange(of: self.isVisible) { newValue in
      if newValue {
        self.contentOpacity = 1.0
      } else {
        self.contentOpacity = 0.0
      }
    }
  }
}

extension View {
  public func centerModal<VM: ModalVM, Header: View, Body: View, Footer: View>(
    isPresented: Binding<Bool>,
    model: VM,
    @ViewBuilder header: @escaping () -> Header = { EmptyView() },
    @ViewBuilder body: @escaping () -> Body,
    @ViewBuilder footer: @escaping () -> Footer = { EmptyView() }
  ) -> some View {
    return self.fullScreenCover(isPresented: isPresented) {
      SUCenterModal(
        isPresented: isPresented,
        model: model,
        header: header,
        body: body,
        footer: footer
      )
      .transparentPresentationBackground()
    }
    .transaction {
      $0.disablesAnimations = true
    }
  }
}

@available(iOS 17.0, *)
#Preview {
  @Previewable @State var isPresented: Bool = false
  @Previewable @State var isChecked: Bool = false

  let shortText = "Lorem ipsum dolor sit amet, consectetur adipiscing elit."
  let longText = """
Lorem ipsum odor amet, consectetuer adipiscing elit. Vitae vehicula pellentesque lectus orci fames. Cras suscipit dui tortor penatibus turpis ultrices. Laoreet montes adipiscing ante dapibus facilisis. Lorem per fames nec duis quis eleifend imperdiet. Tincidunt id interdum adipiscing eros dis quis platea varius. Potenti eleifend eu molestie laoreet varius sapien. Adipiscing nascetur platea penatibus curabitur tempus nibh laoreet porttitor. Augue et curabitur cras sed semper inceptos nunc montes mollis.

Lectus arcu pellentesque inceptos tempor fringilla nascetur. Erat curae convallis integer mi, quis facilisi tortor. Phasellus aliquam molestie vehicula odio in dis maximus diam elit. Rutrum gravida amet euismod feugiat fusce. Est egestas velit vulputate senectus sociosqu fringilla eget nibh. Nam pellentesque aenean mi platea tincidunt quam sem purus. Himenaeos suspendisse nec sapien habitasse ultricies maecenas libero odio. Rutrum senectus maximus ultrices, ad nam ultricies placerat.

Enim habitant laoreet inceptos scelerisque senectus, tellus molestie ut. Eros risus nibh morbi eu aenean. Velit ligula magnis aliquet at luctus. Dapibus vestibulum consectetur euismod vitae per ultrices litora quis. Aptent eleifend dapibus urna lacinia felis nisl. Sit amet fusce nullam feugiat posuere. Urna amet curae velit fermentum interdum vestibulum penatibus. Penatibus vivamus sem ultricies pellentesque congue id mattis diam. Aliquam efficitur mi gravida sollicitudin; amet imperdiet. Rutrum mollis risus justo tortor in duis cursus.
"""

  ZStack {
    Color.red.ignoresSafeArea()

    SUButton(
      model: .init {
        $0.title = "Open Modal"
      }, action: {
        isPresented = true
      }
    )
    .centerModal(
      isPresented: $isPresented,
      model: CenterModalVM {
        $0.overlayStyle = .dimmed
      },
      header: {
        Text("Header")
          .font(.title2)
      },
      body: {
        Text(shortText)
      },
      footer: {
        VStack(alignment: .leading, spacing: 16) {
          SUCheckbox(isSelected: $isChecked, model: .init {
            $0.title = "Agree and continue"
          })
          SUButton(
            model: .init {
              $0.title = "Close"
              $0.isFullWidth = true
              $0.isEnabled = isChecked
            },
            action: { isPresented = false }
          )
        }
      }
    )
  }
}
