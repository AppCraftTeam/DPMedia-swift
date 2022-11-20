// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "DPMedia",
    platforms: [
        .iOS(.v11),
    ],
    products: [
        .library(
            name: "DPMedia",
            targets: ["DPMedia"]
        ),
    ],
    targets: [
        .target(
            name: "DPMedia",
            path: "Sources/DPMedia",
            exclude: [
                "../../Demo"
            ]
        )
    ]
)
