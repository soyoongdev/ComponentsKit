import SwiftKit
import SwiftUI

struct SwiftUILogin: View {
  enum Pages {
    case signIn
    case signUp
  }
  @State private var selectedPage = Pages.signIn

  @State private var name = ""
  @State private var email = ""
  @State private var password = ""

  @FocusState private var isNameFocused: Bool
  @FocusState private var isEmailFocused: Bool
  @FocusState private var isPasswordFocused: Bool

  @State private var isConsented: Bool = false

  @State private var isLoading = false

  private var isButtonEnabled: Bool {
    return self.email.isNotEmpty
    && self.password.isNotEmpty
    && self.isConsented
    && (
      self.selectedPage == .signUp && self.name.isNotEmpty
      || self.selectedPage == .signIn
    )
  }

  @Environment(\.colorScheme) var colorScheme

  var body: some View {
    ZStack {
      Palette.Base.background.color(for: self.colorScheme)

      ScrollView {
        VStack(spacing: 20) {
          SUSegmentedControl<Pages>(
            selectedId: self.$selectedPage,
            model: .init {
              $0.items = [
                .init(id: .signIn) {
                  $0.title = "Sign In"
                },
                .init(id: .signUp) {
                  $0.title = "Sign Up"
                }
              ]
              $0.isEnabled = !self.isLoading
            }
          )

          Text(
            self.selectedPage == .signIn
            ? "Welcome back"
            : "Create an account"
          )
          .font(.system(size: 30, weight: .bold))
          .padding(.vertical, 30)

          if self.selectedPage == .signUp {
            SUInputField(
              text: self.$name,
              isSelected: self.$isNameFocused,
              model: .init {
                $0.title = "Name"
                $0.isRequired = true
                $0.isEnabled = !self.isLoading
              }
            )
          }
          SUInputField(
            text: self.$email,
            isSelected: self.$isEmailFocused,
            model: .init {
              $0.title = "Email"
              $0.isRequired = true
              $0.isEnabled = !self.isLoading
            }
          )
          SUInputField(
            text: self.$password,
            isSelected: self.$isPasswordFocused,
            model: .init {
              $0.title = "Password"
              $0.isRequired = true
              $0.isSecureInput = true
              $0.isEnabled = !self.isLoading
            }
          )

          HStack {
            SUCheckbox(
              isSelected: self.$isConsented,
              model: .init {
                $0.title = "By continuing, you accept our Terms of Service and Privacy Policy"
                $0.isEnabled = !self.isLoading
              }
            )
            Spacer()
          }

          Group {
            if self.isLoading {
              SULoading()
            } else {
              SUButton(
                model: .init {
                  $0.title = "Continue"
                  $0.isFullWidth = true
                  $0.isEnabled = self.isButtonEnabled
                },
                action: {
                  self.isLoading = true
                  DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self.isLoading = false
                    UINotificationFeedbackGenerator().notificationOccurred(.success)
                  }
                }
              )
            }
          }
          .padding(.top, 30)
        }
        .padding()
      }
    }
    .onTapGesture {
      self.isNameFocused = false
      self.isEmailFocused = false
      self.isPasswordFocused = false
    }
  }
}

#Preview {
  SwiftUILogin()
}
