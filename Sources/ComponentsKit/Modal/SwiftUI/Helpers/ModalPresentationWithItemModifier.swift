import SwiftUI

struct ModalPresentationWithItemModifier<Modal: View, Item: Identifiable>: ViewModifier {
  @State var presentedItem: Item?
  @Binding var visibleItem: Item?

  @ViewBuilder var content: (Item) -> Modal

  let transitionDuration: TimeInterval
  let onDismiss: (() -> Void)?

  init(
    item: Binding<Item?>,
    transitionDuration: TimeInterval,
    onDismiss: (() -> Void)?,
    @ViewBuilder content: @escaping (Item) -> Modal
  ) {
    self._visibleItem = item
    self.transitionDuration = transitionDuration
    self.onDismiss = onDismiss
    self.content = content
  }

  func body(content: Content) -> some View {
    content
      .onChange(of: self.visibleItem.isNotNil) { newValue in
        if newValue {
          self.presentedItem = self.visibleItem
        } else {
          DispatchQueue.main.asyncAfter(deadline: .now() + self.transitionDuration) {
            self.presentedItem = self.visibleItem
          }
        }
      }
      .fullScreenCover(
        item: self.$presentedItem,
        onDismiss: self.onDismiss,
        content: { item in
          self.content(item)
            .transparentPresentationBackground()
        }
      )
      .transaction {
        $0.disablesAnimations = true
      }
  }
}

extension View {
  func modal<Modal: View, Item: Identifiable>(
    item: Binding<Item?>,
    transitionDuration: TimeInterval,
    onDismiss: (() -> Void)? = nil,
    @ViewBuilder content: @escaping (Item) -> Modal
  ) -> some View {
    modifier(ModalPresentationWithItemModifier(
      item: item,
      transitionDuration: transitionDuration,
      onDismiss: onDismiss,
      content: content
    ))
  }
}
