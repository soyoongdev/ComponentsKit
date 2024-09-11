import SwiftUI

public struct SUSegmentedControl<ID: Hashable>: View {
  private var model: SegmentedControlVM<ID>

  @Namespace private var animationNamespace
  @Binding private var selectedId: ID

  @Environment(\.colorScheme) private var colorScheme

  public init(
    selectedId: Binding<ID>,
    model: SegmentedControlVM<ID>
  ) {
    self._selectedId = selectedId
    self.model = model
  }

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
