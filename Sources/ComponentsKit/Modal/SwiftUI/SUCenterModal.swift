import SwiftUI

struct SUCenterModal<Header: View, Body: View, Footer: View>: View {
  let model: CenterModalVM

  @Binding var isVisible: Bool

  @ViewBuilder let contentHeader: () -> Header
  @ViewBuilder let contentBody: () -> Body
  @ViewBuilder let contentFooter: () -> Footer

  @State private var contentOpacity: CGFloat = 0

  init(
    isVisible: Binding<Bool>,
    model: CenterModalVM,
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
    ZStack(alignment: .center) {
      ModalOverlay(isVisible: self.$isVisible, model: self.model)

      ModalContent(model: self.model, header: self.contentHeader, body: self.contentBody, footer: self.contentFooter)
    }
    .opacity(self.contentOpacity)
    .onAppear {
      withAnimation(.linear(duration: self.model.transition.value)) {
        self.contentOpacity = 1.0
      }
    }
    .onChange(of: self.isVisible) { newValue in
      withAnimation(.linear(duration: self.model.transition.value)) {
        if newValue {
          self.contentOpacity = 1.0
        } else {
          self.contentOpacity = 0.0
        }
      }
    }
  }
}

// MARK: - Presentation Helpers

extension View {
  public func centerModal<Header: View, Body: View, Footer: View>(
    isPresented: Binding<Bool>,
    model: CenterModalVM = .init(),
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
        SUCenterModal(
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
  public func centerModal<Item: Identifiable, Header: View, Body: View, Footer: View>(
    item: Binding<Item?>,
    model: CenterModalVM = .init(),
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
        SUCenterModal(
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

  public func centerModal<Item: Identifiable, Body: View>(
    item: Binding<Item?>,
    model: CenterModalVM = .init(),
    onDismiss: (() -> Void)? = nil,
    @ViewBuilder body: @escaping (Item) -> Body
  ) -> some View {
    return self.centerModal(
      item: item,
      model: model,
      header: { _ in EmptyView() },
      body: body,
      footer: { _ in EmptyView() }
    )
  }
}
