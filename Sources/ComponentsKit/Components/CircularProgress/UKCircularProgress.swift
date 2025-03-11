import AutoLayout
import UIKit

/// A UIKit component that displays a circular progress indicator.
open class UKCircularProgress: UIView, UKComponent {
  // MARK: - Properties

  /// A model that defines the appearance properties for the circular progress.
  public var model: CircularProgressVM {
    didSet {
      self.update(oldValue)
    }
  }

  /// The current progress value.
  public var currentValue: CGFloat {
    didSet {
      self.updateProgress()
    }
  }

  // MARK: - Subviews

  /// The shape layer responsible for rendering the background of the circular progress indicator in a light style.
  public let backgroundLayer = CAShapeLayer()

  /// The shape layer responsible for rendering the progress arc of the circular progress indicator.
  public let progressLayer = CAShapeLayer()

  /// The shape layer responsible for rendering the striped effect in the circular progress indicator.
  public let stripesLayer = CAShapeLayer()

  /// The shape layer that acts as a mask for `stripesLayer`, ensuring it has the intended shape.
  public let stripesMaskLayer = CAShapeLayer()

  /// The label used to display text inside the circular progress indicator.
  public let label = UILabel()

  // MARK: - UIView Properties

  open override var intrinsicContentSize: CGSize {
    return self.model.preferredSize
  }

  // MARK: - Initialization

  /// Initializer.
  /// - Parameters:
  ///   - initialValue: The initial progress value. Defaults to `0`.
  ///   - model: The model that defines the appearance properties.
  public init(
    initialValue: CGFloat = 0,
    model: CircularProgressVM = .init()
  ) {
    self.model = model
    self.currentValue = initialValue
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
    self.layer.addSublayer(self.backgroundLayer)
    self.layer.addSublayer(self.stripesLayer)
    self.layer.addSublayer(self.progressLayer)
    self.addSubview(self.label)

    self.stripesLayer.mask = self.stripesMaskLayer

    if #available(iOS 17.0, *) {
      self.registerForTraitChanges([UITraitUserInterfaceStyle.self]) { (view: Self, _: UITraitCollection) in
        view.handleTraitChanges()
      }
    }

