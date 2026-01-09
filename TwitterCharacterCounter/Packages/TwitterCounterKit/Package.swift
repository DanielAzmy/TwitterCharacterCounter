// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "TwitterCounterKit",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(
            name: "TwitterCounterKit",
            targets: ["TwitterCounterKit"]
        )
    ],
    targets: [
        .target(
            name: "TwitterCounterKit",
            dependencies: []
        )
//        .testTarget(
//            name: "TwitterCounterKitTests",
//            dependencies: ["TwitterCounterKit"]
//        )
    ]
)
