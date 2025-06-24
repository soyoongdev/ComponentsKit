import UIKit

/// A model that defines the appearance properties for a text input component.
public struct GridVM: ComponentVM {
  
  // MARK: - Properties
  
  /// The direction of the grid layout.
  /// Defaults to `.vertical`.
  public var direction: ComponentDirection = .vertical
  
  /// The spacing of element in the grid.
  /// Defaults to `8.0`.
  public var spacing: CGFloat = 8.0
  
  /// The predefined size of the grid.
  /// Defaults to `.medium`.
  public var size: ComponentSize = .medium
  
  /// The alignment of the grid items.
  /// Defaults to `.fill`.
  public var alignment: ComponentAlignment = .fill
  
  /// The vertical scroll indicator visibility of the grid.
  /// Defaults to `true`.
  public var showVerticalScrollIndicator: Bool = true
  
  /// The horizontal scroll indicator visibility of the grid.
  /// Defaults to `true`.
  public var showHorizontalScrollIndicator: Bool = true
  
  /// The corner radius of the grid.
  /// Defaults to `.medium`.
  public var cornerRadius: ComponentRadius = .medium
  
  /// A Boolean value indicating whether the grid is scrollable.
  /// Defaults to `true`.
  public var isScrollEnabled: Bool = true
  
  /// The background color of the grid.
  /// Defaults to `.clear`.
  public var backgroundColor: UniversalColor = .clear
  
  /// A Boolean value indicating whether the button is enabled or disabled.
  ///
  /// Defaults to `true`.
  public var isEnabled: Bool = true
  
  /// A Boolean value indicating whether the button is currently in a loading state.
  ///
  /// Defaults to `false`.
  public var isLoading: Bool = false
  
  /// The loading VM used for the loading indicator.
  ///
  /// If not provided, a default loading view model is used.
  public var loadingVM: LoadingVM?
  
  /// The source of the placeholder view to be displayed.
  public var placeholderView: UIView?
  
  public var cellIdentifier: String = "GridCell"
  
  public var cellNib: UINib?
  
  public var cellClass: UICollectionViewCell.Type = UICollectionViewCell.self
  
  /// Initializes a new instance of `GridVM` with default values.
  public init() {}
}

// MARK: Shared Helpers

extension GridVM {
  public var isInteractive: Bool {
    self.isEnabled && !self.isLoading
  }
  
  public var preferredLoadingVM: LoadingVM {
    return self.loadingVM ?? .init {
      $0.color = .init(
        main: .foreground,
        contrast: .background
      )
      $0.size = .small
    }
  }
  
  /// The padding of the grid items.
  /// Defaults to `.none`.
  public var padding: CGFloat {
    return switch self.size {
    case .small: 16
    case .medium: 24
    case .large: 32
    }
  }
  
  public func register(cellClass: AnyClass?, forCellWithReuseIdentifier identifier: String) -> GridVM {
    var copy = self
    if let cellClass = cellClass as? UICollectionViewCell.Type {
      copy.cellClass = cellClass
      copy.cellIdentifier = identifier
    }
    return copy
  }
  
  public func register(nib: UINib?, forCellWithReuseIdentifier identifier: String) -> GridVM {
    // You may want to store the nib if needed, add a property if so.
    var copy = self
    copy.cellNib = nib
    copy.cellIdentifier = identifier
    // Optionally: copy.cellNib = nib
    return copy
  }
}
