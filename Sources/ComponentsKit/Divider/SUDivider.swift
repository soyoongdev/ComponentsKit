import SwiftUI

/// A SwiftUI component that displays a divider.
public struct SUDivider: View {
  // MARK: - Properties

  /// A model that defines the appearance properties.
  public var model: DividerVM

  @Environment(\.colorScheme) private var colorScheme

  // MARK: - Initialization

  /// Initializer.
  /// - Parameters:
  ///   - model: A model that defines the appearance properties.
  public init(model: DividerVM = .init()) {
    self.model = model
  }

  // MARK: - Body

  public var body: some View {
    Rectangle()
      .fill(self.model.color.color(for: colorScheme))
      .frame(
        width: self.model.orientation == .vertical ? model.lineSize : nil,
        height: self.model.orientation == .horizontal ? model.lineSize : nil
      )
  }
}

// MARK: - Previews

struct CustomDivider_Previews: PreviewProvider {
  static var previews: some View {
    SUDivider(
      model: .init {
        $0.size = .large
        $0.color = .danger
        $0.orientation = .horizontal
      }
    )
  }
}
