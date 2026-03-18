// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "shake_gesture_test_helper",
    platforms: [
        .iOS("13.0")
    ],
    products: [
        .library(name: "shake-gesture-test-helper", targets: ["shake_gesture_test_helper"])
    ],
    dependencies: [
        .package(name: "FlutterFramework", path: "../FlutterFramework")
    ],
    targets: [
        .target(
            name: "shake_gesture_test_helper",
            dependencies: [
                .product(name: "FlutterFramework", package: "FlutterFramework")
            ],
            resources: []
        )
    ]
)
