// swift-tools-version:5.9

import PackageDescription

let package = Package(
  name: "ComponentsKit",
  platforms: [
    .iOS(.v15),
    .watchOS(.v8),
    .macOS(.v12),
    .visionOS(.v1)
  ],
  products: [
    .library(
      name: "ComponentsKit",
      targets: ["ComponentsKit"]
    )
  ],
  dependencies: [
    .package(url: "https://github.com/componentskit/AutoLayout", from: "1.0.0"),
  ],
  targets: [
    .target(
      name: "ComponentsKit",
      dependencies: [
        .product(
          name: "AutoLayout",
          package: "AutoLayout",
          condition: .when(platforms: [
            .iOS,
            .watchOS,
            .visionOS,
            .macCatalyst
          ])
        )
      ],
      path: "Sources/ComponentsKit",
      resources: [
        .process("Resources/PrivacyInfo.xcprivacy")
      ]
    )
  ]
)
