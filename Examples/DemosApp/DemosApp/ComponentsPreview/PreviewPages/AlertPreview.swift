import ComponentsKit
import SwiftUI
import UIKit

struct AlertPreview: View {
  @State private var model = AlertVM {
    $0.title = "Alert Title"
    $0.message = "Lorem ipsum dolor sit amet, consectetur adipiscing elit."
    $0.primaryButton = .init {
      $0.title = "OK, Got It"
      $0.style = .filled
      $0.color = .primary
//      $0.cornerRadius = .full
    }
    $0.secondaryButton = .init {
      $0.title = "Cancel"
      $0.style = .light
      $0.color = .danger
//      $0.cornerRadius = .full
    }
  }
  
  var body: some View {
    VStack {
      PreviewWrapper(title: "UIKit") {
        UKButton(model: .init { $0.title = "Show Alert" }) {
          UIApplication.shared.topViewController?.present(
            UKAlertController(model: self.model),
            animated: true
          )
        }
        .preview
      }
      Form {
        Picker("Background Color", selection: self.$model.backgroundColor) {
          Text("Default").tag(Optional<UniversalColor>.none)
          Text("Secondary Background").tag(UniversalColor.secondaryBackground)
          Text("Accent Background").tag(ComponentColor.accent.background)
          Text("Success Background").tag(ComponentColor.success.background)
          Text("Warning Background").tag(ComponentColor.warning.background)
          Text("Danger Background").tag(ComponentColor.danger.background)
        }
        Picker("Content Paddings", selection: self.$model.contentPaddings) {
          Text("12px").tag(Paddings(padding: 12))
          Text("16px").tag(Paddings(padding: 16))
          Text("20px").tag(Paddings(padding: 20))
        }
        ContainerRadiusPicker(selection: self.$model.cornerRadius) {
          Text("Custom 30px").tag(ContainerRadius.custom(30))
        }
      }
    }
  }
  
  // MARK: - Helpers
  
  private func ukCardContent() -> UIView {
    let titleLabel = UILabel()
    titleLabel.text = "Card"
    titleLabel.font = UniversalFont.mdHeadline.uiFont
    titleLabel.textColor = UniversalColor.foreground.uiColor
    titleLabel.numberOfLines = 0
    
    let subtitleLabel = UILabel()
    subtitleLabel.text = "Card is a container for text, images, and other content."
    subtitleLabel.font = UniversalFont.mdBody.uiFont
    subtitleLabel.textColor = UniversalColor.secondaryForeground.uiColor
    subtitleLabel.numberOfLines = 0
    
    let stackView = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
    stackView.axis = .vertical
    stackView.spacing = 8
    
    return stackView
  }
  
  private func suCardContent() -> some View {
    VStack(alignment: .leading, spacing: 8) {
      Text("Card")
        .foregroundStyle(UniversalColor.foreground.color)
        .font(UniversalFont.mdHeadline.font)
      
      Text("Card is a container for text, images, and other content.")
        .foregroundStyle(UniversalColor.secondaryForeground.color)
        .font(UniversalFont.mdBody.font)
    }
  }
}

#Preview {
  AlertPreview()
}
