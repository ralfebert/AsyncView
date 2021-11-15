// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "AsyncView",
    platforms: [.iOS(.v15)],
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
