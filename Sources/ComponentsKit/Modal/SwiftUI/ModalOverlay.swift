import SwiftUI

struct ModalOverlay<VM: ModalVM>: View {
  let model: VM

  @Binding var isVisible: Bool

  init(
    isVisible: Binding<Bool>,
    model: VM
  ) {
    self._isVisible = isVisible
    self.model = model
  }

  var body: some View {
    Group {
      switch self.model.overlayStyle {
      case .dimmed:
        Color.black.opacity(0.7)
      case .blurred:
        Color.clear.background(.ultraThinMaterial)
      case .opaque:
        // Note: It can't be completely transparent as it won't receive touch gestures.
        Color.black.opacity(0.0001)
      }
    }
    .ignoresSafeArea(.all)
    .onTapGesture {
      if self.model.closesOnOverlayTap {
        self.isVisible = false
      }
    }
  }
}
