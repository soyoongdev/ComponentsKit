// swift-tools-version:5.9

import PackageDescription

let package = Package(
  name: "SwiftComponents",
  platforms: [
    .iOS(.v15)
  ],
  products: [
    .library(
      name: "SwiftComponents",
      targets: ["SwiftComponents"]
    )
  ],
  targets: [
    .target(
      name: "SwiftComponents"
    )
  ]
)
