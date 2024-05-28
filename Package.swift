// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "DetailFeature",
    platforms: [
        .iOS(.v17), .macOS(.v14)
    ],
    products: [
        .library(
            name: "DetailFeature",
            targets: ["DetailFeature"]),
    ],
    dependencies: [
        .package(url: "https://github.com/Waffle000/Core.git", branch: "main")
    ],
    targets: [
        .target(
            name: "DetailFeature",
            dependencies: ["Core"]),
        .testTarget(
            name: "DetailFeatureTests",
            dependencies: ["DetailFeature"]),
    ]
)
