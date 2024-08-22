// Copyright © SwiftKit. All rights reserved.

import UIKit

public struct UKAlertAction {
  let title: String
  let style: (UKButton) -> Void
  let action: () -> Void

  public init(
    title: String,
    style: @escaping (UKButton) -> Void = { _ in },
    action: @escaping () -> Void = {}
  ) {
    self.title = title
    self.style = style
    self.action = action
  }
}
