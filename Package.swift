// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "SwiftAnalogCountdown",
    platforms: [.iOS(.v16), .macOS(.v14)],
    products: [
        .library(
            name: "SwiftAnalogCountdown",
            targets: ["SwiftAnalogCountdown"]),
    ],
    dependencies: [
        .package(url: "https://github.com/henrikhelmers/SwiftBlob", branch: "main"),
    ],
    targets: [
        .target(name: "SwiftAnalogCountdown", dependencies: ["SwiftBlob"])
    ]
)
