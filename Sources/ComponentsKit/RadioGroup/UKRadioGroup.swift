import AutoLayout
import UIKit

/// A UIKit component that displays a group of radio buttons, allowing users to select one option from multiple choices.
open class UKRadioGroup<ID: Hashable>: UIView, UKComponent {
  // MARK: Properties

  /// A closure that is triggered when a selected segment changes.
  public var onSelectionChange: ((ID?) -> Void)?

  /// A model that defines the appearance properties.
  public var model: RadioGroupVM<ID> {
    didSet {
      self.update(oldValue)
    }
  }

  /// An identifier of the selected segment.
  public var selectedId: ID? {
    didSet {
      guard self.selectedId != oldValue else { return }
      self.updateSelection()
      self.onSelectionChange?(self.selectedId)
    }
  }
  /// The identifier of the radio button currently being tapped.
  private var tappingId: ID?

  // MARK: Subviews

  public var stackView = UIStackView()
  private var items: [ID: RadioGroupItemView<ID>] = [:]

  // MARK: Initialization

  /// Initializer.
  /// - Parameters:
  ///   - initialSelectedId: The initial identifier of the selected radio button.
  ///   - model: A model that defines the appearance properties.
  ///   - onSelectionChange: A closure that is triggered when the selected radio button changes.
  public init(
    initialSelectedId: ID? = nil,
    model: RadioGroupVM<ID> = .init(),
    onSelectionChange: ((ID?) -> Void)? = nil
  ) {
    self.selectedId = initialSelectedId
    self.model = model
    self.onSelectionChange = onSelectionChange
    super.init(frame: .zero)

    self.setup()
    self.style()
    self.layout()
  }

  public required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: Setup

  private func setup() {
    self.addSubview(self.stackView)
    self.updateRadioViews()
  }

  private func updateRadioViews() {
    self.stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
    self.items.removeAll()

    self.model.items.forEach { item in
      let radioGroupItemView = RadioGroupItemView(item: item, model: self.model)

      let longPressGesture = UILongPressGestureRecognizer(
        target: self,
        action: #selector(handleContainerLongPress(_:))
      )
      longPressGesture.minimumPressDuration = 0
      radioGroupItemView.addGestureRecognizer(longPressGesture)

      radioGroupItemView.isUserInteractionEnabled = item.isEnabled && self.model.isEnabled

      self.items[item.id] = radioGroupItemView

      self.stackView.addArrangedSubview(radioGroupItemView)
    }
  }

  // MARK: Style

  private func style() {
    Self.Style.stackView(self.stackView, model: self.model)
    self.updateViewStyles()
  }

  private func updateViewStyles() {
    self.model.items.forEach { item in
      guard let radioGroupItemView = self.items[item.id] else { return }

      let isSelected = item.id == self.selectedId

      radioGroupItemView.updateStyle(isSelected: isSelected, model: self.model, item: item, selectedId: self.selectedId)

      if isSelected {
        if radioGroupItemView.innerCircle.alpha == 0.0 {
          radioGroupItemView.innerCircle.alpha = 1.0
          self.zoomIn(view: radioGroupItemView.innerCircle)
        }
      } else {
        if radioGroupItemView.innerCircle.alpha == 1.0 {
          self.zoomOut(view: radioGroupItemView.innerCircle)
        }
      }

      if self.tappingId != item.id {
        radioGroupItemView.radioView.transform = .identity
      }
    }
  }

  // MARK: Layout

  private func layout() {
    self.stackView.allEdges()
  }

  // MARK: Update

  public func update(_ oldModel: RadioGroupVM<ID>) {
    guard self.model != oldModel else { return }

    if self.model.shouldUpdateLayout(oldModel) {
      self.updateRadioViews()
      self.style()
    } else {
      self.updateViewStyles()
    }
  }

  private func updateSelection() {
    self.updateViewStyles()
  }

  // MARK: Helpers

  private func zoomIn(view: UIView) {
    view.transform = CGAffineTransform(scaleX: 0.0, y: 0.0)
    UIView.animate(
      withDuration: 0.2,
      delay: 0.0,
      options: [.curveEaseOut],
      animations: {
        view.transform = CGAffineTransform.identity
      },
      completion: nil
    )
  }

  private func zoomOut(view: UIView) {
    UIView.animate(
      withDuration: 0.2,
      delay: 0.0,
      options: [.curveEaseOut],
      animations: {
        view.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        view.alpha = 0.0
      },
      completion: nil
    )
  }

  private func animateRadioView(for id: ID, scale: CGFloat) {
    guard let radioView = self.items[id]?.radioView else { return }
    UIView.animate(
      withDuration: 0.1,
      delay: 0,
      options: [.curveEaseOut],
      animations: {
        radioView.transform = CGAffineTransform(scaleX: scale, y: scale)
      },
      completion: nil
    )
  }

  // MARK: Gesture Handlers

  @objc private func handleContainerLongPress(_ sender: UILongPressGestureRecognizer) {
    guard let tappedView = sender.view as? RadioGroupItemView<ID> else { return }
    let tappedId = tappedView.itemID

    switch sender.state {
    case .began:
      self.tappingId = tappedId
      self.animateRadioView(for: tappedId, scale: self.model.animationScale.value)
    case .ended:
      self.tappingId = nil
      self.animateRadioView(for: tappedId, scale: 1.0)
      self.selectedId = tappedId
    case .cancelled, .failed:
      self.tappingId = nil
      self.animateRadioView(for: tappedId, scale: 1.0)
    default:
      break
    }
  }
}

// MARK: - Style Helpers

extension UKRadioGroup {
  fileprivate enum Style {
    static func stackView(_ stackView: UIStackView, model: RadioGroupVM<ID>) {
      stackView.axis = .vertical
      stackView.alignment = .leading
      stackView.spacing = 8
      stackView.distribution = .equalSpacing
    }
  }
}
