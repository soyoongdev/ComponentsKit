import AutoLayout
import UIKit

/// A UIKit component that displays a slider.
open class UKSlider: UIView, UKComponent {
  // MARK: - Properties

  public var model: SliderVM {
    didSet {
      self.update(oldValue)
    }
  }

  public var currentValue: CGFloat {
    didSet {
      self.updateProgressWidthAndAppearance()
    }
  }

  private var initialProgressWidthOnDragBegan: CGFloat = 0

  // MARK: - Subviews

  public let backgroundView = UIView()
  public let progressView = UIView()
  public let stripedLayer = CAShapeLayer()

  public let handleView = UIView()

  // MARK: - Layout Constraints

  private var backgroundViewLightLeadingConstraint: NSLayoutConstraint?
  private var backgroundViewFilledLeadingConstraint: NSLayoutConstraint?
  private var progressViewConstraints: LayoutConstraints = .init()
  private var handleConstraints: LayoutConstraints = .init()

  // MARK: - Private Properties

  private var progress: CGFloat {
    self.model.progress(for: self.currentValue)
  }

  // MARK: - UIView

  open override var intrinsicContentSize: CGSize {
    return self.sizeThatFits(UIView.layoutFittingExpandedSize)
  }

  // MARK: - Initialization

  public init(
    initialValue: CGFloat = 50,
    model: SliderVM = .init()
  ) {
    self.currentValue = initialValue
    self.model = model
    super.init(frame: .zero)

    self.setup()
    self.style()
    self.layout()
  }

  public required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Setup

  private func setup() {
    self.addSubview(self.backgroundView)
    self.addSubview(self.progressView)
    self.addSubview(self.handleView)
    self.progressView.layer.addSublayer(self.stripedLayer)

    let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
    self.handleView.addGestureRecognizer(panGesture)
  }

  // MARK: - Style

  private func style() {
    Self.Style.backgroundView(self.backgroundView, model: self.model)
    Self.Style.progressView(self.progressView, model: self.model)
    Self.Style.stripedLayer(self.stripedLayer, model: self.model)
    Self.Style.handleView(self.handleView, model: self.model)
  }

  // MARK: - Layout

  private func layout() {
    self.backgroundView.vertically()
    self.backgroundView.trailing()

    self.backgroundViewLightLeadingConstraint = self.backgroundView.after(
      self.handleView,
      padding: self.model.trackSpacing
    ).leading

    self.backgroundViewFilledLeadingConstraint = self.backgroundView.leading().leading

    self.backgroundViewFilledLeadingConstraint?.isActive = false

    self.progressViewConstraints = .merged {
      self.progressView.leading(self.model.trackSpacing)
      self.progressView.vertically()
      self.progressView.width(0)
    }

    self.handleConstraints = .merged {
      self.handleView.after(self.progressView, padding: self.model.trackSpacing)
      self.handleView.size(width: self.model.handleSize.width, height: self.model.handleSize.height)
      self.handleView.centerVertically()
    }
  }

  // MARK: - Update

  public func update(_ oldModel: SliderVM) {
    guard self.model != oldModel else { return }

    self.style()

    if self.model.shouldUpdateLayout(oldModel) {
      switch self.model.style {
      case .light, .striped:
        self.backgroundViewFilledLeadingConstraint?.isActive = false
        self.backgroundViewLightLeadingConstraint?.isActive = true
      }

      self.progressViewConstraints.leading?.constant = self.model.trackSpacing

      self.invalidateIntrinsicContentSize()
      self.setNeedsLayout()
    }

    self.updateProgressWidthAndAppearance()
  }

  private func updateProgressWidthAndAppearance() {
    if self.model.style == .striped {
      self.stripedLayer.frame = self.bounds
      self.stripedLayer.path = self.model.stripesBezierPath(in: self.stripedLayer.bounds).cgPath
    }

    let totalHorizontalPadding: CGFloat = self.model.trackSpacing

    let totalWidth = self.bounds.width - totalHorizontalPadding
    let progressWidth = totalWidth * self.progress

    self.progressViewConstraints.width?.constant = max(0, progressWidth)
  }

  // MARK: - Layout

  open override func layoutSubviews() {
    super.layoutSubviews()

    self.backgroundView.layer.cornerRadius =
    self.model.cornerRadius(for: self.backgroundView.bounds.height)

    self.progressView.layer.cornerRadius =
    self.model.cornerRadius(for: self.progressView.bounds.height)

    self.handleView.layer.cornerRadius =
    self.model.cornerRadius(for: self.handleView.bounds.height)

    self.updateProgressWidthAndAppearance()

    self.model.validateMinMaxValues()
  }

  // MARK: - UIView

  open override func sizeThatFits(_ size: CGSize) -> CGSize {
    let width = self.superview?.bounds.width ?? size.width
    return CGSize(
      width: min(size.width, width),
      height: min(size.height, self.model.trackHeight)
    )
  }

  @objc private func handlePan(_ gesture: UIPanGestureRecognizer) {
    switch gesture.state {
    case .began:
      self.initialProgressWidthOnDragBegan = self.progressView.frame.width

    case .changed:
      let translation = gesture.translation(in: self)

      let totalWidth = self.bounds.width
      let sliderWidth = max(0, totalWidth - self.model.handleSize.width - 2 * self.model.trackSpacing)

      let currentLeft = self.initialProgressWidthOnDragBegan
      let newOffset = currentLeft + translation.x
      let clampedOffset = min(max(newOffset, 0), sliderWidth)

      self.currentValue = self.model.steppedValue(for: clampedOffset, trackWidth: sliderWidth)

    default:
      break
    }
  }
}

// MARK: - Style Helpers

extension UKSlider {
  fileprivate enum Style {
    static func backgroundView(_ view: UIView, model: SliderVM) {
      view.backgroundColor = UIColor.red
      view.layer.cornerRadius = model.cornerRadius(for: view.bounds.height)
    }

    static func progressView(_ view: UIView, model: SliderVM) {
      view.backgroundColor = UIColor.blue
      view.layer.cornerRadius = model.cornerRadius(for: view.bounds.height)
      view.layer.masksToBounds = true
    }

    static func stripedLayer(_ layer: CAShapeLayer, model: SliderVM) {
      layer.fillColor = model.color.main.uiColor.cgColor
      switch model.style {
      case .light, .striped:
        layer.isHidden = true
      }
    }
    static func handleView(_ view: UIView, model: SliderVM) {
      view.backgroundColor = .black
      view.layer.cornerRadius = model.cornerRadius(for: model.handleSize.height)
      view.layer.masksToBounds = true
    }
  }
}
