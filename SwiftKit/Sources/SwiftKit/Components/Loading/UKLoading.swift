import UIKit

open class UKLoading: UIView, ConfigurableComponent {
  // MARK: Properties

  public var model: LoadingVM {
    didSet {
      self.update(oldValue)
    }
  }

  // MARK: UIView Properties

  open override var intrinsicContentSize: CGSize {
    return self.sizeThatFits(UIView.layoutFittingExpandedSize)
  }

  // MARK: Layers

  private lazy var shapeLayer = CAShapeLayer()

  // MARK: Initializers

  public init(model: LoadingVM = .init()) {
    self.model = model
    super.init(frame: .zero)

    self.setup()
    self.update(self.model)
  }

  public required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: Deinitialization

  deinit {
    NotificationCenter.default.removeObserver(self)
  }

  // MARK: Setup

  func setup() {
    self.setupLayer()
    self.layer.addSublayer(self.shapeLayer)

    self.addSpinnerAnimation()

    NotificationCenter.default.addObserver(
      self,
      selector: #selector(self.handleAppWillMoveToBackground),
      name: UIApplication.willResignActiveNotification,
      object: nil
    )
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(self.handleAppMovedFromBackground),
      name: UIApplication.didBecomeActiveNotification,
      object: nil
    )

    if #available(iOS 17.0, *) {
      self.registerForTraitChanges([UITraitUserInterfaceStyle.self]) { (view: Self, _: UITraitCollection) in
        view.handleTraitChanges()
      }
    }
  }

  private func setupLayer() {
    self.shapeLayer.strokeColor = self.model.color.main.uiColor.cgColor
    self.shapeLayer.fillColor = UIColor.clear.cgColor
    self.shapeLayer.lineWidth = 6.0
    self.shapeLayer.lineCap = .round
    self.shapeLayer.strokeEnd = 0.75
  }

  @objc func handleAppWillMoveToBackground() {
    if self.model.isAnimating {
      self.pauseAnimation()
    }
  }
  @objc func handleAppMovedFromBackground() {
    self.addSpinnerAnimation()
    self.resumeAnimation()

    if !self.model.isAnimating {
      self.pauseAnimation()
    }
  }

  // MARK: Update

  public func update(_ oldModel: LoadingVM) {
    self.shapeLayer.lineWidth = self.model.loadingLineWidth
    self.shapeLayer.strokeColor = self.model.color.main.uiColor.cgColor

    if self.model.shouldStartAnimating(oldModel) {
      self.resumeAnimation()
    } else if self.model.shouldStopAnimating(oldModel) {
      self.pauseAnimation()
    }
    if self.model.shouldUpdateSize(oldModel) {
      self.invalidateIntrinsicContentSize()
      self.setNeedsLayout()
    }
    if self.model.shouldUpdateAnimation(oldModel) {
      self.shapeLayer.removeAllAnimations()
      self.addSpinnerAnimation()
    }
  }

  private func updateShapePath() {
    let radius = self.model.preferredSize.height / 2 - self.shapeLayer.lineWidth / 2
    let center = CGPoint(x: self.bounds.midX, y: self.bounds.midY)
    self.shapeLayer.path = UIBezierPath(
      arcCenter: center,
      radius: radius,
      startAngle: 0,
      endAngle: 2 * .pi,
      clockwise: true
    ).cgPath
  }

  // MARK: Layout

  open override func layoutSubviews() {
    super.layoutSubviews()

    // Adjust the layer's frame to fit within the view's bounds
    self.shapeLayer.frame = self.bounds
    self.updateShapePath()
  }

  // MARK: UIView methods

  open override func sizeThatFits(_ size: CGSize) -> CGSize {
    let preferredSize = self.model.preferredSize
    return .init(
      width: min(preferredSize.width, size.width),
      height: min(preferredSize.height, size.height)
    )
  }

  open override func traitCollectionDidChange(
    _ previousTraitCollection: UITraitCollection?
  ) {
    super.traitCollectionDidChange(previousTraitCollection)
    self.handleTraitChanges()
  }

  // MARK: Helpers

  private func pauseAnimation() {
    let pausedTime = self.shapeLayer.convertTime(CACurrentMediaTime(), from: nil)

    self.shapeLayer.speed = 0.0
    self.shapeLayer.timeOffset = pausedTime
  }

  private func resumeAnimation() {
    let pausedTime: CFTimeInterval = self.shapeLayer.timeOffset

    self.shapeLayer.speed = 1.0
    self.shapeLayer.timeOffset = 0.0
    self.shapeLayer.beginTime = 0.0

    let timeSincePause = self.shapeLayer.convertTime(CACurrentMediaTime(), from: nil) - pausedTime
    self.shapeLayer.beginTime = timeSincePause
  }

  private func addSpinnerAnimation() {
    // Rotation animation
    let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
    rotationAnimation.fromValue = 0
    rotationAnimation.toValue = CGFloat.pi * 2
    rotationAnimation.duration = 0.8 * self.model.speed
    rotationAnimation.repeatCount = .infinity
    rotationAnimation.timingFunction = CAMediaTimingFunction(name: .linear)
    self.shapeLayer.add(rotationAnimation, forKey: "rotationAnimation")
  }

  private func handleTraitChanges() {
    self.update(self.model)
  }
}
