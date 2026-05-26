// swift-tools-version: 6.2

import PackageDescription

let swiftSettings: [SwiftSetting] = [
    .enableUpcomingFeature("ExistentialAny"),
]

let package = Package(
    name: "swift-calculator",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v26),
        .macOS(.v15),
    ],
    products: [
        .library(
            name: "CalculatorCore",
            targets: ["CalculatorCore"]
        ),
        .library(
            name: "CalculatorUI",
            targets: ["CalculatorUI"]
        ),
    ],
    targets: [
        .target(
            name: "CalculatorCore",
            swiftSettings: swiftSettings
        ),
        .target(
            name: "CalculatorUI",
            dependencies: ["CalculatorCore"],
            swiftSettings: swiftSettings
        ),
        .testTarget(
            name: "CalculatorUITests",
            dependencies: ["CalculatorUI"],
            swiftSettings: swiftSettings
        ),
    ]
)
