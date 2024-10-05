import SwiftUI

/// A SwiftUI component with multiple segments that allows users to select them.
public struct SUSegmentedControl<ID: Hashable>: View {
  // MARK: Properties

  /// A model that defines the appearance properties.
  public var model: SegmentedControlVM<ID>

  /// A Binding value to control the selected segment.
  @Binding public var selectedId: ID

  @Namespace private var animationNamespace
  @Environment(\.colorScheme) private var colorScheme

  // MARK: Initialization

  /// Initializer.
  /// - Parameters:
  ///   - selectedId: A Binding value to control the selected segment.
  ///   - model: A model that defines the appearance properties.
  public init(
    selectedId: Binding<ID>,
    model: SegmentedControlVM<ID>
  ) {
    self._selectedId = selectedId
    self.model = model
  }

  // MARK: Body

  public var body: some View {
    HStack(spacing: 0) {
      ForEach(self.model.items) { itemVM in
        Text(itemVM.title)
          .lineLimit(1)
          .font(self.model.preferredFont(for: itemVM.id).font)
          .foregroundStyle(self.model
            .foregroundColor(
              id: itemVM.id,
              selectedId: self.selectedId
            )
              .color(for: self.colorScheme)
          )
          .frame(maxWidth: self.model.width, maxHeight: self.model.height)
          .padding(.horizontal, self.model.horizontalInnerPaddings)
          .contentShape(Rectangle())
          .onTapGesture {
            withAnimation(.easeInOut(duration: 0.3)) {
              self.selectedId = itemVM.id
            }
          }
          .disabled(!itemVM.isEnabled)
          .background(
            ZStack {
              if itemVM.isEnabled, self.selectedId == itemVM.id {
                RoundedRectangle(
                  cornerRadius: self.model.preferredCornerRadius.value()
                )
                .fill(self.model.selectedSegmentColor.color(
                  for: self.colorScheme
                ))
                .matchedGeometryEffect(
                  id: "segment",
                  in: self.animationNamespace
                )
              }
            }
          )
      }
    }
    .padding(.all, self.model.outerPaddings)
    .frame(height: self.model.height)
    .background(self.model.backgroundColor.color(for: self.colorScheme))
    .clipShape(
      RoundedRectangle(cornerRadius: self.model.preferredCornerRadius.value())
    )
    .disabled(!self.model.isEnabled)
  }
}
