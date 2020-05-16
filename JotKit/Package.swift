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
    dependencies: [
        .package(url: "https://github.com/zorkdev/Splash.git", .branch("master"))
    ],
    targets: [
        .target(name: "JotKit", dependencies: ["Splash"]),
        .testTarget(name: "JotKitTests", dependencies: ["JotKit"])
    ]
)
