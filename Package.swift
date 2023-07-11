// swift-tools-version:5.8

import PackageDescription

let package = Package(
    name: "EasyNetworkManager",
    platforms: [.iOS(.v14)],
    products: [
        .library(
            name: "EasyNetworkManager",
            targets: ["EasyNetworkManager"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "EasyNetworkManager",
            dependencies: []),
        .testTarget(
            name: "EasyNetworkManagerTests",
            dependencies: ["EasyNetworkManager"]),
    ]
)
