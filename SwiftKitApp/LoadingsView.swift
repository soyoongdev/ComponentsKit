// Copyright © SwiftKit. All rights reserved.

import SwiftKit
import SwiftUI
import UIKit

private class Container: UIView {
  let loading: UKLoading = {
    let loading = UKLoading()
    loading.color = .accent
    loading.size = .medium
    loading.startAnimation()
    return loading
  }()
  lazy var button: UKButton = {
    let button = UKButton()
    button.setTitle("Toggle animation", for: .normal)
    return button
  }()

  override init(frame: CGRect) {
    super.init(frame: frame)

    self.setup()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func setup() {
    self.addSubview(self.loading)
    self.addSubview(self.button)

    self.button.on(.touchUpInside) {
      if self.loading.isAnimating {
        self.loading.stopAnimation()
      } else {
        self.loading.startAnimation()
      }
    }

    self.loading.size(60)
    self.loading.centerVertically()
    self.loading.centerHorizontally()

    self.button.centerHorizontally()
    self.button.below(of: self.loading, padding: 40)
  }
}

private struct ContainerWrapper: UIViewRepresentable {
  func makeUIView(context: Context) -> Container {
    return Container(frame: .zero)
  }

  func updateUIView(_ uiView: Container, context: Context) {

  }
}

struct LoadingsView: View {
  var body: some View {
    ContainerWrapper()
//    SUButton()
//      .frame(width: 200, height: 50)
  }
}

#Preview {
  LoadingsView()
}
