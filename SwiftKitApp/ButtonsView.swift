// Copyright © SwiftKit. All rights reserved.

import SwiftKit
import SwiftUI
import UIKit

private class Container: UIView {
  let button = UKButton(
    model: ButtonVM {
      $0.title = "Tap"
      $0.cornerRadius = .medium
      $0.size = .medium
    }
  )

  override init(frame: CGRect) {
    super.init(frame: frame)

    self.addSubview(self.button)

    self.button.centerVertically()
    self.button.centerHorizontally()

    self.button.action = { [weak self] in
      self?.button.model.title = [
        "hello",
        "hello world",
        "hello world hello world"
      ].randomElement()!
    }
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func layoutSubviews() {
    super.layoutSubviews()
    self.button.center = self.center
  }
}

private struct ContainerWrapper: UIViewRepresentable {
  func makeUIView(context: Context) -> Container {
    return Container(frame: .zero)
  }

  func updateUIView(_ uiView: Container, context: Context) {

  }
}

struct ButtonsView: View {
  @State private var model = ButtonVM {
    $0.title = "Tap me please"
    $0.animationScale = .large
    $0.cornerRadius = .full
  }

  var body: some View {
    ContainerWrapper()
  }

//  var body: some View {
//    SUButton(model: .init {
//      $0.title = "Toggle"
//      $0.animationScale = .medium
//      $0.style = .bordered(.medium)
//      $0.color = .accent
//      $0.size = .medium.fullWidth
////      $0.size = .medium.fullWidth
////      $0.contentInsets = .init(top: 10, leading: 0, bottom: 0, trailing: 0)
//    }) {
//      self.model.isEnabled.toggle()
//    }
//    .padding()
//    SUButton(
//      self.$model,
////      model: model,
////      model: .init(
////        title: "Tap me please",
////        animationScale: .large,
////        cornerRadius: .full
////      ),
////      label: {
////        HStack {
////          Image(systemName: "phone")
////          Text("hello")
////            .padding(.vertical, 10)
////        }
////      },
//      action: {
//          print(132)
//          self.model.title = [
//            "title 1",
//            "title 2",
//            "title 3"
//          ].randomElement()!
//          self.model.color = [ComponentColor.accent, ComponentColor.primary, ComponentColor.secondary].randomElement()!
//        }
//    )
//  }
}

#Preview {
  ButtonsView()
}
