// swift-tools-version:5.0

import PackageDescription

let package = Package(
    name: "ShutterButton",
    platforms: [.iOS(.v10)],
    products: [
        .library(name: "ShutterButton", targets: ["ShutterButton"])
    ],
    targets: [
        .target(name: "ShutterButton")
    ]
)
