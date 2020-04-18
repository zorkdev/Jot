// swift-tools-version:5.2
import PackageDescription

let package = Package(
    name: "JotKit",
    platforms: [
        .iOS(.v13),
        .macOS(.v10_15)
    ],
    products: [
        .library(name: "JotKit", targets: ["JotKit"])
    ],
    dependencies: [],
    targets: [
        .target(name: "JotKit", dependencies: []),
        .testTarget(name: "JotKitTests", dependencies: ["JotKit"])
    ]
)
