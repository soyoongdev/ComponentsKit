// Copyright © SwiftKit. All rights reserved.

import SwiftKit
import SwiftUI
import UIKit

fileprivate class Container: UIView {
  let loading: UKLoading = {
//    let loading = UKLoading()
    let loading = UKLoading(frame: .init(origin: .zero, size: .init(width: 50, height: 50)))
    loading.backgroundColor = .red
    return loading
  }()

  override init(frame: CGRect) {
    super.init(frame: frame)

    self.addSubview(self.loading)
//    self.loading.frame = .init(origin: .zero, size: .init(width: 50, height: 50))
//    self.loading.startAnimating()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func layoutSubviews() {
    super.layoutSubviews()
    self.loading.center = self.center
//    self.loading.spin()
  }
}

fileprivate struct ContainerWrapper: UIViewRepresentable {
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
