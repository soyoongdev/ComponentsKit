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

  /// The Shape Layer used to render the background of the circular progress indicator.
  public let backgroundLayer = CAShapeLayer()

  /// The Shape Layer used to render the progress arc of the circular progress indicator.
  public let progressLayer = CAShapeLayer()

  /// The Shape Layer used to render the stripes effect in the circular progress indicator.
  public let stripesLayer = CAShapeLayer()

  /// The Mask Layer used for the stripesLayer.
  public let stripesMaskLayer = CAShapeLayer()

  /// The Label used to display progress text.
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

    self.updateProgress()
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

    if #available(iOS 17.0, *) {
      self.registerForTraitChanges([UITraitUserInterfaceStyle.self]) { (view: Self, _: UITraitCollection) in
        view.handleTraitChanges()
      }
    }
  }

  // MARK: - Style

  private func style() {
    Self.Style.backgroundLayer(self.backgroundLayer, model: self.model)
    Self.Style.progressLayer(self.progressLayer, model: self.model)
    Self.Style.label(self.label, model: self.model)
    Self.Style.stripesLayer(self.stripesLayer, backgroundLayer: self.backgroundLayer, maskLayer: self.stripesMaskLayer, model: self.model)
  }

  // MARK: - Update

  public func update(_ oldModel: CircularProgressVM) {
    guard self.model != oldModel else { return }
    self.style()
    self.updateShapePaths()
    self.updateProgress()

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

    if case .striped = self.model.style {
      let stripesPath = self.model.stripesBezierPath(in: self.bounds)

      var transform = CGAffineTransform.identity
      transform = transform
        .translatedBy(x: center.x, y: center.y)
        .rotated(by: -CGFloat.pi / 2)
        .translatedBy(x: -center.x, y: -center.y)

      stripesPath.apply(transform)

      self.stripesLayer.path = stripesPath.cgPath
    } else {
      CATransaction.begin()
      CATransaction.setDisableActions(true)
      self.stripesLayer.path = nil
      self.stripesLayer.removeAllAnimations()
      self.stripesMaskLayer.removeAllAnimations()
      CATransaction.commit()
    }
  }

  private func updateProgress() {
    let progress = self.model.progress(for: self.currentValue)

    let backgroundLayerStart: CGFloat
    let backgroundLayerEnd: CGFloat
    switch self.model.style {
    case .light:
      backgroundLayerStart = 0
      backgroundLayerEnd   = 1

    case .striped:
      backgroundLayerStart = self.model.stripedArcStart(for: progress)
      backgroundLayerEnd   = self.model.stripedArcEnd(for: progress)
    }

    CATransaction.begin()
    CATransaction.setAnimationDuration(self.model.animationDuration)
    CATransaction.setAnimationTimingFunction(CAMediaTimingFunction(name: .linear))

    self.progressLayer.strokeEnd = progress

    self.backgroundLayer.strokeStart = backgroundLayerStart
    self.backgroundLayer.strokeEnd = backgroundLayerEnd

    if case .striped = self.model.style {
      self.stripesMaskLayer.strokeStart = backgroundLayerStart
      self.stripesMaskLayer.strokeEnd = backgroundLayerEnd
    } else {
      self.stripesMaskLayer.strokeStart = 0
      self.stripesMaskLayer.strokeEnd = 1
    }

    CATransaction.commit()

    if let labelText = self.model.label {
      UIView.transition(
        with: self.label,
        duration: self.model.animationDuration,
        options: .transitionCrossDissolve,
        animations: {
          self.label.text = labelText
        },
        completion: nil
      )
    } else {
      self.label.text = nil
    }
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
    Self.Style.label(self.label, model: self.model)
    Self.Style.stripesLayer(
      self.stripesLayer,
      backgroundLayer: self.backgroundLayer,
      maskLayer: self.stripesMaskLayer,
      model: self.model
    )
  }
}

// MARK: - Style Helpers

extension UKCircularProgress {
  fileprivate enum Style {
    static func backgroundLayer(_ layer: CAShapeLayer, model: CircularProgressVM) {
      layer.fillColor = UIColor.clear.cgColor

      switch model.style {
      case .light:
        layer.strokeColor = model.color.background.uiColor.cgColor
      case .striped:
        layer.strokeColor = UIColor.clear.cgColor
      }

      layer.lineCap = .round
      layer.lineWidth = model.circularLineWidth
    }

    static func progressLayer(_ layer: CAShapeLayer, model: CircularProgressVM) {
      layer.fillColor = UIColor.clear.cgColor
      layer.strokeColor = model.color.main.uiColor.cgColor
      layer.lineCap = .round
      layer.lineWidth = model.circularLineWidth
    }

    static func label(_ label: UILabel, model: CircularProgressVM) {
      label.textAlignment = .center
      label.adjustsFontSizeToFitWidth = true
      label.minimumScaleFactor = 0.5
      label.font = model.titleFont.uiFont
      label.textColor = model.color.main.uiColor
    }

    static func stripesLayer(
      _ stripesLayer: CAShapeLayer,
      backgroundLayer: CAShapeLayer,
      maskLayer: CAShapeLayer,
      model: CircularProgressVM
    ) {
      switch model.style {
      case .light:
        stripesLayer.isHidden = true
        stripesLayer.mask = nil

        if backgroundLayer.superlayer == nil,
           let parentLayer = stripesLayer.superlayer {
          parentLayer.insertSublayer(backgroundLayer, below: stripesLayer)
        }

      case .striped:
        stripesLayer.isHidden = false
        stripesLayer.fillColor = model.color.main.uiColor.cgColor

        maskLayer.fillColor = UIColor.clear.cgColor
        maskLayer.strokeColor = UIColor.white.cgColor
        maskLayer.lineCap = .round
        maskLayer.lineWidth = model.circularLineWidth

        stripesLayer.mask = maskLayer
      }
    }
  }
}
