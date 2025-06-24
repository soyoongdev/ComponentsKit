import AutoLayout
import UIKit

/// A UIKit component that performs an action when it is tapped by a user.
open class UKGrid: UIView, UKComponent {
  // MARK: Properties
  
  public var dataSource: [Any] = []

  /// A model that defines the appearance properties.
  public var model: GridVM {
    didSet {
      self.update(oldValue)
    }
  }

  // MARK: Subviews

  /// A loading indicator shown when the button is in a loading state.
  public let loaderView = UKLoading()

  // MARK: Private Properties

  private lazy var collectionView: UICollectionView = {
    let view = UICollectionView(frame: .zero, collectionViewLayout: self.getLayout())
    view.isScrollEnabled = true
    view.showsHorizontalScrollIndicator = false
    view.showsVerticalScrollIndicator = true
    view.contentInset = .zero
    view.backgroundColor = .clear
    view.clipsToBounds = true
    view.register(MyCell.self, forCellWithReuseIdentifier: MyCell.id)
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()

  // MARK: UIView Properties

  open override var intrinsicContentSize: CGSize {
    return self.sizeThatFits(UIView.layoutFittingExpandedSize)
  }

  // MARK: Initialization

  /// Initializer.
  /// - Parameters:
  ///   - model: A model that defines the appearance properties.
  ///   - action: A closure that is triggered when the button is tapped.
  public init(model: GridVM) {
    self.model = model
    super.init(frame: .zero)

    self.setup()
    self.style()
    self.layout()
  }

  public required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: Setup

  private func setup() {
    self.addSubview(self.collectionView)
    self.collectionView.dataSource = self
  }

  // MARK: Style

  private func style() {
    Self.Style.loaderView(self.loaderView, model: self.model)
  }

  // MARK: Layout

  private func layout() {
    self.collectionView.allEdges(self.model.padding, in: self, safeArea: false)
  }

  open override func layoutSubviews() {
    super.layoutSubviews()
    self.collectionView.performBatchUpdates(nil, completion: nil)
    self.layer.cornerRadius = self.model.cornerRadius.value(for: self.bounds.height)
  }

  // MARK: Update

  public func update(_ oldModel: GridVM) {
    guard self.model != oldModel else { return }

    self.style()
  }

  // MARK: UIView methods

}

// MARK: - Style Helpers

extension UKGrid {
  fileprivate enum Style {
    static func loaderView(_ view: UKLoading, model: Model) {
      view.model = model.preferredLoadingVM
      view.isVisible = model.isLoading
    }
  }
  
  private func getLayout() -> UICollectionViewLayout {
      return UICollectionViewCompositionalLayout { sectionIndex, env -> NSCollectionLayoutSection? in
        switch self.model.direction {
        case .vertical:
          return self.getListSection()
        case .horizontal:
          return self.getGridSection()
        }
      }
    }
    
    private func getListSection() -> NSCollectionLayoutSection {
      let itemSize = NSCollectionLayoutSize(
        widthDimension: .fractionalWidth(1.0),
        heightDimension: .fractionalHeight(1.0)
      )
      let item = NSCollectionLayoutItem(layoutSize: itemSize)
      item.contentInsets = NSDirectionalEdgeInsets(top: self.model.spacing, leading: self.model.spacing, bottom: self.model.spacing, trailing: self.model.spacing)
      let groupSize = NSCollectionLayoutSize(
        widthDimension: .fractionalWidth(1.0),
        heightDimension: .absolute(120)
      )
      let group = NSCollectionLayoutGroup.horizontal(
        layoutSize: groupSize,
        subitems: [item]
      )
      return NSCollectionLayoutSection(group: group)
    }
    
    private func getGridSection() -> NSCollectionLayoutSection {
      let itemSize = NSCollectionLayoutSize(
        widthDimension: .fractionalWidth(0.3),
        heightDimension: .fractionalHeight(1.0)
      )
      let item = NSCollectionLayoutItem(layoutSize: itemSize)
      item.contentInsets = NSDirectionalEdgeInsets(top: self.model.spacing, leading: self.model.spacing, bottom: self.model.spacing, trailing: self.model.spacing)
      let groupSize = NSCollectionLayoutSize(
        widthDimension: .fractionalWidth(1.0),
        heightDimension: .fractionalHeight(0.3)
      )
      // collectionView의 width에 3개의 아이템이 위치하도록 하는 것
      let group = NSCollectionLayoutGroup.horizontal(
        layoutSize: groupSize,
        subitem: item,
        count: self.model.direction.columns
      )
      let section = NSCollectionLayoutSection(group: group)
      section.orthogonalScrollingBehavior = .paging
      section.visibleItemsInvalidationHandler = { [weak self] (visibleItems, offset, env) in
        guard let ss = self else { return }
        let normalizedOffsetX = offset.x
        let centerPoint = CGPoint(x: normalizedOffsetX + ss.collectionView.bounds.width / 2, y: 20)
        visibleItems.forEach({ item in
          guard let cell = ss.collectionView.cellForItem(at: item.indexPath) else { return }
          UIView.animate(withDuration: 0.3) {
            cell.transform = item.frame.contains(centerPoint) ? .identity : CGAffineTransform(scaleX: 0.9, y: 0.9)
          }
        })
      }
      return section
    }
}

extension UKGrid: UICollectionViewDataSource {
  public func numberOfSections(in collectionView: UICollectionView) -> Int {
    self.dataSource.count
  }
  
  public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return self.dataSource.count
  }
  
  public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.model.cellIdentifier, for: indexPath) as!
//    switch self.dataSource[indexPath.section] {
//    case let .main(items):
//      cell.prepare(text: items[indexPath.item].text)
//    case let .sub(items):
//      cell.prepare(text: items[indexPath.item].text)
//    }
//    return cell
  }
}
