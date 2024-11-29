import SwiftUI

struct SUBottomModal<Header: View, Body: View, Footer: View>: View {
  let model: BottomModalVM

  @Binding var isVisible: Bool

  @ViewBuilder let contentHeader: () -> Header
  @ViewBuilder let contentBody: () -> Body
  @ViewBuilder let contentFooter: () -> Footer

  @State private var contentHeight: CGFloat = 0
  @State private var contentOffsetY: CGFloat = 0
  @State private var overlayOpacity: CGFloat = 0

  init(
    isVisible: Binding<Bool>,
    model: BottomModalVM,
    @ViewBuilder header: @escaping () -> Header,
    @ViewBuilder body: @escaping () -> Body,
    @ViewBuilder footer: @escaping () -> Footer
  ) {
    self._isVisible = isVisible
    self.model = model
    self.contentHeader = header
    self.contentBody = body
    self.contentFooter = footer
  }

  var body: some View {
    ZStack(alignment: .bottom) {
      ModalOverlay(isVisible: self.$isVisible, model: self.model)
        .opacity(self.overlayOpacity)

      ModalContent(model: self.model, header: self.contentHeader, body: self.contentBody, footer: self.contentFooter)
        .observeSize {
          self.contentHeight = $0.height
        }
        .offset(y: self.contentOffsetY)
        .gesture(
          DragGesture()
            .onChanged { gesture in
              let translation = gesture.translation.height
              self.contentOffsetY = ModalAnimation.bottomModalOffset(translation, model: self.model)
            }
            .onEnded { gesture in
              if ModalAnimation.shouldHideBottomModal(
                offset: self.contentOffsetY,
                height: self.contentHeight,
                velocity: gesture.velocity.height,
                model: self.model
              ) {
                self.isVisible = false
              } else {
                withAnimation(.linear(duration: 0.2)) {
                  self.contentOffsetY = 0
                }
              }
            }
        )
    }
    .onAppear {
      self.contentOffsetY = self.screenHeight

      withAnimation(.linear(duration: self.model.transition.value)) {
        self.overlayOpacity = 1.0
        self.contentOffsetY = 0
      }
    }
    .onChange(of: self.isVisible) { newValue in
      withAnimation(.linear(duration: self.model.transition.value)) {
        if newValue {
          self.overlayOpacity = 1.0
          self.contentOffsetY = 0
        } else {
          self.overlayOpacity = 0.0
          self.contentOffsetY = self.screenHeight
        }
      }
    }
  }

  // MARK: - Helpers

  private var screenHeight: CGFloat {
    return UIScreen.main.bounds.height
  }
}

// MARK: - Presentation Helpers

extension View {
  public func bottomModal<Header: View, Body: View, Footer: View>(
    isPresented: Binding<Bool>,
    model: BottomModalVM = .init(),
    onDismiss: (() -> Void)? = nil,
    @ViewBuilder header: @escaping () -> Header = { EmptyView() },
    @ViewBuilder body: @escaping () -> Body,
    @ViewBuilder footer: @escaping () -> Footer = { EmptyView() }
  ) -> some View {
    return self.modal(
      isVisible: isPresented,
      transitionDuration: model.transition.value,
      onDismiss: onDismiss,
      content: {
        SUBottomModal(
          isVisible: isPresented,
          model: model,
          header: header,
          body: body,
          footer: footer
        )
      }
    )
  }
}

extension View {
  public func bottomModal<Item: Identifiable, Header: View, Body: View, Footer: View>(
    item: Binding<Item?>,
    model: BottomModalVM = .init(),
    onDismiss: (() -> Void)? = nil,
    @ViewBuilder header: @escaping (Item) -> Header,
    @ViewBuilder body: @escaping (Item) -> Body,
    @ViewBuilder footer: @escaping (Item) -> Footer
  ) -> some View {
    return self.modal(
      item: item,
      transitionDuration: model.transition.value,
      onDismiss: onDismiss,
      content: { unwrappedItem in
        SUBottomModal(
          isVisible: .init(
            get: {
              return item.wrappedValue.isNotNil
            },
            set: { isPresented in
              if isPresented {
                item.wrappedValue = unwrappedItem
              } else {
                item.wrappedValue = nil
              }
            }
          ),
          model: model,
          header: { header(unwrappedItem) },
          body: { body(unwrappedItem) },
          footer: { footer(unwrappedItem) }
        )
      }
    )
  }

  public func bottomModal<Item: Identifiable, Body: View>(
    item: Binding<Item?>,
    model: BottomModalVM = .init(),
    onDismiss: (() -> Void)? = nil,
    @ViewBuilder body: @escaping (Item) -> Body
  ) -> some View {
    return self.bottomModal(
      item: item,
      model: model,
      header: { _ in EmptyView() },
      body: body,
      footer: { _ in EmptyView() }
    )
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
    .bottomModal(
      isPresented: $isPresented,
      model: .init {
        $0.overlayStyle = .dimmed
      },
      header: {
        Text("Header")
          .font(.title2)
      },
      body: {
        Text(longText)
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
