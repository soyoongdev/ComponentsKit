import SwiftUI

public struct SUModal<VM: ModalVM, Header: View, Body: View, Footer: View>: View {
  let model: VM

  @Binding var isPresented: Bool

  @ViewBuilder let contentHeader: () -> Header
  @ViewBuilder let contentBody: () -> Body
  @ViewBuilder let contentFooter: () -> Footer

  @State private var headerSize: CGSize = .zero
  @State private var bodySize: CGSize = .zero
  @State private var footerSize: CGSize = .zero

  @State private var overlayOpacity: CGFloat = 0

  @Environment(\.colorScheme) private var colorScheme

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
      Color.black.opacity(self.overlayOpacity)
        .animation(.linear(duration: 0.3), value: self.overlayOpacity)
        .onAppear {
          self.overlayOpacity = 0.7
        }
        .ignoresSafeArea(.all)
        .onTapGesture {
          if self.model.closesOnOverlayTap {
            self.isPresented = false
          }
        }

      VStack(
        alignment: .leading,
        spacing: self.model.contentSpacing
      ) {
        self.contentHeader()
          .observeSize {
            self.headerSize = $0
          }
          .padding(.top, self.model.contentPaddings.top)
          .padding(.leading, self.model.contentPaddings.leading)
          .padding(.trailing, self.model.contentPaddings.trailing)

        ScrollView {
          self.contentBody()
            .padding(.leading, self.model.contentPaddings.leading)
            .padding(.trailing, self.model.contentPaddings.trailing)
            .observeSize {
              self.bodySize = $0
            }
            .padding(.top, self.bodyTopPadding)
            .padding(.bottom, self.bodyBottomPadding)
        }
        .frame(maxHeight: self.scrollViewMaxHeight)
        .disableScrollWhenContentFits()

        self.contentFooter()
          .observeSize {
            self.footerSize = $0
          }
          .padding(.leading, self.model.contentPaddings.leading)
          .padding(.trailing, self.model.contentPaddings.trailing)
          .padding(.bottom, self.model.contentPaddings.bottom)
      }
      .frame(maxWidth: self.model.size.maxWidth)
      .background(self.model.backgroundColor.color(for: self.colorScheme))
      .clipShape(RoundedRectangle(
        cornerRadius: self.model.cornerRadius.value
      ))
      .padding(.top, self.model.outerPaddings.top)
      .padding(.leading, self.model.outerPaddings.leading)
      .padding(.bottom, self.model.outerPaddings.bottom)
      .padding(.trailing, self.model.outerPaddings.trailing)
    }
  }

  private var bodyTopPadding: CGFloat {
    return self.headerSize.height > 0 ? 0 : self.model.contentPaddings.top
  }
  private var bodyBottomPadding: CGFloat {
    return self.footerSize.height > 0 ? 0 : self.model.contentPaddings.bottom
  }
  private var scrollViewMaxHeight: CGFloat {
    return self.bodySize.height + self.bodyTopPadding + self.bodyBottomPadding
  }
}

extension View {
  func disableScrollWhenContentFits() -> some View {
    if #available(iOS 16.4, *) {
      return self.scrollBounceBehavior(.basedOnSize, axes: [.vertical])
    } else {
      return self.onAppear {
        UIScrollView.appearance().bounces = false
      }
    }
  }
}

extension View {
  func observeSize(_ closure: @escaping (_ size: CGSize) -> Void) -> some View {
    return self.overlay(
      GeometryReader { geometry in
        Color.clear.onAppear {
          closure(geometry.size)
        }
      }
    )
  }
}

struct TransparentBackground: UIViewRepresentable {
  func makeUIView(context: Context) -> UIView {
    let view = UIView()
    DispatchQueue.main.async {
      view.superview?.superview?.backgroundColor = .clear
    }
    return view
  }
  func updateUIView(_ uiView: UIView, context: Context) {}
}

extension View {
  func transparentPresentationBackground() -> some View {
    if #available(iOS 16.4, *) {
      return self.presentationBackground(Color.clear)
    } else {
      return self.background(TransparentBackground())
    }
  }
}

extension View {
  public func modal<VM: ModalVM, Header: View, Body: View, Footer: View>(
    isPresented: Binding<Bool>,
    model: VM,
    @ViewBuilder header: @escaping () -> Header = { EmptyView() },
    @ViewBuilder body: @escaping () -> Body,
    @ViewBuilder footer: @escaping () -> Footer = { EmptyView() }
  ) -> some View {
    return self.fullScreenCover(isPresented: isPresented) {
      SUModal(
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
    .modal(
      isPresented: $isPresented,
      model: CenterModalVM(),
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
