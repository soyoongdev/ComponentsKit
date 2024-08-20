//
//  ButtonsView.swift
//  SwiftKitApp
//
//  Created by Mikhail on 19.08.2024.
//

import SwiftUI
import UIKit

class Container: UIView {
  let button: UKButton = {
    let button = UKButton()
//    button.isEnabled = false
//    button.cornerRadius = .full
//    button.animationScale = .medium
//    button.style = .bordered(.medium)
//    button.preferredSize = .medium
    button.font = .boldSystemFont(ofSize: 16)
    button.setTitle("Tap me please", for: .normal)
    return button
  }()

  override init(frame: CGRect) {
    super.init(frame: frame)

    self.addSubview(self.button)
    self.button.addTarget(self, action: #selector(self.handleTap), for: .touchUpInside)
  }

  @objc private func handleTap() {
    print("123")
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func layoutSubviews() {
    super.layoutSubviews()
    self.button.center = self.center
  }
}

struct ContainerWrapper: UIViewRepresentable {
  func makeUIView(context: Context) -> Container {
    return Container(frame: .zero)
  }

  func updateUIView(_ uiView: Container, context: Context) {

  }
}

struct ButtonsView: View {
  var body: some View {
    ContainerWrapper()
//    SUButton()
//      .frame(width: 200, height: 50)
  }
}

#Preview {
  ButtonsView()
}
