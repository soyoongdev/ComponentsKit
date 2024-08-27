// Copyright © SwiftKit. All rights reserved.

import UIKit

public struct UKAlertAction {
  let model: ButtonVM
  let action: (() -> Void)?

  public init(
    model: ButtonVM = .init(),
    action: (() -> Void)? = nil
  ) {
    self.model = model
    self.action = action
  }
}
