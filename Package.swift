// swift-tools-version: 5.7

import PackageDescription

let package = Package(
  name: "Tree",
  products: [
    .library(name: "Tree", targets: ["Tree"]),
  ],
  dependencies: [
  ],
  targets: [
    .executableTarget(name: "ls-tree", dependencies: ["Tree"]),
    .target(
      name: "Tree",
      dependencies: []),
    .testTarget(
      name: "TreeTests",
      dependencies: ["Tree"]),
  ]
)
