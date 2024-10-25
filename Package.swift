// swift-tools-version:5.9

import PackageDescription

let package = Package(
  name: "ComponentsKit",
  platforms: [
    .iOS(.v15)
  ],
  products: [
    .library(
      name: "ComponentsKit",
      targets: ["ComponentsKit"]
    )
  ],
  targets: [
    .target(
      name: "ComponentsKit"
    )
  ]
)
