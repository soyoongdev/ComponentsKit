import AutoLayout
import UIKit

/// A view representing a single radio button item in a radio group.
public class RadioGroupItemView<ID: Hashable>: UIView {
  // MARK: Properties

  let radioView: UIView = UIView()
  let innerCircle: UIView = UIView()
  let titleLabel: UILabel = UILabel()

  var itemID: ID
  var isEnabled: Bool
  var isSelected: Bool = false

  // MARK: Initialization

  init(item: RadioItemVM<ID>, model: RadioGroupVM<ID>) {
    self.itemID = item.id
    self.isEnabled = item.isEnabled
    super.init(frame: .zero)
    self.setup()
    self.style(model: model, item: item)
    self.layout(model: model)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: Setup

  private func setup() {
    self.addSubview(self.radioView)
    self.radioView.addSubview(self.innerCircle)
    self.addSubview(self.titleLabel)
  }

  // MARK: Style

  private func style(model: RadioGroupVM<ID>, item: RadioItemVM<ID>) {
    let radioColor = model.radioItemColor(for: item, selectedId: nil).uiColor
    Style.radioView(self.radioView, model: model, radioColor: radioColor)
    Style.innerCircle(self.innerCircle, model: model, isSelected: self.isSelected, radioColor: radioColor)
    let textColor = model.textColor(for: item, selectedId: nil).uiColor
    Style.titleLabel(
      self.titleLabel,
      text: item.title,
      textColor: textColor,
      font: model.preferredFont(for: item.id).uiFont
    )
  }

  // MARK: Layout

  private func layout(model: RadioGroupVM<ID>) {
    self.radioView.size(model.circleSize)
    self.radioView.leading()
    self.radioView.centerVertically()
    self.radioView.topAnchor.constraint(greaterThanOrEqualTo: self.topAnchor).isActive = true
    self.radioView.bottomAnchor.constraint(lessThanOrEqualTo: self.bottomAnchor).isActive = true

    self.innerCircle.size(model.innerCircleSize)
    self.innerCircle.center(in: self.radioView)

    self.titleLabel.after(self.radioView, padding: 8)
    self.titleLabel.trailing()
    self.titleLabel.centerVertically()
    self.titleLabel.topAnchor.constraint(greaterThanOrEqualTo: self.topAnchor).isActive = true
    self.titleLabel.bottomAnchor.constraint(lessThanOrEqualTo: self.bottomAnchor).isActive = true
  }

  // MARK: Update Style

  func updateStyle(isSelected: Bool, model: RadioGroupVM<ID>, item: RadioItemVM<ID>, selectedId: ID?) {
    self.isSelected = isSelected

    let radioColor = model.radioItemColor(for: item, selectedId: selectedId).uiColor
    let textColor = model.textColor(for: item, selectedId: selectedId).uiColor

    Style.radioView(self.radioView, model: model, radioColor: radioColor)
    Style.innerCircle(self.innerCircle, model: model, isSelected: isSelected, radioColor: radioColor)
    Style.titleLabel(
      self.titleLabel,
      text: item.title,
      textColor: textColor,
      font: model.preferredFont(for: item.id).uiFont
    )
  }

  // MARK: Style Helpers

  fileprivate enum Style {
    static func radioView(_ view: UIView, model: RadioGroupVM<ID>, radioColor: UIColor) {
      view.layer.cornerRadius = model.circleSize / 2
      view.layer.borderWidth = model.lineWidth
      view.layer.borderColor = radioColor.cgColor
      view.backgroundColor = .clear
    }

    static func innerCircle(_ view: UIView, model: RadioGroupVM<ID>, isSelected: Bool, radioColor: UIColor) {
      view.layer.cornerRadius = model.innerCircleSize / 2
      view.backgroundColor = isSelected ? radioColor : .clear
    }

    static func titleLabel(
      _ label: UILabel,
      text: String,
      textColor: UIColor,
      font: UIFont
    ) {
      label.text = text
      label.font = font
      label.textColor = textColor
      label.numberOfLines = 0
    }
  }
}
