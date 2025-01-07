import AutoLayout
import UIKit

/// A UIKit component that displays a Progress Bar.
open class UKProgressBar: UIView, UKComponent {
  open override func sizeThatFits(_ size: CGSize) -> CGSize {
    let width = self.superview?.bounds.width ?? size.width
    return CGSize(
      width: min(size.width, width),
      height: min(size.height, self.model.barHeight)
    )
  }

  open override var intrinsicContentSize: CGSize {
    return self.sizeThatFits(UIView.layoutFittingExpandedSize)
  }

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

  private var backgroundViewConstraints: LayoutConstraints = .init()
  private var progressViewConstraints: LayoutConstraints = .init()

  // MARK: - Private Properties

  private var progress: CGFloat {
    self.model.progress(for: self.currentValue)
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
    UIView.performWithoutAnimation {
      switch self.model.style {
      case .light:
        self.backgroundViewConstraints = .merged {
          self.backgroundView.after(self.progressView, padding: 4)
          self.backgroundView.centerVertically()
          self.backgroundView.height(self.model.barHeight)
          self.backgroundView.width(0)
        }
        self.progressViewConstraints = .merged {
          self.progressView.leading(0)
          self.progressView.centerVertically()
          self.progressView.height(self.model.barHeight)
          self.progressView.width(0)
        }

      case .filled, .striped:
        self.backgroundViewConstraints = .merged {
          self.backgroundView.horizontally(0)
          self.backgroundView.centerVertically()
          self.backgroundView.height(self.model.barHeight)
        }
        self.progressViewConstraints = .merged {
          self.progressView.leading(3, to: self.backgroundView)
          self.progressView.vertically(3, to: self.backgroundView)
          self.progressView.width(0)
        }
      }
    }
  }

  // MARK: - Update

  public func update(_ oldModel: ProgressBarVM) {
    guard self.model != oldModel else { return }

    self.style()

    if self.model.barHeight != oldModel.barHeight {
      self.backgroundViewConstraints.height?.constant = self.model.barHeight
      self.progressViewConstraints.height?.constant = self.model.barHeight
      self.invalidateIntrinsicContentSize()
      self.setNeedsLayout()
    }
    self.updateProgressBar()
  }

  private func updateProgressBar() {
    let duration: TimeInterval = 0.3

    UIView.performWithoutAnimation {
      self.layoutIfNeeded()
    }

    let totalWidth = self.bounds.width - self.model.horizontalPadding
    let progressWidth = totalWidth * self.progress

    switch self.model.style {
    case .light:
      self.progressViewConstraints.width?.constant = max(0, progressWidth)
      self.backgroundViewConstraints.width?.constant = max(0, totalWidth - progressWidth)

    case .filled, .striped:
      self.progressViewConstraints.width?.constant = max(0, progressWidth)
    }

    if self.model.style == .striped {
      self.stripedLayer.frame = self.bounds
      self.stripedLayer.path = self.model.stripesBezierPath(in: self.stripedLayer.bounds).cgPath
    }

    UIView.animate(
      withDuration: duration,
      delay: 0,
      options: .curveEaseInOut,
      animations: {
        self.layoutIfNeeded()
      },
      completion: nil
    )
  }

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