    let progress = self.model.progress(for: self.currentValue)
    self.progressLayer.strokeEnd = progress
    if !self.model.isStripesLayerHidden {
      self.stripesMaskLayer.strokeStart = self.model.stripedArcStart(for: progress)
      self.stripesMaskLayer.strokeEnd = self.model.stripedArcEnd(for: progress)
    }
    self.label.text = self.model.label
  }

  // MARK: - Style

  private func style() {
    Self.Style.backgroundLayer(self.backgroundLayer, model: self.model)
    Self.Style.progressLayer(self.progressLayer, model: self.model)
    Self.Style.label(self.label, model: self.model)
    Self.Style.stripesLayer(self.stripesLayer, model: self.model)
    Self.Style.stripesMaskLayer(self.stripesMaskLayer, model: self.model)
  }

  // MARK: - Update

  public func update(_ oldModel: CircularProgressVM) {
    guard self.model != oldModel else { return }
    self.style()
    self.updateShapePaths()

    if self.model.shouldUpdateText(oldModel) {
      UIView.transition(
        with: self.label,
        duration: self.model.animationDuration,
        options: .transitionCrossDissolve,
        animations: {
          self.label.text = self.model.label
        },
        completion: nil
      )
    }
    if self.model.shouldRecalculateProgress(oldModel) {
      self.updateProgress()
    }
    if self.model.shouldInvalidateIntrinsicContentSize(oldModel) {
      self.invalidateIntrinsicContentSize()
    }
  }

  private func updateShapePaths() {
    let center = CGPoint(x: self.bounds.midX, y: self.bounds.midY)
    let circlePath = UIBezierPath(
      arcCenter: center,
      radius: self.model.radius,
      startAngle: -CGFloat.pi / 2,
      endAngle: -CGFloat.pi / 2 + 2 * .pi,
      clockwise: true
    )

    self.backgroundLayer.path = circlePath.cgPath
    self.progressLayer.path = circlePath.cgPath
    self.stripesMaskLayer.path = circlePath.cgPath
    self.stripesLayer.path = self.model.stripesBezierPath(in: self.bounds).cgPath
  }

  private func updateProgress() {
    let progress = self.model.progress(for: self.currentValue)

    CATransaction.begin()
    CATransaction.setAnimationDuration(self.model.animationDuration)
    CATransaction.setAnimationTimingFunction(CAMediaTimingFunction(name: .linear))
    self.progressLayer.strokeEnd = progress
    if !self.model.isStripesLayerHidden {
      self.stripesMaskLayer.strokeStart = self.model.stripedArcStart(for: progress)
      self.stripesMaskLayer.strokeEnd = self.model.stripedArcEnd(for: progress)
    }
    CATransaction.commit()
  }

  // MARK: - Layout

  private func layout() {
    self.label.center()
  }

  open override func layoutSubviews() {
    super.layoutSubviews()

    self.backgroundLayer.frame = self.bounds
    self.progressLayer.frame = self.bounds
    self.stripesLayer.frame = self.bounds
    self.stripesMaskLayer.frame = self.bounds

    self.updateShapePaths()
  }

  // MARK: - UIView Methods

  open override func sizeThatFits(_ size: CGSize) -> CGSize {
    let preferred = self.model.preferredSize
    return CGSize(
      width: min(size.width, preferred.width),
      height: min(size.height, preferred.height)
    )
  }

  open override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
    super.traitCollectionDidChange(previousTraitCollection)
    self.handleTraitChanges()
  }

  private func handleTraitChanges() {
    Self.Style.backgroundLayer(self.backgroundLayer, model: self.model)
    Self.Style.progressLayer(self.progressLayer, model: self.model)
    Self.Style.stripesLayer(self.stripesLayer, model: self.model)
    Self.Style.stripesMaskLayer(self.stripesMaskLayer, model: self.model)
  }
}

// MARK: - Style Helpers

extension UKCircularProgress {
  fileprivate enum Style {
    static func backgroundLayer(
      _ layer: CAShapeLayer,
      model: CircularProgressVM
    ) {
      layer.fillColor = UIColor.clear.cgColor
      layer.strokeColor = model.color.background.uiColor.cgColor
      layer.lineCap = .round
      layer.lineWidth = model.circularLineWidth
      layer.isHidden = model.isBackgroundLayerHidden
    }

    static func progressLayer(
      _ layer: CAShapeLayer,
      model: CircularProgressVM
    ) {
      layer.fillColor = UIColor.clear.cgColor
      layer.strokeColor = model.color.main.uiColor.cgColor
      layer.lineCap = .round
      layer.lineWidth = model.circularLineWidth
    }

    static func label(
      _ label: UILabel,
      model: CircularProgressVM
    ) {
      label.textAlignment = .center
      label.adjustsFontSizeToFitWidth = true
      label.minimumScaleFactor = 0.5
      label.font = model.titleFont.uiFont
      label.textColor = model.color.main.uiColor
    }

    static func stripesLayer(
      _ layer: CAShapeLayer,
      model: CircularProgressVM
    ) {
      layer.isHidden = model.isStripesLayerHidden
      layer.strokeColor = model.color.main.uiColor.cgColor
      layer.lineWidth = model.stripeWidth
    }

    static func stripesMaskLayer(
      _ layer: CAShapeLayer,
      model: CircularProgressVM
    ) {
      layer.fillColor = UIColor.clear.cgColor
      layer.strokeColor = model.color.background.uiColor.cgColor
      layer.lineCap = .round
      layer.lineWidth = model.circularLineWidth
    }
  }
}
