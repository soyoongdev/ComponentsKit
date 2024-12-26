import SwiftUI

extension View {
  /// A SwiftUI view modifier that presents an alert with a title, message, and up to two action buttons.
  ///
  /// All actions in an alert dismiss the alert after the action runs. If no actions are present, a standard “OK” action is included.
  ///
  /// - Parameters:
  ///   - isPresented: A binding that determines whether the alert is presented.
  ///   - model: A model that defines the appearance properties for an alert.
  ///   - primaryAction: An optional closure executed when the primary button is tapped.
  ///   - secondaryAction: An optional closure executed when the secondary button is tapped.
  ///   - onDismiss: An optional closure executed when the alert is dismissed.
  ///
  /// - Example:
  ///   ```swift
  ///   SomeView()
  ///     .suAlert(
  ///       isPresented: $isAlertPresented,
  ///       model: .init { alertVM in
  ///         alertVM.title = "My Alert"
  ///         alertVM.message = "This is an alert."
  ///         alertVM.primaryButton = .init { buttonVM in
  ///           buttonVM.title = "OK"
  ///           buttonVM.color = .primary
  ///           buttonVM.style = .filled
  ///         }
  ///         alertVM.secondaryButton = .init { buttonVM in
  ///           buttonVM.title = "Cancel"
  ///           buttonVM.style = .light
  ///         }
  ///       },
  ///       primaryAction: {
  ///         NSLog("Primary button tapped")
  ///       },
  ///       secondaryAction: {
  ///         NSLog("Secondary button tapped")
  ///       },
  ///       onDismiss: {
  ///         print("Alert dismissed")
  ///       }
  ///     )
  ///   ```
  public func suAlert(
    isPresented: Binding<Bool>,
    model: AlertVM,
    primaryAction: (() -> Void)? = nil,
    secondaryAction: (() -> Void)? = nil,
    onDismiss: (() -> Void)? = nil
  ) -> some View {
    return self.modal(
      isVisible: isPresented,
      transitionDuration: model.transition.value,
      onDismiss: onDismiss,
      content: {
        SUCenterModal(
          isVisible: isPresented,
          model: model.modalVM,
          header: {
            if model.message.isNotNil,
               let title = model.title {
              AlertTitle(text: title)
            }
          },
          body: {
            if let message = model.message {
              AlertMessage(text: message)
            } else if let title = model.title {
              AlertTitle(text: title)
            }
          },
          footer: {
            switch AlertButtonsOrientationCalculator.preferredOrientation(model: model) {
            case .horizontal:
              HStack(spacing: AlertVM.buttonsSpacing) {
                AlertButton(
                  isAlertPresented: isPresented,
                  model: model.secondaryButtonVM,
                  action: secondaryAction
                )
                AlertButton(
                  isAlertPresented: isPresented,
                  model: model.primaryButtonVM,
                  action: primaryAction
                )
              }
            case .vertical:
              VStack(spacing: AlertVM.buttonsSpacing) {
                AlertButton(
                  isAlertPresented: isPresented,
                  model: model.primaryButtonVM,
                  action: primaryAction
                )
                AlertButton(
                  isAlertPresented: isPresented,
                  model: model.secondaryButtonVM,
                  action: secondaryAction
                )
              }
            }
          }
        )
      }
    )
  }
}

// MARK: - Helpers

private struct AlertTitle: View {
  let text: String

  var body: some View {
    Text(self.text)
      .font(UniversalFont.mdHeadline.font)
      .foregroundStyle(UniversalColor.foreground.color)
      .multilineTextAlignment(.center)
      .frame(maxWidth: .infinity)
  }
}

private struct AlertMessage: View {
  let text: String

  var body: some View {
    Text(self.text)
      .font(UniversalFont.mdBody.font)
      .foregroundStyle(UniversalColor.secondaryForeground.color)
      .multilineTextAlignment(.center)
      .frame(maxWidth: .infinity)
  }
}

private struct AlertButton: View {
  @Binding var isAlertPresented: Bool
  let model: ButtonVM?
  let action: (() -> Void)?

  var body: some View {
    if let model {
      SUButton(model: model) {
        self.action?()
        self.isAlertPresented = false
      }
    }
  }
}
