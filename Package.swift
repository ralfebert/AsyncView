// swift-tools-version:5.10

import PackageDescription

let package = Package(
    name: "AsyncView",
    platforms: [.iOS(.v17), .macOS(.v14)],
    products: [
        .library(
            name: "AsyncView",
            targets: ["AsyncView"]
        ),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "AsyncView",
            dependencies: []
        ),
    ]
)
