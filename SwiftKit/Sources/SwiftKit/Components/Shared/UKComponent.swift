import Foundation

public protocol UKComponent {
  associatedtype Model

  var model: Model { get set }

  func update(_ oldModel: Model)
}
