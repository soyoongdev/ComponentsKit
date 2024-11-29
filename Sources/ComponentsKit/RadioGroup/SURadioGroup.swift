import SwiftUI

/// A SwiftUI component that displays a group of radio buttons, allowing users to select one option from multiple choices.
public struct SURadioGroup<ID: Hashable>: View {
  // MARK: Properties

  /// A model that defines the appearance properties.
  public var model: RadioGroupVM<ID>

  /// A Binding value to control the selected identifier.
  @Binding public var selectedId: ID?

  @Environment(\.colorScheme) private var colorScheme
  @State private var tappingId: ID?

  // MARK: Initialization

  /// Initializer.
  /// - Parameters:
  ///   - selectedId: A binding to the selected identifier.
  ///   - model: A model that defines the appearance properties.
  public init(
    selectedId: Binding<ID?>,
    model: RadioGroupVM<ID>
  ) {
    self._selectedId = selectedId
    self.model = model
  }

  // MARK: Body

  public var body: some View {
    VStack(alignment: .leading, spacing: 8) {
      ForEach(self.model.items) { item in
        HStack(spacing: 8) {
          ZStack {
            Circle()
              .strokeBorder(
                self.model.radioItemColor(for: item, selectedId: self.selectedId).color(for: self.colorScheme),
                lineWidth: self.model.lineWidth
              )
              .frame(width: self.model.circleSize, height: self.model.circleSize)
            if self.selectedId == item.id {
              Circle()
                .fill(
                  self.model.radioItemColor(for: item, selectedId: self.selectedId).color(for: self.colorScheme)
                )
                .frame(width: self.model.innerCircleSize, height: self.model.innerCircleSize)
                .transition(.scale)
            }
          }
          .animation(.easeOut(duration: 0.2), value: self.selectedId)
          .scaleEffect(self.tappingId == item.id ? self.model.animationScale.value : 1.0)
          Text(item.title)
            .font(self.model.preferredFont(for: item.id).font)
            .foregroundColor(
              self.model.textColor(for: item, selectedId: self.selectedId).color(for: self.colorScheme)
            )
        }
        .gesture(
          DragGesture(minimumDistance: 0)
            .onChanged { _ in
              self.tappingId = item.id
            }
            .onEnded { _ in
              self.tappingId = nil
              self.selectedId = item.id
            }
        )
        .disabled(!item.isEnabled || !self.model.isEnabled)
      }
    }
  }
}
