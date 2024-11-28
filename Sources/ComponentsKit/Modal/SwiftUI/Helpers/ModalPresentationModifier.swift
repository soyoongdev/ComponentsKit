import SwiftUI

struct ModalPresentationModifier<Modal: View>: ViewModifier {
  @State var isPresented: Bool = false
  @Binding var isContentVisible: Bool

  @ViewBuilder var content: () -> Modal

  let onDismiss: (() -> Void)?

  init(
    isVisible: Binding<Bool>,
    onDismiss: (() -> Void)?,
    @ViewBuilder content: @escaping () -> Modal
  ) {
    self._isContentVisible = isVisible
    self.onDismiss = onDismiss
    self.content = content
  }

  func body(content: Content) -> some View {
    content
      .onChange(of: self.isContentVisible) { newValue in
        if newValue {
          self.isPresented = true
        } else {
          DispatchQueue.main.asyncAfter(deadline: .now() + ModalAnimation.duration) {
            self.isPresented = false
          }
        }
      }
      .fullScreenCover(
        isPresented: self.$isPresented,
        onDismiss: self.onDismiss,
        content: {
          self.content()
            .transparentPresentationBackground()
        }
      )
      .transaction {
        $0.disablesAnimations = true
      }
  }
}

extension View {
  func modal<Modal: View>(
    isVisible: Binding<Bool>,
    onDismiss: (() -> Void)? = nil,
    @ViewBuilder content: @escaping () -> Modal
  ) -> some View {
    modifier(ModalPresentationModifier(isVisible: isVisible, onDismiss: onDismiss, content: content))
  }
}
