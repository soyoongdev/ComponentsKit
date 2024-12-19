import AutoLayout
import Combine
import UIKit

public class UKCountdown: UIView, UKComponent {
  public var model: CountdownVM {
    didSet {
      self.update(oldValue)
    }
  }

  private let stackView = UIStackView()

  private let daysLabel = UILabel()
  private let hoursLabel = UILabel()
  private let minutesLabel = UILabel()
  private let secondsLabel = UILabel()

  private let daysContainer = UIView()
  private let hoursContainer = UIView()
  private let minutesContainer = UIView()
  private let secondsContainer = UIView()

  private let manager = CountdownManager()
  private var cancellables: Set<AnyCancellable> = []

  private var timeWidth: CGFloat = 70
  private var colonLabels: [UILabel] = []

  public init(model: CountdownVM) {
    self.model = model
    super.init(frame: .zero)
    self.setup()
    self.style()
    self.layout()
    self.setupSubscriptions()
    self.manager.start(until: self.model.until)
    self.updateTimeWidthIfNeeded()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  deinit {
    self.manager.stop()
  }

  private func setup() {
    self.addSubview(self.stackView)

    [self.daysLabel, self.hoursLabel, self.minutesLabel, self.secondsLabel].forEach { label in
      label.numberOfLines = 0
      label.textAlignment = .center
      label.lineBreakMode = .byClipping
    }

    self.configureUnitContainer(self.daysContainer, label: self.daysLabel, unit: .days)
    self.configureUnitContainer(self.hoursContainer, label: self.hoursLabel, unit: .hours)
    self.configureUnitContainer(self.minutesContainer, label: self.minutesLabel, unit: .minutes)
    self.configureUnitContainer(self.secondsContainer, label: self.secondsLabel, unit: .seconds)
  }

  private func style() {
    self.stackView.axis = .horizontal
    self.stackView.alignment = .center
    self.stackView.distribution = .equalSpacing

    Self.Style.mainView(self, model: self.model)
    Self.Style.unitContainer(self.daysContainer, model: self.model)
    Self.Style.unitContainer(self.hoursContainer, model: self.model)
    Self.Style.unitContainer(self.minutesContainer, model: self.model)
    Self.Style.unitContainer(self.secondsContainer, model: self.model)

    Self.Style.unitLabel(self.daysLabel, model: self.model)
    Self.Style.unitLabel(self.hoursLabel, model: self.model)
    Self.Style.unitLabel(self.minutesLabel, model: self.model)
    Self.Style.unitLabel(self.secondsLabel, model: self.model)

    self.daysLabel.attributedText = self.model.timeText(value: manager.days, unit: .days)
    self.hoursLabel.attributedText = self.model.timeText(value: manager.hours, unit: .hours)
    self.minutesLabel.attributedText = self.model.timeText(value: manager.minutes, unit: .minutes)
    self.secondsLabel.attributedText = self.model.timeText(value: manager.seconds, unit: .seconds)
  }

  private func layout() {
    self.stackView.allEdges()
    self.stackView.spacing = self.model.spacing

    self.applyLayoutAccordingToStyle()
    self.applyTimeWidth()
  }

  private func configureUnitContainer(_ container: UIView, label: UILabel, unit: CountdownHelpers.Unit) {
    container.subviews.forEach { $0.removeFromSuperview() }
    container.addSubview(label)

    label.self.top()
    label.self.bottom()
    label.self.leading()
    label.self.trailing()

    let minHeightConstraint = container.heightAnchor.constraint(greaterThanOrEqualToConstant: self.model.height)
    minHeightConstraint.isActive = true

    if self.model.style == .light {
      let minWidthConstraint = container.widthAnchor.constraint(greaterThanOrEqualToConstant: self.model.lightBackgroundMinWidth)
      minWidthConstraint.isActive = true
    }
  }

  private func applyLayoutAccordingToStyle() {
    self.stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
    self.colonLabels.forEach { $0.removeFromSuperview() }
    self.colonLabels.removeAll()

    switch (self.model.style, self.model.unitsStyle) {
    case (.plain, _):
      self.stackView.addArrangedSubview(self.daysContainer)
      self.stackView.addArrangedSubview(self.createAndStoreColon())
      self.stackView.addArrangedSubview(self.hoursContainer)
      self.stackView.addArrangedSubview(self.createAndStoreColon())
      self.stackView.addArrangedSubview(self.minutesContainer)
      self.stackView.addArrangedSubview(self.createAndStoreColon())
      self.stackView.addArrangedSubview(self.secondsContainer)
    case (.light, _):
      self.stackView.addArrangedSubview(self.daysContainer)
      self.stackView.addArrangedSubview(self.hoursContainer)
      self.stackView.addArrangedSubview(self.minutesContainer)
      self.stackView.addArrangedSubview(self.secondsContainer)
    }
    self.colonLabels.forEach { Self.Style.colonLabel($0, model: self.model) }
  }

  private func createAndStoreColon() -> UILabel {
    let colon = UILabel()
    self.colonLabels.append(colon)
    return colon
  }

  private func setupSubscriptions() {
    self.manager.$days
      .sink { [weak self] newValue in
        guard let self = self else { return }
        self.daysLabel.attributedText = self.model.timeText(value: newValue, unit: .days)
        self.updateTimeWidthIfNeeded()
      }
      .store(in: &self.cancellables)

    self.manager.$hours
      .sink { [weak self] newValue in
        guard let self = self else { return }
        self.hoursLabel.attributedText = self.model.timeText(value: newValue, unit: .hours)
        self.updateTimeWidthIfNeeded()
      }
      .store(in: &self.cancellables)

    self.manager.$minutes
      .sink { [weak self] newValue in
        guard let self = self else { return }
        self.minutesLabel.attributedText = self.model.timeText(value: newValue, unit: .minutes)
        self.updateTimeWidthIfNeeded()
      }
      .store(in: &self.cancellables)

    self.manager.$seconds
      .sink { [weak self] newValue in
        guard let self = self else { return }
        self.secondsLabel.attributedText = self.model.timeText(value: newValue, unit: .seconds)
        self.updateTimeWidthIfNeeded()
      }
      .store(in: &self.cancellables)
  }

  public func update(_ oldModel: CountdownVM) {
    guard self.model != oldModel else { return }

    if self.model.until != oldModel.until {
      self.manager.stop()
      self.manager.start(until: self.model.until)
    }

    let shouldRelayout = self.model.shouldRecalculateWidth(oldModel)
    || self.model.style != oldModel.style
    || self.model.unitsStyle != oldModel.unitsStyle

    if shouldRelayout {
      self.applyLayoutAccordingToStyle()
      self.style()
    } else {
      self.style()
    }

    self.updateTimeWidthIfNeeded()
    self.setNeedsLayout()
    self.layoutIfNeeded()
  }

  private func updateTimeWidthIfNeeded() {
    let newTimeWidth = self.model.timeWidth(manager: manager)
    if abs(newTimeWidth - self.timeWidth) > 0.5 {
      self.timeWidth = newTimeWidth
      self.applyTimeWidth()
    }
  }

  private func applyTimeWidth() {
    let labels = [daysLabel, hoursLabel, minutesLabel, secondsLabel]
    for label in labels {
      label.constraints.filter { $0.firstAttribute == .width }.forEach { $0.isActive = false }
      let widthConstraint = label.widthAnchor.constraint(equalToConstant: self.timeWidth)
      widthConstraint.priority = .defaultHigh
      widthConstraint.isActive = true
    }
    self.layoutIfNeeded()
  }

  public func updateUntil(_ newDate: Date) {
    self.manager.stop()
    self.manager.start(until: newDate)
  }
}

extension UKCountdown {
  fileprivate enum Style {
    static func mainView(_ view: UIView, model: CountdownVM) {
      view.backgroundColor = .clear
    }

    static func unitContainer(_ container: UIView, model: CountdownVM) {
      switch model.style {
      case .plain:
        container.backgroundColor = .clear
        container.layer.cornerRadius = 0
      case .light:
        container.backgroundColor = model.backgroundColor.uiColor
        container.layer.cornerRadius = 8
        container.clipsToBounds = true
      }
    }

    static func unitLabel(_ label: UILabel, model: CountdownVM) {
      label.font = model.preferredFont.uiFont
      label.textColor = model.foregroundColor.uiColor
      label.textAlignment = .center
    }

    static func colonLabel(_ label: UILabel, model: CountdownVM) {
      label.text = ":"
      label.font = model.preferredFont.uiFont
      label.textColor = .gray
      label.textAlignment = .center
    }
  }
}
