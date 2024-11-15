import SwiftUI
import UIKit

/// The autocapitalization behavior applied during text input.
public enum TextAutocapitalization {
  /// Do not capitalize anything.
  case never
  /// Capitalize every letter.
  case characters
  /// Capitalize the first letter of every word.
  case words
  /// Capitalize the first letter in every sentence.
  case sentences
}

extension TextAutocapitalization {
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

extension TextAutocapitalization {
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
