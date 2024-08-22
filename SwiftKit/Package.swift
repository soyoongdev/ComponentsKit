// swift-tools-version: 5.10

import PackageDescription

let package = Package(
    name: "SwiftKit",
    platforms: [.iOS(.v15), .macOS(.v12)],
    products: [
        .library(
            name: "SwiftKit",
            targets: ["SwiftKit"])
    ],
    targets: [
        .target(
            name: "SwiftKit")
    ]
)
