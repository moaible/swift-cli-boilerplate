// swift-tools-version:5.2
// Managed by ice

import PackageDescription

let package = Package(
    name: "swift-cloud-kit",
    dependencies: [
        .package(url: "https://github.com/jakeheis/SwiftCLI", from: "6.0.2"),
    ],
    targets: [
        .target(name: "swift-cloud-kit", dependencies: ["SwiftCLI"]),
        .testTarget(name: "swift-cloud-kitTests", dependencies: ["swift-cloud-kit"]),
    ]
)
