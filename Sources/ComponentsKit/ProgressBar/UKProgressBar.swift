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
      self.updateBarWidth()
    }
  }

  // MARK: - Subviews

  /// A view representing the part of the progress bar that is not yet filled.
  private let remainingView = UIView()

  /// A view representing the filled part of the bar.
  private let filledView = UIView()

  /// A view used to display the striped pattern.
  private let stripedView = UIView()

  // MARK: - Layout Constraints

  private var remainingViewConstraints: LayoutConstraints = .init()
  private var filledViewConstraints: LayoutConstraints = .init()
  private var stripedViewConstraints: LayoutConstraints = .init()

  // MARK: - Private Properties

  private var progress: CGFloat {
    let range = self.model.maxValue - self.model.minValue
    guard range > 0 else { return 0 }
    let normalized = (self.currentValue - self.model.minValue) / range
    return max(0, min(1, normalized))
  }

  // MARK: - Initialization

  /// Initializer.
  /// - Parameters:
  ///   - currentValue: The initial progress value. Defaults to `0`.
  ///   - model: A model that defines the appearance properties.
  public init(
    currentValue: CGFloat = 0,
    model: ProgressBarVM = .init()
  ) {
    self.currentValue = currentValue
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
    self.addSubview(self.remainingView)
    self.addSubview(self.filledView)
    self.addSubview(self.stripedView)
  }

  // MARK: - Style

  private func style() {
    switch self.model.style {
    case .light:
      self.remainingView.backgroundColor = self.model.backgroundColor.uiColor
      self.filledView.backgroundColor = self.model.barColor.uiColor
      self.stripedView.backgroundColor = .clear

    case .filled:
      self.remainingView.backgroundColor = self.model.color.main.uiColor
      self.filledView.backgroundColor = self.model.color.contrast.uiColor
      self.stripedView.backgroundColor = .clear

    case .striped:
      self.remainingView.backgroundColor = self.model.color.main.uiColor
      self.filledView.backgroundColor = self.model.color.contrast.uiColor
      self.stripedView.backgroundColor = self.model.color.main.uiColor
    }
  }

  // MARK: - Layout

  private func layout() {
    self.remainingViewConstraints.deactivateAll()
    self.filledViewConstraints.deactivateAll()
    self.stripedViewConstraints.deactivateAll()

    UIView.performWithoutAnimation {
      switch self.model.style {
      case .light:
        self.remainingViewConstraints = .merged {
          self.remainingView.after(self.filledView, padding: 4)
          self.remainingView.centerVertically()
          self.remainingView.height(self.model.barHeight)
          self.remainingView.width(0)
        }
        self.filledViewConstraints = .merged {
          self.filledView.leading(0)
          self.filledView.centerVertically()
          self.filledView.height(self.model.barHeight)
          self.filledView.width(0)
        }

      case .filled, .striped:
        self.remainingViewConstraints = .merged {
          self.remainingView.horizontally(0)
          self.remainingView.centerVertically()
          self.remainingView.height(self.model.barHeight)
        }
        self.filledViewConstraints = .merged {
          self.filledView.top(3, to: self.remainingView)
          self.filledView.leading(3, to: self.remainingView)
          self.filledView.bottom(3, to: self.remainingView)
          self.filledView.width(0)
        }

        if self.model.style == .striped {
          self.stripedViewConstraints = .merged {
            self.stripedView.horizontally(0)
            self.stripedView.centerVertically()
            self.stripedView.height(self.model.barHeight)
          }
        }
      }
    }

    self.setNeedsLayout()
  }

  // MARK: - Update

  public func update(_ oldModel: ProgressBarVM) {
    guard self.model != oldModel else { return }

    self.style()

    if self.model.shouldUpdateLayout(from: oldModel) {
      self.layout()
      self.invalidateIntrinsicContentSize()
      self.setNeedsLayout()
    }

    self.updateBarWidth()
  }

  private func updateBarWidth() {
    let duration: TimeInterval = 0.3

    UIView.performWithoutAnimation {
      self.layoutIfNeeded()
    }

    switch self.model.style {
    case .light:
      let totalWidth = self.bounds.width - 4
      let filledWidth = totalWidth * self.progress
      self.filledViewConstraints.width?.constant = max(0, filledWidth)
      self.remainingViewConstraints.width?.constant = max(0, totalWidth - filledWidth)

    case .filled, .striped:
      let totalWidth = self.bounds.width - 6
      let filledWidth = totalWidth * self.progress
      self.filledViewConstraints.width?.constant = max(0, filledWidth)
    }

    UIView.animate(withDuration: duration) {
      self.layoutIfNeeded()
    }
  }

  // MARK: - Style Helpers

  open override func layoutSubviews() {
    super.layoutSubviews()

    switch self.model.style {
    case .light:
      self.remainingView.layer.cornerRadius = self.model.computedCornerRadius
      self.filledView.layer.cornerRadius = self.model.computedCornerRadius

    case .filled:
      self.remainingView.layer.cornerRadius = self.model.computedCornerRadius
      self.filledView.layer.cornerRadius = self.model.innerCornerRadius

    case .striped:
      self.remainingView.layer.cornerRadius = self.model.computedCornerRadius
      self.filledView.layer.cornerRadius = self.model.innerCornerRadius
      self.stripedView.layer.cornerRadius = self.model.computedCornerRadius
      self.stripedView.clipsToBounds = true
    }

    self.updateBarWidth()
    self.layoutIfNeeded()

    if self.model.style == .striped {
      let shapeLayer = CAShapeLayer()
      shapeLayer.path = self.model.stripesBezierPath(in: self.stripedView.bounds).cgPath
      self.stripedView.layer.mask = shapeLayer
    }
  }

  open override var intrinsicContentSize: CGSize {
    CGSize(width: UIView.noIntrinsicMetric, height: self.model.barHeight)
  }
}
