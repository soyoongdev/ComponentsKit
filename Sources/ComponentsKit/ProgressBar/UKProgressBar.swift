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

  private let backgroundView = UIView()
  private let progressView = UIView()
  private let stripedView = UIView()

  // MARK: - Layout Constraints

  private var remainingViewConstraints: LayoutConstraints = .init()
  private var filledViewConstraints: LayoutConstraints = .init()
  private var stripedViewConstraints: LayoutConstraints = .init()

  // MARK: - Private Properties

  private var progress: CGFloat {
    self.model.progress(for: self.currentValue)
  }

  // MARK: - Initialization

  /// Initializer.
  /// - Parameters:
  ///   - currentValue: The initial progress value. Defaults to `0`.
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
    self.addSubview(self.stripedView)
  }

  // MARK: - Style

  private func style() {
    switch self.model.style {
    case .light:
      self.backgroundView.backgroundColor = self.model.backgroundColor.uiColor
      self.progressView.backgroundColor = self.model.barColor.uiColor
      self.stripedView.backgroundColor = .clear

    case .filled:
      self.backgroundView.backgroundColor = self.model.color.main.uiColor
      self.progressView.backgroundColor = self.model.color.contrast.uiColor
      self.stripedView.backgroundColor = .clear

    case .striped:
      self.backgroundView.backgroundColor = self.model.color.main.uiColor
      self.progressView.backgroundColor = self.model.color.contrast.uiColor
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
          self.backgroundView.after(self.progressView, padding: 4)
          self.backgroundView.centerVertically()
          self.backgroundView.height(self.model.barHeight)
          self.backgroundView.width(0)
        }
        self.filledViewConstraints = .merged {
          self.progressView.leading(0)
          self.progressView.centerVertically()
          self.progressView.height(self.model.barHeight)
          self.progressView.width(0)
        }

      case .filled, .striped:
        self.remainingViewConstraints = .merged {
          self.backgroundView.horizontally(0)
          self.backgroundView.centerVertically()
          self.backgroundView.height(self.model.barHeight)
        }
        self.filledViewConstraints = .merged {
          self.progressView.leading(3, to: self.backgroundView)
          self.progressView.vertically(3, to: self.backgroundView)
          self.progressView.width(0)
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

    if self.model.shouldUpdateLayout(oldModel) {
      self.layout()
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
    let filledWidth = totalWidth * self.progress

    switch self.model.style {
    case .light:
      self.filledViewConstraints.width?.constant = max(0, filledWidth)
      self.remainingViewConstraints.width?.constant = max(0, totalWidth - filledWidth)

    case .filled, .striped:
      self.filledViewConstraints.width?.constant = max(0, filledWidth)
    }

    if self.model.style == .striped {
      let shapeLayer = CAShapeLayer()
      shapeLayer.path = self.model.stripesBezierPath(in: self.stripedView.bounds).cgPath
      self.stripedView.layer.mask = shapeLayer
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
      self.backgroundView.layer.cornerRadius = self.model.cornerRadius(forHeight:  self.backgroundView.bounds.height)
      self.progressView.layer.cornerRadius = self.model.cornerRadius(forHeight:  self.backgroundView.bounds.height)

    case .filled:
      self.backgroundView.layer.cornerRadius = self.model.cornerRadius(forHeight:  self.backgroundView.bounds.height)
      self.progressView.layer.cornerRadius = self.model.innerCornerRadius(forHeight:  self.backgroundView.bounds.height)

    case .striped:
      self.backgroundView.layer.cornerRadius = self.model.cornerRadius(forHeight:  self.backgroundView.bounds.height)
      self.progressView.layer.cornerRadius = self.model.innerCornerRadius(forHeight:  self.backgroundView.bounds.height)
      self.stripedView.layer.cornerRadius = self.model.cornerRadius(forHeight:  self.backgroundView.bounds.height)
      self.stripedView.clipsToBounds = true
    }

    self.updateProgressBar()
    self.layoutIfNeeded()
  }
}
