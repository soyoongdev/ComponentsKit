import SwiftUI

public struct SUSegmentedControl: View {
  private var model: SegmentedControlVM

  @Namespace private var animationNamespace
  @Binding private var selectedIndex: Int

  @Environment(\.colorScheme) private var colorScheme

  public init(
    selectedIndex: Binding<Int>,
    model: SegmentedControlVM
  ) {
    self._selectedIndex = selectedIndex
    self.model = model
  }

  public var body: some View {
    HStack(spacing: 0) {
      ForEach(
        Array(zip(self.model.items.indices, self.model.items)),
        id: \.0,
        content: { index, itemVM in
          Text(itemVM.title)
            .lineLimit(1)
            .font(self.model.preferredFont(for: index).font)
            .foregroundStyle(self.model
              .foregroundColor(
                index: index,
                selectedIndex: self.selectedIndex
              )
              .color(for: self.colorScheme)
            )
            .frame(maxWidth: self.model.width)
            .padding(.vertical, self.model.verticalInnerPaddings)
            .padding(.horizontal, self.model.horizontalInnerPaddings)
            .contentShape(Rectangle())
            .onTapGesture {
              withAnimation(.spring()) {
                self.selectedIndex = index
              }
            }
            .disabled(!itemVM.isEnabled)
            .background(
              ZStack {
                if itemVM.isEnabled, self.selectedIndex == index {
                  RoundedRectangle(
                    cornerRadius: self.model.preferredCornerRadius.value()
                  )
                  .fill(self.model.selectedSegmentColor.color(for: self.colorScheme))
                  .matchedGeometryEffect(
                    id: "segment",
                    in: self.animationNamespace
                  )
                }
              }
            )
        }
      )
    }
    .padding(.all, self.model.outerPaddings)
    .background(self.model.backgroundColor.color(for: self.colorScheme))
    .clipShape(
      RoundedRectangle(cornerRadius: self.model.preferredCornerRadius.value())
    )
    .disabled(!self.model.isEnabled)
  }
}
