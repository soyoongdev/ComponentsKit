import UIKit

extension UIColor {
  convenience init(hex: String) {
    let start: String.Index
    if hex.hasPrefix("#") {
      start = hex.index(hex.startIndex, offsetBy: 1)
    } else {
      start = hex.startIndex
    }

    let hexColor = String(hex[start...])
    let scanner = Scanner(string: hexColor)
    var hexNumber: UInt64 = 0

    if hexColor.count == 8 && scanner.scanHexInt64(&hexNumber) {
        let r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
        let g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
        let b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
        let a = CGFloat(hexNumber & 0x000000ff) / 255

        self.init(red: r, green: g, blue: b, alpha: a)
    } else {
      fatalError("Unable to initialize color from the provided hex value: \(hex)")
    }
  }
}
