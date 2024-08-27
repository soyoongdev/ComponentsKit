// Copyright © SwiftKit. All rights reserved.

import SwiftKit
import SwiftUI
import UIKit

private class Container: UIViewController {
  let defaultAlertButton: UKButton = {
    let button = UKButton()
    button.model = .init(
      font: .boldSystemFont(ofSize: 16),
      title: "Default alert"
    )
    return button
  }()

  let customAlertButton: UKButton = {
    let button = UKButton()
    button.model = .init(
      font: .boldSystemFont(ofSize: 16),
      title: "Custom alert"
    )
    return button
  }()

  override func viewDidLoad() {
    super.viewDidLoad()

    self.view.addSubview(self.defaultAlertButton)
    self.view.addSubview(self.customAlertButton)

    self.defaultAlertButton.translatesAutoresizingMaskIntoConstraints = false
    self.defaultAlertButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
    self.defaultAlertButton.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -60).isActive = true

    self.customAlertButton.translatesAutoresizingMaskIntoConstraints = false
    self.customAlertButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
    self.customAlertButton.topAnchor.constraint(equalTo: self.defaultAlertButton.bottomAnchor, constant: 20).isActive = true

    self.defaultAlertButton.addTarget(self, action: #selector(self.handleOpenDefaultAlert), for: .touchUpInside)
    self.customAlertButton.addTarget(self, action: #selector(self.handleOpenCustomAlert), for: .touchUpInside)
  }

  let longMessage = """
Estimados señores,

Mi nombre es Mikhail Chelbaev y me dirijo a ustedes para solicitar la consideración de mi caso respecto a un documento del registro comercial de EE. UU. sin apostilla.

Debido a la necesidad de presentar un certificado del registro comercial de EE. UU. en relación con mi caso actual, me he encontrado con varias dificultades. El proceso de obtención de la apostilla para dicho documento toma varios meses. Además, hacerlo a distancia es bastante complicado y no tengo visa para los EE. UU.
"""
  let shortMessage = "Do you want to proceed?"

  @objc private func handleOpenDefaultAlert() {
    let alertController = UIAlertController(
      title: "Confirmation",
      message: self.longMessage,
      preferredStyle: .alert
    )

    let yesAction = UIAlertAction(title: "Yes", style: .default) { _ in
        // Handle Yes button tap
    }

    let noAction = UIAlertAction(title: "No", style: .cancel) { _ in
        // Handle No button tap
    }

    let mbAction = UIAlertAction(title: "Mb", style: .default) { _ in
        // Handle Mb button tap
    }

    alertController.addAction(yesAction)
    alertController.addAction(noAction)
    alertController.addAction(mbAction)

    self.present(alertController, animated: true, completion: nil)
  }

  @objc private func handleOpenCustomAlert() {
    let alertController = UKAlertController(
      title: "Confirmation",
      message: self.longMessage
    )
    alertController.preferredButtonsLayout = .horizontal(.fillProportionally)

    let yesAction = UKAlertAction(
      model: .init(
        cornerRadius: .large,
        font: .boldSystemFont(ofSize: 16),
        preferredSize: .medium,
        style: .filled,
        title: "Continue"
      ),
      action: {
        print("confirmed")
      }
    )
    let noAction = UKAlertAction(
      model: .init(
        color: .danger,
        font: .boldSystemFont(ofSize: 16),
        style: .filled,
        title: "No, exit"
      )
    )
    let mbAction = UKAlertAction(
      model: .init(
        color: .warning,
        style: .plain,
        title: "Mb later"
      )
    )

    alertController.addAction(yesAction)
    alertController.addAction(noAction)
    alertController.addAction(mbAction)

    self.present(alertController, animated: true, completion: nil)
  }
}

private struct ContainerWrapper: UIViewControllerRepresentable {
  func makeUIViewController(context: Context) -> Container {
    return Container()
  }

  func updateUIViewController(_ controller: Container, context: Context) {

  }
}

struct AlertsView: View {
  var body: some View {
    ContainerWrapper()
  }
}

#Preview {
  AlertsView()
}
