import SwiftUI
import UIKit

public enum SubmitType {
  case done
  case go
  case send
  case join
  case route
  case search
  case `return`
  case next
  case `continue`
}

// MARK: - UIKit Helpers

extension SubmitType {
  var returnKeyType: UIReturnKeyType {
    switch self {
    case .done:
      return .done
    case .go:
      return .go
    case .send:
      return .send
    case .join:
      return .join
    case .route:
      return .route
    case .search:
      return .search
    case .return:
      return .default
    case .next:
      return .next
    case .continue:
      return .continue
    }
  }
}

// MARK: - SwiftUI Helpers

extension SubmitType {
  var submitLabel: SubmitLabel {
    switch self {
    case .done:
      return .done
    case .go:
      return .go
    case .send:
      return .send
    case .join:
      return .join
    case .route:
      return .route
    case .search:
      return .search
    case .return:
      return .return
    case .next:
      return .next
    case .continue:
      return .continue
    }
  }
}
