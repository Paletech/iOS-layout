// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "iOS-layout",
    products: [
        .library(
            name: "LayoutKit",
            targets: ["LayoutKit"]),
    ],
    targets: [

        .target(
            name: "LayoutKit")
    ]
)
