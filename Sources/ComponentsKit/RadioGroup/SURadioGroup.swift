import SwiftUI

public struct SURadioGroup<ID: Hashable>: View {
  @Binding var selectedId: ID?

  public var model: RadioGroupVM<ID>

  @Environment(\.colorScheme) private var colorScheme

  @State private var tappingId: ID?

  public init(
    selectedId: Binding<ID?>,
    model: RadioGroupVM<ID>
  ) {
    self._selectedId = selectedId
    self.model = model
  }

  public var body: some View {
    VStack(alignment: .leading, spacing: 8) {
      ForEach(self.model.items) { item in
        HStack {
          ZStack {
            Circle()
              .strokeBorder(
                self.adjustedColor(for: item),
                lineWidth: self.model.lineWidth
              )
              .frame(maxWidth: self.model.circleSize, maxHeight: self.model.circleSize)
            if self.selectedId == item.id {
              Circle()
                .fill(self.adjustedColor(for: item))
                .frame(maxWidth: self.model.innerCircleSize, maxHeight: self.model.innerCircleSize)
                .transition(.scale)
            }
          }
          .animation(.easeOut(duration: 0.2), value: self.selectedId)
          .scaleEffect(self.tappingId == item.id ? 0.92 : 1.0)
          Text(item.title)
            .font(item.font?.font ?? self.model.font?.font ?? .body)
            .foregroundColor(self.textColor(for: item))
        }
        .contentShape(Rectangle())
        .gesture(
          DragGesture(minimumDistance: 0)
            .onChanged { _ in
              if item.isEnabled && self.model.isEnabled {
                withAnimation(.easeIn(duration: 0.1)) {
                  self.tappingId = item.id
                }
              }
            }
            .onEnded { _ in
              if item.isEnabled && self.model.isEnabled {
                withAnimation(.spring(response: 0.5, dampingFraction: 0.5)) {
                  self.tappingId = nil
                }
                self.selectedId = item.id
              }
            }
        )
        .disabled(!item.isEnabled || !self.model.isEnabled)
      }
    }
  }

  private func adjustedColor(for item: RadioItemVM<ID>) -> Color {
    let baseColor = self.selectedId == item.id
    ? self.model.color.color(for: self.colorScheme)
    : Color.secondary
    return (!item.isEnabled || !self.model.isEnabled)
    ? baseColor.opacity(0.5)
    : baseColor
  }

  private func textColor(for item: RadioItemVM<ID>) -> Color {
    let baseColor = Color.primary
    return (!item.isEnabled || !self.model.isEnabled)
    ? baseColor.opacity(0.5)
    : baseColor
  }
}
