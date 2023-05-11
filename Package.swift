// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "SiopOpenID4VP",
  platforms: [.iOS(.v14)],
  products: [
    .library(
      name: "SiopOpenID4VP",
      targets: ["SiopOpenID4VP"]),
  ],
  dependencies: [
    .package(
      url: "https://github.com/kylef/JSONSchema.swift",
      from: "0.6.0"
    ),
    .package(
      url: "https://github.com/KittyMac/Sextant.git",
      .upToNextMinor(from: "0.4.0")
    ),
    .package(
      url: "https://github.com/realm/SwiftLint.git",
      .upToNextMinor(from: "0.51.0")
    ),
    .package(
      url: "https://github.com/airsidemobile/JOSESwift.git",
      .upToNextMinor(from: "2.4.0")
    ),
    .package(
      url: "https://github.com/birdrides/mockingbird.git",
      .upToNextMinor(from: "0.20.0")
    ),
    .package(
      url: "https://github.com/niscy-eudiw/presentation-exchange-swift.git",
      .upToNextMinor(from: "0.0.4")
    )
  ],
  targets: [
    .target(
      name: "SiopOpenID4VP",
      dependencies: [
        .product(
          name: "Sextant",
          package: "Sextant"
        ),
        .product(
          name: "JSONSchema",
          package: "JSONSchema.swift"
        ),
        .product(
          name: "JOSESwift",
          package: "JOSESwift"
        ),
        .product(
          name: "PresentationExchange",
          package: "presentation-exchange-swift"
        )
      ],
      path: "Sources",
      resources: [
        .process("Resources")
      ],
      plugins: [
        .plugin(name: "SwiftLintPlugin", package: "SwiftLint")
      ]
    ),
    .testTarget(
      name: "SiopOpenID4VPTests",
      dependencies: [
        "SiopOpenID4VP",
        .product(
          name: "Mockingbird",
          package: "mockingbird"
        ),
        .product(
          name: "JSONSchema",
          package: "JSONSchema.swift"
        ),
        .product(
          name: "Sextant",
          package: "Sextant"
        ),
        .product(
          name: "JOSESwift",
          package: "JOSESwift"
        ),
        .product(
          name: "PresentationExchange",
          package: "presentation-exchange-swift"
        )
      ],
      path: "Tests"
    ),
  ]
)
