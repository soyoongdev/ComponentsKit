import AutoLayout
import UIKit

/// A UIKit component that displays a Progress Bar.
open class UKProgressBar: UIView, UKComponent {
  // MARK: - Properties

  /// A model that defines the appearance properties.
  public var model: ProgressBarVM {
    didSet {
      self.update(oldValue)
    }
  }

  /// The current progress value for the progress bar.
  public var currentValue: CGFloat {
    didSet {
      self.updateProgressBar()
    }
  }

  // MARK: - Subviews

  /// The background layer of the progress bar.
  public let backgroundView = UIView()

  /// The fill layer that displays the current progress.
  public let progressView = UIView()

  /// A shape layer used to render striped styling.
  public let stripedLayer = CAShapeLayer()

  // MARK: - Layout Constraints

  private var backgroundViewLightLeadingConstraint: NSLayoutConstraint?
  private var backgroundViewFilledLeadingConstraint: NSLayoutConstraint?
  private var progressViewConstraints: LayoutConstraints = .init()

  // MARK: - Private Properties

  private var progress: CGFloat {
    self.model.progress(for: self.currentValue)
  }

  // MARK: - UIView Properties

  open override var intrinsicContentSize: CGSize {
    return self.sizeThatFits(UIView.layoutFittingExpandedSize)
  }

  // MARK: - Initialization

  /// Initializer.
  /// - Parameters:
  ///   - initialValue: The initial progress value. Defaults to `0`.
  ///   - model: A model that defines the appearance properties.
  public init(
    initialValue: CGFloat = 0,
    model: ProgressBarVM = .init()
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

    self.progressView.layer.addSublayer(self.stripedLayer)
  }

  // MARK: - Style

  private func style() {
    Self.Style.backgroundView(self.backgroundView, model: self.model)
    Self.Style.progressView(self.progressView, model: self.model)
    Self.Style.stripedLayer(self.stripedLayer, model: self.model)
  }

  // MARK: - Layout

  private func layout() {
    self.backgroundView.vertically()
    self.backgroundView.trailing()
    self.backgroundViewLightLeadingConstraint = self.backgroundView.after(
      self.progressView,
      padding: self.model.lightBarSpacing
    ).leading
    self.backgroundViewFilledLeadingConstraint = self.backgroundView.leading().leading

    switch self.model.style {
    case .light:
      self.backgroundViewFilledLeadingConstraint?.isActive = false
      self.progressViewConstraints = .merged {
        self.progressView.leading()
        self.progressView.vertically()
      }

    case .filled, .striped:
      self.backgroundViewLightLeadingConstraint?.isActive = false
      self.progressViewConstraints = .merged {
        self.progressView.leading(self.model.innerBarPadding)
        self.progressView.vertically(self.model.innerBarPadding)
      }
    }

    self.progressViewConstraints.width = self.progressView.width(0).width
  }

  // MARK: - Update

  public func update(_ oldModel: ProgressBarVM) {
    guard self.model != oldModel else { return }

    self.style()

    if self.model.barHeight != oldModel.barHeight {
      switch self.model.style {
      case .light:
        self.backgroundViewFilledLeadingConstraint?.isActive = false
        self.backgroundViewLightLeadingConstraint?.isActive = true
        self.progressViewConstraints.leading?.constant = 0
        self.progressViewConstraints.top?.constant = 0
        self.progressViewConstraints.bottom?.constant = 0

      case .filled, .striped:
        self.backgroundViewLightLeadingConstraint?.isActive = false
        self.backgroundViewFilledLeadingConstraint?.isActive = true
        self.progressViewConstraints.leading?.constant = self.model.innerBarPadding
        self.progressViewConstraints.top?.constant = self.model.innerBarPadding
        self.progressViewConstraints.bottom?.constant = -self.model.innerBarPadding
      }

      self.invalidateIntrinsicContentSize()
      self.setNeedsLayout()
    }

    UIView.performWithoutAnimation {
      self.updateProgressBar()
    }
  }

  private func updateProgressBar() {
    if self.model.style == .striped {
      self.stripedLayer.frame = self.bounds
      self.stripedLayer.path = self.model.stripesBezierPath(in: self.stripedLayer.bounds).cgPath
    }

    let totalWidth = self.bounds.width - self.model.horizontalPadding
    let progressWidth = totalWidth * self.progress

    self.progressViewConstraints.width?.constant = max(0, progressWidth)

    UIView.animate(
      withDuration: self.model.animationDuration,
      delay: 0,
      options: .curveEaseInOut,
      animations: {
        self.layoutIfNeeded()
      },
      completion: nil
    )
  }

  // MARK: - Layout

  open override func layoutSubviews() {
    super.layoutSubviews()

    self.backgroundView.layer.cornerRadius = self.model.cornerRadius(forHeight: self.backgroundView.bounds.height)

    switch self.model.style {
    case .light:
      self.progressView.layer.cornerRadius = self.model.cornerRadius(forHeight: self.backgroundView.bounds.height)
    case .filled, .striped:
      self.progressView.layer.cornerRadius = self.model.innerCornerRadius(forHeight: self.backgroundView.bounds.height)
    }

    self.updateProgressBar()
  }

  // MARK: - UIView methods

  open override func sizeThatFits(_ size: CGSize) -> CGSize {
    let width = self.superview?.bounds.width ?? size.width
    return CGSize(
      width: min(size.width, width),
      height: min(size.height, self.model.barHeight)
    )
  }
}

// MARK: - Style Helpers

extension UKProgressBar {
  fileprivate enum Style {
    static func backgroundView(_ view: UIView, model: ProgressBarVM) {
      view.backgroundColor = model.backgroundColor.uiColor
    }

    static func progressView(_ view: UIView, model: ProgressBarVM) {
      view.backgroundColor = model.barColor.uiColor
      view.layer.masksToBounds = true
    }

    static func stripedLayer(_ layer: CAShapeLayer, model: ProgressBarVM) {
      layer.fillColor = model.color.main.uiColor.cgColor
      switch model.style {
      case .light, .filled:
        layer.isHidden = true
      case .striped:
        layer.isHidden = false
      }
    }
  }
}
