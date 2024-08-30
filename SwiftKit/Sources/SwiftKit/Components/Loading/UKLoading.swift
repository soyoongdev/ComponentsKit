import UIKit

open class UKLoading: UIView {
  // MARK: Properties

  /// A Boolean value that controls whether the activity indicator is hidden when the animation is stopped.
  ///
  /// If the value of this property is true (the default), the receiver sets its `isHidden` property (UIView) to true when 
  /// receiver is not animating. If the hidesWhenStopped property is false, the receiver is not hidden when animation stops.
  /// You stop an animating progress indicator with the stopAnimating() method.
  public var hidesWhenStopped: Bool = false {
    didSet {
      if !self.isAnimating {
        self.isHidden = self.hidesWhenStopped
      }
    }
  }

  /// A Boolean value indicating whether the activity indicator is currently running its animation.
  public private(set) var isAnimating: Bool = false

  public var style: LoadingStyle = .spinner
  public var color: ComponentColor = .primary {
    didSet {
      self.shapeLayer.strokeColor = self.color.main.uiColor.cgColor
    }
  }
  public var size: LoadingSize = .medium {
    didSet {
      self.updateLineWidth()
    }
  }
  public var lineWidth: CGFloat? {
    didSet {
      self.updateLineWidth()
    }
  }

  // MARK: Layers

  private lazy var shapeLayer = CAShapeLayer()

  // MARK: Initializers

  public override init(frame: CGRect) {
    super.init(frame: frame)

    if frame.size != .zero {
      self.size = .custom(frame.size)
    }

    self.setup()
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
    self.pauseAnimation()

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
  }

  private func setupLayer() {
    self.shapeLayer.strokeColor = self.color.main.uiColor.cgColor
    self.shapeLayer.fillColor = UIColor.clear.cgColor
    self.shapeLayer.lineWidth = 6.0
    self.shapeLayer.lineCap = .round
    self.shapeLayer.strokeEnd = 0.0
  }

  @objc func handleAppWillMoveToBackground() {
    if self.isAnimating {
      self.pauseAnimation()
    }
  }
  @objc func handleAppMovedFromBackground() {
    self.addSpinnerAnimation()
    self.resumeAnimation()

    if !self.isAnimating {
      self.pauseAnimation()
    }
  }

  // MARK: Update

  private func updateLineWidth() {
    self.shapeLayer.lineWidth = self.lineWidth ?? self.size.lineWidth
  }

  // MARK: UIView methods

  open override func sizeThatFits(_: CGSize) -> CGSize {
    return self.size.cgSize
  }

  // MARK: Loading methods

  public func startAnimation() {
    guard !self.isAnimating else { return }

    if self.hidesWhenStopped {
      self.isHidden = false
    }

    self.resumeAnimation()
    self.isAnimating = true
  }

  public func stopAnimation() {
    if self.hidesWhenStopped {
      self.isHidden = true
    }

    self.pauseAnimation()
    self.isAnimating = false
  }

  // MARK: Layout

  open override func layoutSubviews() {
    super.layoutSubviews()

    // Adjust the layer's frame to fit within the view's bounds
    self.shapeLayer.frame = self.bounds

    let radius = self.size.cgSize.height / 2 - self.shapeLayer.lineWidth / 2
    let center = CGPoint(x: self.bounds.midX, y: self.bounds.midY)
    self.shapeLayer.path = UIBezierPath(arcCenter: center, radius: radius, startAngle: 0, endAngle: 2 * .pi, clockwise: true).cgPath
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
    rotationAnimation.duration = 2.0
    rotationAnimation.repeatCount = .infinity
    rotationAnimation.timingFunction = CAMediaTimingFunction(name: .linear)
    self.shapeLayer.add(rotationAnimation, forKey: "rotationAnimation")

    // Stroke end animation
    let strokeEndAnimation = CAKeyframeAnimation(keyPath: "strokeEnd")
    strokeEndAnimation.keyTimes = [0.0, 0.475, 0.95, 1.0]
    strokeEndAnimation.values = [0, 0.8, 0.95, 1.0]
    strokeEndAnimation.duration = 1.5
    strokeEndAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
    strokeEndAnimation.repeatCount = .infinity
    self.shapeLayer.add(strokeEndAnimation, forKey: "strokeEndAnimation")

    // Stroke start animation
    let strokeStartAnimation = CAKeyframeAnimation(keyPath: "strokeStart")
    strokeStartAnimation.keyTimes = [0.0, 0.475, 0.95, 1.0]
    strokeStartAnimation.values = [0.0, 0.1, 0.8, 1.0]
    strokeStartAnimation.duration = 1.5
    strokeStartAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
    strokeStartAnimation.repeatCount = .infinity
    self.shapeLayer.add(strokeStartAnimation, forKey: "strokeStartAnimation")
  }
}
