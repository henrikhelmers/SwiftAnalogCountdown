// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "SwiftanalogCountdown",
    platforms: [.iOS(.v16), .macOS(.v14)],
    products: [
        .library(
            name: "SwiftanalogCountdown",
            targets: ["SwiftanalogCountdown"]),
    ],
    dependencies: [
        .package(url: "ssh://git@github.com/henrikhelmers/SwiftBlob", branch: "main")
    ],
    targets: [
        .target(name: "SwiftanalogCountdown")
    ]
)
