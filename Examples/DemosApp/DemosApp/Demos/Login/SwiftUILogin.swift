import ComponentsKit
import SwiftUI

struct SwiftUILogin: View {
  enum Pages {
    case signIn
    case signUp
  }
  enum Input {
    case name
    case email
    case password
    case bio
  }

  @State private var selectedPage = Pages.signIn

  @State private var name = ""
  @State private var email = ""
  @State private var password = ""
  @State private var bio = ""

  @FocusState private var focusedInput: Input?
  @State private var isConsented: Bool = false
  @State private var isLoading = false

  private var isButtonEnabled: Bool {
    return !self.email.isEmpty
    && !self.password.isEmpty
    && self.isConsented
    && (
      self.selectedPage == .signUp && !self.name.isEmpty
      || self.selectedPage == .signIn
    )
  }

  var body: some View {
    ZStack {
      UniversalColor.background.color

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
          .font(UniversalFont.lgHeadline.font)
          .padding(.vertical, 30)

          if self.selectedPage == .signUp {
            SUInputField(
              text: self.$name,
              globalFocus: self.$focusedInput,
              localFocus: .name,
              model: .init {
                $0.title = "Name"
                $0.isRequired = true
                $0.isEnabled = !self.isLoading
              }
            )
          }
          SUInputField(
            text: self.$email,
            globalFocus: self.$focusedInput,
            localFocus: .email,
            model: .init {
              $0.title = "Email"
              $0.isRequired = true
              $0.isEnabled = !self.isLoading
            }
          )
          SUInputField(
            text: self.$password,
            globalFocus: self.$focusedInput,
            localFocus: .password,
            model: .init {
              $0.title = "Password"
              $0.isRequired = true
              $0.isSecureInput = true
              $0.isEnabled = !self.isLoading
            }
          )

          if self.selectedPage == .signUp {
            SUTextInput(
              text: self.$bio,
              globalFocus: self.$focusedInput,
              localFocus: .bio,
              model: .init {
                $0.placeholder = "Tell about yourself"
                $0.minRows = 3
                $0.maxRows = 5
                $0.isEnabled = !self.isLoading
              }
            )
          }

          SUCheckbox(
            isSelected: self.$isConsented,
            model: .init {
              $0.title = "By continuing, you accept our Terms of Service and Privacy Policy"
              $0.isEnabled = !self.isLoading
            }
          )

          Group {
            if self.isLoading {
              SULoading()
            } else {
              SUButton(
                model: .init {
                  $0.title = "Continue"
                  $0.isFullWidth = true
                  $0.color = .primary
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
          .padding(.top, 10)
        }
        .padding()
      }
    }
    .frame(maxWidth: 500)
    .onChange(of: self.selectedPage) { newValue in
      if newValue == .signIn,
         self.focusedInput == .name || self.focusedInput == .bio {
        self.focusedInput = .email
      }
    }
    .onTapGesture {
      self.focusedInput = nil
    }
  }
}

#Preview {
  SwiftUILogin()
}
