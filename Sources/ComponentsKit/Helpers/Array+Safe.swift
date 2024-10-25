import Foundation

extension Array {
  /// Returns the element at the specified index iff it is within bounds, nil otherwise.
  /// Complexity: O(1).
  ///
  /// - Parameter index: The index of the element to be returned.
  /// - Returns: The value that corresponds to the index. nil if the value cannot be found.
  public subscript(safe index: Index) -> Iterator.Element? {
    return self.isIndexValid(index) ? self[index] : nil
  }

  /// Checks whether the index is valid for the array.
  /// Complexity: O(1).
  ///
  /// - Parameter index: The index to be checked.
  /// - Returns: true if the index is valid for the collection, false otherwise.
  public func isIndexValid(_ index: Index) -> Bool {
    return index >= self.startIndex && index < self.endIndex
  }
}
