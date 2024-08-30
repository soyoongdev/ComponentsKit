// Copyright © SwiftKit. All rights reserved.

import SwiftUI
import UIKit

public struct SUButton: View {
  private var model: ButtonVM
  private var action: () -> Void

  @State private var viewFrame: CGRect = .zero
  @State private var isPressed: Bool = false

  public init(
    model: ButtonVM,
    action: @escaping () -> Void = {}
  ) {
    self.model = model
    self.action = action
  }

  public var body: some View {
    Text(self.model.title)
      .lineLimit(1)
      .padding(.leading, self.model.leadingInset)
      .padding(.trailing, self.model.trailingInset)
      .padding(.top, self.model.topInset)
      .padding(.bottom, self.model.bottomInset)
      .frame(
        maxWidth: self.model.width,
        maxHeight: self.model.height
      )
      .foregroundStyle(SwiftUI.Color(self.model.foregroundColor))
      .background(
        GeometryReader { proxy in
          SwiftUI.Color(self.model.backgroundColor)
            .preference(key: ViewFrameKey.self, value: proxy.frame(in: .local))
        }
      )
      .onPreferenceChange(ViewFrameKey.self) { value in
        self.viewFrame = value
      }
      .gesture(DragGesture(minimumDistance: 0.0)
        .onChanged { _ in
          self.isPressed = true
        }
        .onEnded { value in
          defer { self.isPressed = false }

          if self.viewFrame.contains(value.location) {
            self.action()
          }
        }
      )
      .disabled(!self.model.isEnabled)
      .clipShape(
        RoundedRectangle(
          cornerRadius: self.model.cornerRadius.value(
            for: self.model.height ?? .infinity
          )
        )
      )
      .overlay {
        RoundedRectangle(
          cornerRadius: self.model.cornerRadius.value(
            for: self.model.height ?? .infinity
          )
        )
        .stroke(
          SwiftUI.Color(self.model.borderColor),
          lineWidth: self.model.borderWidth
        )
      }
      .scaleEffect(self.isPressed ? 0.98 : 1, anchor: .center)
  }
}

// MARK: - Helpers

private struct ViewFrameKey: PreferenceKey {
  static var defaultValue: CGRect = .zero

  static func reduce(value: inout CGRect, nextValue: () -> CGRect) {
    value = nextValue()
  }
}
