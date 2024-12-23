import AutoLayout
import UIKit

open class UKCard: UIView, UKComponent {
  public typealias Content = () -> UIView

  public let content: UIView
  public let contentView = UIView()

  private var contentConstraints = LayoutConstraints()

  public var model: CardVM {
    didSet {
      self.update(oldValue)
    }
  }

  public init(model: CardVM, content: @escaping Content) {
    self.model = model
    self.content = content()

    super.init(frame: .zero)

    self.setup()
    self.style()
    self.layout()
  }

  public required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  open func setup() {
    self.addSubview(self.contentView)
    self.contentView.addSubview(self.content)
  }

  open func style() {
    Self.Style.mainView(self, model: self.model)
    Self.Style.contentView(self.contentView, model: self.model)
  }

  open func layout() {
    self.contentView.allEdges()

    self.contentConstraints = LayoutConstraints.merged {
      self.content.top(self.model.contentPaddings.top)
      self.content.bottom(self.model.contentPaddings.bottom)
      self.content.leading(self.model.contentPaddings.leading)
      self.content.trailing(self.model.contentPaddings.trailing)
    }
  }

  open override func layoutSubviews() {
    super.layoutSubviews()

    self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
  }

  open func update(_ oldValue: CardVM) {
    guard self.model != oldValue else { return }

    self.style()

    if self.model.contentPaddings != oldValue.contentPaddings {
      self.contentConstraints.top?.constant = self.model.contentPaddings.top
      self.contentConstraints.bottom?.constant = -self.model.contentPaddings.bottom
      self.contentConstraints.leading?.constant = self.model.contentPaddings.leading
      self.contentConstraints.trailing?.constant = -self.model.contentPaddings.trailing
    }

    self.layoutIfNeeded()
  }
}

extension UKCard {
  fileprivate enum Style {
    static func mainView(_ view: UIView, model: Model) {
      view.backgroundColor = UniversalColor.background.uiColor
      view.layer.cornerRadius = model.cornerRadius.value
      view.layer.borderWidth = 1
      view.layer.borderColor = UniversalColor.divider.uiColor.cgColor
      view.layer.shadowColor = UIColor.black.cgColor
      view.layer.shadowRadius = 16
      view.layer.shadowOpacity = 0.1
      view.layer.shadowOffset = .init(width: 0, height: 10)
    }

    static func contentView(_ view: UIView, model: Model) {
      view.backgroundColor = model.preferredBackgroundColor.uiColor
      view.layer.cornerRadius = model.cornerRadius.value
    }
  }
}
