import UIKit

public protocol UKComponent: UIView {
  associatedtype Model

  var model: Model { get set }

  func update(_ oldModel: Model)
}
