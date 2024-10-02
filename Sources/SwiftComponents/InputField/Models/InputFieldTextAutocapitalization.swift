import UIKit
import SwiftUI

public enum InputFieldTextAutocapitalization {
  case never
  case characters
  case words
  case sentences
}

extension InputFieldTextAutocapitalization {
  var textAutocapitalizationType: UITextAutocapitalizationType {
    switch self {
    case .never:
      return .none
    case .characters:
      return .allCharacters
    case .words:
      return .words
    case .sentences:
      return .sentences
    }
  }
}

extension InputFieldTextAutocapitalization {
  var textInputAutocapitalization: TextInputAutocapitalization {
    switch self {
    case .never:
      return .never
    case .characters:
      return .characters
    case .words:
      return .words
    case .sentences:
      return .sentences
    }
  }
}
