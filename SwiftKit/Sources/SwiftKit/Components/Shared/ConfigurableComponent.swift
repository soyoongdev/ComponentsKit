import Foundation

protocol ConfigurableComponent {
  associatedtype Model

  var model: Model { get set }

  func update(_ oldModel: Model?)
}
