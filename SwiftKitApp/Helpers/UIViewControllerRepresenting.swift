import UIKit
import SwiftUI

struct UIViewControllerRepresenting<ViewController: UIViewController>: UIViewControllerRepresentable {
  private let controller: ViewController

  init(_ controller: () -> ViewController) {
    self.controller = controller()
  }

  func makeUIViewController(context: Context) -> some UIViewController {
    return self.controller
  }
  func updateUIViewController(
    _ uiViewController: UIViewControllerType,
    context: Context
  ) {}
}
