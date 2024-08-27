// Copyright © SwiftKit. All rights reserved.

import SwiftUI
import UIKit

public struct SUButton: View {
  @State public var model: ButtonVM
  @State private var isPressed: Bool

  public init(model: ButtonVM = .init()) {
    self.model = model
    self.isPressed = false
  }

  public var body: some View {
    Button(action: {
      print("123")
    }, label: {
      Text(self.model.title)
        .padding(.horizontal, self.model.preferredSize.horizontalPadding)
        .foregroundStyle(SwiftUI.Color(self.model.foregroundColor))
        .gesture(DragGesture(minimumDistance: 0.0)
          .onChanged { _ in self.isPressed = true }
          .onEnded { _ in self.isPressed = false })
        .onTapGesture {
          print("1234")
        }
    })
    .frame(height: self.model.preferredSize.height)
    .background(SwiftUI.Color(self.model.backgroundColor))
    .clipShape(
      RoundedRectangle(cornerRadius: self.model.cornerRadius.value(for: 100))
    )
    .scaleEffect(self.isPressed ? 0.98 : 1, anchor: .center)
//    .animation(.linear(duration: 0.1), value: self.isPressed)
//    .buttonStyle(ScaleButtonStyle(model: self.model))
//    .frame(height: self.model.preferredSize.height)
//    .background(SwiftUI.Color(self.model.color.main.uiColor))
//    .foregroundStyle(SwiftUI.Color(self.model.color.contrast.uiColor))
//    .clipShape(
//      RoundedRectangle(cornerRadius: self.model.cornerRadius.value(for: 100))
////        .on
////        .scal
//    )
  }
}

struct ScaleButtonStyle: SwiftUI.ButtonStyle {
  @State var model: ButtonVM

  func makeBody(configuration: Configuration) -> some View {
    configuration.label
//      .padding(.all)
      .frame(height: self.model.preferredSize.height)
      .padding(.horizontal)
      .foregroundStyle(SwiftUI.Color(self.model.color.contrast.uiColor))
      .background(SwiftUI.Color(self.model.color.main.uiColor))
      .clipShape(
        RoundedRectangle(cornerRadius: self.model.cornerRadius.value(for: 100))
      )
      .scaleEffect(configuration.isPressed ? 0.98 : 1)
      .animation(.linear)

  }
}

// struct SUButton: UIViewRepresentable {
//  func makeUIView(context: Context) -> UKButton {
////    return UKButton(frame: .zero)
//    let button = UKButton()
//    button.model = .init(
//      animationScale: .large,
//      color: .primary,
//      cornerRadius: .large,
//      font: .boldSystemFont(ofSize: 16),
//      title: "Tap me"
//    )
//    return button
//  }
//
//  func updateUIView(_ uiView: UKButton, context: Context) {
//
//  }
// }
